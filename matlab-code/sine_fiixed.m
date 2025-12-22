% Define the data
%x = randn(100,1);  % 100 random observations
x=(1:100)';
a = rand(1)*10;
b = rand(1)*10;
c = rand(1)*10;
d = rand(1)*10;
%y = a + b*sin(c + d*x);
y = a + b*sin(c + d*x) + randn(100,1)*0.5;  % noisy observations

% Fit a linear regression model to c + d*x
X1 = [ones(size(x)) x];
beta1 = X1 \ (c + d*x);

% Extract the coefficients of c and d
c_hat = beta1(1);
d_hat = beta1(2);

% Fit the full expression using the estimated coefficients
z1 = sin(c_hat + d_hat*x);
z2 = ones(size(x));
X2 = [z1 z2];
beta2 = X2 \ y;

% Extract the parameter estimates
a_hat = beta2(2);
b_hat = beta2(1);

% predict
f = a_hat + b_hat*sin(c_hat + d_hat*x);
mre=sum(abs(y-f))/sum(abs(y));

% Display the results
disp(['Estimated a = ' num2str(a_hat)])
disp(['Estimated b = ' num2str(b_hat)])
disp(['Estimated c = ' num2str(c_hat)])
disp(['Estimated d = ' num2str(d_hat)])
disp(['Estimated mre = ' num2str(mre)])

plot(f,'DisplayName','f');hold on;plot(y,'DisplayName','y');hold off;