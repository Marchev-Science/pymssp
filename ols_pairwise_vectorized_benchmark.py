"""Timing: OLS y ~ b0 + b1*x1 + b2*x2 for every column pair.

Explicit: Python double loop; Z = [1, X[:, i], X[:, j]], Z.T @ Z, solve.
Vectorized CPU: one Gram X.T @ X on CPU, batched A / b, lstsq.
Vectorized GPU: X and y stay on host; Gram is accumulated in CUDA row batches
                (same idea as src/ols.py PairwiseLinearRegression._incremental_gram_matrix),
                then A / b and lstsq on CUDA — no full-matrix X on device.
"""
import time
from itertools import combinations

import torch


def clear_gpu_state() -> None:
    if torch.cuda.is_available():
        torch.cuda.synchronize()
        torch.cuda.empty_cache()


COLS = 100
BYTES = 3 * 1024**3
N = BYTES // (4 * COLS)
DTYPE = torch.float32


def _gpu_gram_batch_rows(p: int, element_size: int, memory_fraction: float) -> int:
    """Max host rows to copy per chunk; heuristic from ols.PairwiseLinearRegression."""
    free, _ = torch.cuda.mem_get_info()
    max_bytes = int(free * memory_fraction)
    return max(1, max_bytes // (3 * p * element_size))


def incremental_gram_host_to_cuda(
    X: torch.Tensor,
    y: torch.Tensor,
    cuda_device: torch.device,
    memory_fraction: float = 0.9,
) -> tuple[torch.Tensor, torch.Tensor, torch.Tensor, torch.Tensor]:
    """Accumulate G, g, sx, sy on CUDA while X and y remain on CPU."""
    if X.device.type != "cpu" or y.device.type != "cpu":
        raise ValueError("incremental_gram_host_to_cuda expects X and y on CPU")
    n, p = X.shape[0], X.shape[1]
    dtype = X.dtype
    G = torch.zeros((p, p), dtype=dtype, device=cuda_device)
    g = torch.zeros((p,), dtype=dtype, device=cuda_device)
    sx = torch.zeros((p,), dtype=dtype, device=cuda_device)
    sy = torch.zeros((), dtype=dtype, device=cuda_device)
    element_size = X.element_size()
    start = 0
    while start < n:
        batch_rows = _gpu_gram_batch_rows(p, element_size, memory_fraction)
        batch_rows = min(batch_rows, n - start)
        end = start + batch_rows
        Xb = X[start:end].to(cuda_device, non_blocking=True)
        yb = y[start:end].to(cuda_device, non_blocking=True)
        G += Xb.T @ Xb
        g += Xb.T @ yb
        sx += Xb.sum(dim=0)
        sy += yb.sum()
        start = end
        torch.cuda.empty_cache()
    return G, g, sx, sy


def fit_ols_pairwise(X_ij: torch.Tensor, y: torch.Tensor) -> torch.Tensor:
    Z = torch.cat(
        [
            torch.ones((X_ij.shape[0], 1), dtype=X_ij.dtype, device=X_ij.device),
            X_ij,
        ],
        dim=1,
    )
    XtX = Z.T @ Z
    Xty = Z.T @ y
    return torch.linalg.solve(XtX, Xty)


def fit_all_pairs_vectorized(
    X: torch.Tensor,
    y: torch.Tensor,
    *,
    gram_on_cuda: bool = False,
    gpu_gram_memory_fraction: float = 0.9,
    cuda_device: torch.device | None = None,
) -> torch.Tensor:
    """All pair OLS. If ``gram_on_cuda``, Gram stats are streamed CPU→CUDA in batches."""
    n_rows, p = X.shape[0], X.shape[1]
    if gram_on_cuda:
        if not torch.cuda.is_available():
            raise RuntimeError("gram_on_cuda=True but CUDA is not available")
        dev = cuda_device or torch.device("cuda")
        G, g, sx, sy = incremental_gram_host_to_cuda(
            X, y, dev, memory_fraction=gpu_gram_memory_fraction
        )
        comp_dev = dev
    else:
        if X.device.type != "cpu":
            raise ValueError("CPU Gram path expects X on CPU")
        G = X.T @ X
        g = X.T @ y
        sx = X.sum(dim=0)
        sy = y.sum()
        comp_dev = X.device

    pairs = torch.tensor(list(combinations(range(p), 2)), dtype=torch.long, device=comp_dev)
    i, j = pairs[:, 0], pairs[:, 1]
    c = pairs.shape[0]

    A = torch.zeros((c, 3, 3), dtype=X.dtype, device=comp_dev)
    A[:, 0, 0] = float(n_rows)
    A[:, 0, 1] = sx[i]
    A[:, 0, 2] = sx[j]
    A[:, 1, 0] = sx[i]
    A[:, 1, 1] = G[i, i]
    A[:, 1, 2] = G[i, j]
    A[:, 2, 0] = sx[j]
    A[:, 2, 1] = G[j, i]
    A[:, 2, 2] = G[j, j]

    b = torch.zeros((c, 3), dtype=X.dtype, device=comp_dev)
    b[:, 0] = sy
    b[:, 1] = g[i]
    b[:, 2] = g[j]

    betas, *_ = torch.linalg.lstsq(A, b)
    return betas


def all_pairs_explicit_columns(X: torch.Tensor, y: torch.Tensor) -> torch.Tensor:
    p = X.shape[1]
    c = p * (p - 1) // 2
    out = torch.empty((c, 3), dtype=X.dtype, device=X.device)
    k = 0
    for i in range(p):
        for j in range(i + 1, p):
            out[k] = fit_ols_pairwise(X[:, [i, j]], y)
            k += 1
    return out


def assert_close(a: torch.Tensor, b: torch.Tensor, rtol: float = 1e-4, atol: float = 1e-4) -> None:
    if not torch.allclose(a.cpu(), b.cpu(), rtol=rtol, atol=atol):
        diff = (a.cpu() - b.cpu()).abs()
        raise RuntimeError(
            f"Coefficient mismatch: max abs diff {diff.max().item():.6g} "
            f"at flat index {diff.argmax().item()}"
        )


def run_benchmark(n: int, cols: int, dtype: torch.dtype, n_experiments: int = 3) -> None:
    print(f"X shape: ({n}, {cols}), ~{n * cols * dtype.itemsize / 1024**3:.2f} GiB")
    print(f"Column pairs: {cols * (cols - 1) // 2}")

    X = torch.randn(n, cols, dtype=dtype)
    y = torch.randn(n, dtype=dtype)

    times_cpu: list[float] = []
    times_gpu: list[float] = []
    cuda_ok = torch.cuda.is_available()
    if not cuda_ok:
        print("CUDA not available; only CPU vectorized will be timed.")

    for _ in range(n_experiments):
        t0 = time.perf_counter()
        betas_cpu = fit_all_pairs_vectorized(X, y, gram_on_cuda=False)
        t_cpu = time.perf_counter() - t0
        times_cpu.append(t_cpu)

        if cuda_ok:
            torch.cuda.synchronize()
            t0 = time.perf_counter()
            betas_gpu = fit_all_pairs_vectorized(X, y, gram_on_cuda=True)
            torch.cuda.synchronize()
            t_gpu = time.perf_counter() - t0
            times_gpu.append(t_gpu)
            assert_close(betas_cpu, betas_gpu)
        else:
            raise RuntimeError("CUDA not available")

        clear_gpu_state()

    print(f"Average CPU: {sum(times_cpu) / len(times_cpu):.3f}s ({' '.join(f'{t:.3f}s' for t in times_cpu)})")
    print(f"Average GPU: {sum(times_gpu) / len(times_gpu):.3f}s ({' '.join(f'{t:.3f}s' for t in times_gpu)})")
    print(f"Speedup CPU/GPU: {(sum(times_cpu) / len(times_cpu)) / (sum(times_gpu) / len(times_gpu)):.2f}x")


def rows_for_GB(target_gb: float, cols: int, dtype: torch.dtype) -> int:
    bytes_per_element = torch.tensor([], dtype=dtype).element_size()
    bytes_total = target_gb * 1024**3
    return int(bytes_total // (cols * bytes_per_element))


def main() -> None:
    n = 100_000
    X = torch.randn(n, COLS, dtype=DTYPE)
    y = torch.randn(n, dtype=DTYPE)
    t0 = time.perf_counter()
    all_pairs_explicit_columns(X, y)
    t_explicit = time.perf_counter() - t0
    print(f"Explicit (n = {n}): {t_explicit:.3f}s\n"+"-"*50)

    for n in [100_000, 1_000_000, 10_000_000, rows_for_GB(7, COLS, DTYPE)]:
        print(f"Running benchmark for n = {n}")
        run_benchmark(n, COLS, DTYPE, n_experiments=5)
        print("-" * 50)


if __name__ == "__main__":
    main()
