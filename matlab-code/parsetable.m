%url_string='https://webdiplomacy.net/board.php?gameID=112310';
% won: https://webdiplomacy.net/board.php?gameID=290367
% tie: http://webdiplomacy.net/board.php?gameID=112310
% not: https://webdiplomacy.net/board.php?gameID=290365


% urls{1,1}='https://webdiplomacy.net/board.php?gameID=290367';
% urls{2,1}='http://webdiplomacy.net/board.php?gameID=112310';
% urls{3,1}='https://webdiplomacy.net/board.php?gameID=290365';
urls{1,1}='https://webdiplomacy.net/board.php?gameID=290365';
urls{2,1}='https://webdiplomacy.net/board.php?gameID=290369';
urls{3,1}='https://webdiplomacy.net/board.php?gameID=290387';
urls{4,1}='https://webdiplomacy.net/board.php?gameID=290409';
urls{5,1}='https://webdiplomacy.net/board.php?gameID=290410';
urls{6,1}='https://webdiplomacy.net/board.php?gameID=290482';
urls{7,1}='https://webdiplomacy.net/board.php?gameID=290366';
urls{8,1}='https://webdiplomacy.net/board.php?gameID=290367';
urls{9,1}='https://webdiplomacy.net/board.php?gameID=290370';
urls{10,1}='https://webdiplomacy.net/board.php?gameID=290381';
urls{11,1}='https://webdiplomacy.net/board.php?gameID=290382';
urls{12,1}='https://webdiplomacy.net/board.php?gameID=290383';
urls{13,1}='https://webdiplomacy.net/board.php?gameID=290384';
urls{14,1}='https://webdiplomacy.net/board.php?gameID=290385';
urls{15,1}='https://webdiplomacy.net/board.php?gameID=290388';
urls{16,1}='https://webdiplomacy.net/board.php?gameID=290403';
urls{17,1}='https://webdiplomacy.net/board.php?gameID=290408';
urls{18,1}='https://webdiplomacy.net/board.php?gameID=290412';
urls{19,1}='https://webdiplomacy.net/board.php?gameID=290484';



%% format table
tvars={'player','status','country','centers','date','game','points'};
tvars_type={'string','string','string','uint16','string','string','uint16'};
gametable=table('Size',[0 7],'VariableTypes',tvars_type,'VariableNames',tvars);



for z=1:size(urls,1)
%   z=1;  
url_string=urls{z,1}

%% transliterate  
options=weboptions('CharacterEncoding','UTF-8');
feature('DefaultCharacterSet','UTF-8');
slCharacterEncoding('UTF-8');
content = webread(url_string,options);
stri=content;

stri = strrep(char(stri),'а','a');
stri = strrep(char(stri),'б','b');
stri = strrep(char(stri),'в','v');
stri = strrep(char(stri),'г','g');
stri = strrep(char(stri),'д','d');
stri = strrep(char(stri),'е','e');
stri = strrep(char(stri),'ж','j');
stri = strrep(char(stri),'з','z');
stri = strrep(char(stri),'и','i');
stri = strrep(char(stri),'й','j');
stri = strrep(char(stri),'к','k');
stri = strrep(char(stri),'л','l');
stri = strrep(char(stri),'м','m');
stri = strrep(char(stri),'н','n');
stri = strrep(char(stri),'о','o');
stri = strrep(char(stri),'п','p');
stri = strrep(char(stri),'р','r');
stri = strrep(char(stri),'с','s');
stri = strrep(char(stri),'т','t');
stri = strrep(char(stri),'у','u');
stri = strrep(char(stri),'ф','f');
stri = strrep(char(stri),'х','h');
stri = strrep(char(stri),'ц','c');
stri = strrep(char(stri),'ч','ch');
stri = strrep(char(stri),'ш','sh');
stri = strrep(char(stri),'щ','sht');
stri = strrep(char(stri),'ъ','a');
stri = strrep(char(stri),'ь','y');
stri = strrep(char(stri),'ю','yu');
stri = strrep(char(stri),'я','ya');
stri = strrep(char(stri),'А','A');
stri = strrep(char(stri),'Б','B');
stri = strrep(char(stri),'В','V');
stri = strrep(char(stri),'Г','G');
stri = strrep(char(stri),'Д','D');
stri = strrep(char(stri),'Е','E');
stri = strrep(char(stri),'Ж','J');
stri = strrep(char(stri),'З','Z');
stri = strrep(char(stri),'И','I');
stri = strrep(char(stri),'Й','J');
stri = strrep(char(stri),'К','K');
stri = strrep(char(stri),'Л','L');
stri = strrep(char(stri),'М','M');
stri = strrep(char(stri),'Н','N');
stri = strrep(char(stri),'О','O');
stri = strrep(char(stri),'П','P');
stri = strrep(char(stri),'Р','R');
stri = strrep(char(stri),'С','S');
stri = strrep(char(stri),'Т','T');
stri = strrep(char(stri),'У','U');
stri = strrep(char(stri),'Ф','F');
stri = strrep(char(stri),'Х','H');
stri = strrep(char(stri),'Ц','C');
stri = strrep(char(stri),'Ч','CH');
stri = strrep(char(stri),'Ш','SH');
stri = strrep(char(stri),'Щ','SHT');
stri = strrep(char(stri),'Ъ','A');
stri = strrep(char(stri),'Ь','Y');
stri = strrep(char(stri),'Ю','YU');
stri = strrep(char(stri),'Я','YA');

mypage=stri;

%% extract values for all games
pattern21 = '<span class="gamePhase">';
pattern22 = '</span>';
gamephase = extractBetween(mypage, pattern21, pattern22);

pattern1 = '<a href="profile.php?userID=';
pattern2 = '</a>';
player = extractBetween(mypage, pattern1, pattern2);
player=extractAfter(player,'">');

pattern3 = 'class="memberStatus"><em>';
pattern4 = '</em>';
pstatus = extractBetween(mypage, pattern3, pattern4);

pattern5 = '<span class="memberSCCount"><em>';
pattern6 = '</em>';
centers = extractBetween(mypage, pattern5, pattern6);

if size(centers,1)<7
    for i=size(centers,1)+1:7
        centers{i}='0';
    end
end

pattern9 = '<span class="gameName">';
pattern10 = '</span>';
game = extractBetween(mypage, pattern9, pattern10);

pattern11 = '<span class="gameDate">';
pattern12 = '</span>';
date = extractBetween(mypage, pattern11, pattern12);

for i=2:7
    date{i,1}=date{1};
end

pattern7 = '<span class="memberCountryName">';
pattern8 = '</span>';
country = extractBetween(mypage, pattern7, pattern8);
country=extractAfter(country,'">');

%% extract values for finished games
if strcmp(gamephase{1},'Finished')==1
pattern13 = 'Civil Disorders</div><table><tbody>';
pattern14 = '</td></tr></tbody></table>';
leftsection = extractBetween(mypage, pattern13, pattern14);

pattern15 = '<span class="country';
pattern16 = '</span>';
leftcountry = extractBetween(leftsection, pattern15, pattern16);
leftcountry=extractAfter(leftcountry,'">');

pattern17 = '</span> (';
pattern18 = ')';
leftdate = extractBetween(leftsection, pattern17, pattern18);

pattern19 = ') with ';
pattern20 = ' centres.';
leftcenter = extractBetween(leftsection, pattern19, pattern20);

if strcmp(pstatus{1},'Won')==1
    player(1)=[];
end

for i=2:size(player,1)
    game{i,1}=game{1};
end

points=zeros(size(player,1),1);

if size(player,1)>7
    for i=8:size(player,1)
        pstatus{i,1}='Left';
        points(i,1)=0;
    end
    country=[country;leftcountry];
    date=[date;leftdate];
    centers=[centers;leftcenter];
end

else
%% extract values for unfinished games
pattern23 = '  memberStatusPlaying">';
pattern24 = '</span>';
country_tmp = extractBetween(mypage, pattern23, pattern24);

for i=2:size(player,1)
    game{i,1}=game{1};
end

points=zeros(size(player,1),1);

for i=1:size(country_tmp,1)
    country{i,1}=country_tmp{i,1};
end
   
for i=1:7-size(pstatus,1)
    pstatus_tmp{i,1}='Drawn';    
end

pstatus=[pstatus_tmp;pstatus];

end

centers_tmp=str2double(centers);
centers_tmp(8:end)=0;
[~,rank_cent]=ismember(centers_tmp,sort(centers_tmp,'descend'));
points=str2double(points);

%% points for won games
if strcmp(pstatus{1},'Won')==1

    for i=1:size(player,1)
        if str2num(date{i,1}(end-4:end))>1903
            points_part=4;
        else
            points_part=0;
        end

        if rank_cent(i)==1
            points_class=6;
        elseif rank_cent(i)==2 && size(player,1)
            points_class=4;
        elseif rank_cent(i)==3 && or(strcmp(pstatus{i,1},'Survived')==1, strcmp(pstatus{i,1},'Resigned')==1)
            points_class=3;
        elseif rank_cent(i)==4 && or(strcmp(pstatus{i,1},'Survived')==1, strcmp(pstatus{i,1},'Resigned')==1)
            points_class=2;
        elseif rank_cent(i)==5 && or(strcmp(pstatus{i,1},'Survived')==1, strcmp(pstatus{i,1},'Resigned')==1)
            points_class=1;
        else
            points_class=0;
        end

        points(i,1)=points_part+points_class;
        
        if strcmp(pstatus{i,1},'Left')==1
            points(i,1)=2;
        end

    end

else
    for i=1:size(player,1)
    
        if str2num(date{i,1}(end-4:end))>1903
            points_part=4;
        else
            points_part=0;
        end

        if rank_cent(i)==1
            points_class=4;
        elseif rank_cent(i)==2 && strcmp(pstatus{i,1},'Defeated')==0
            points_class=3;
        elseif rank_cent(i)==3 && strcmp(pstatus{i,1},'Defeated')==0
            points_class=2;
        elseif rank_cent(i)==4 && strcmp(pstatus{i,1},'Defeated')==0
            points_class=1;
        else
            points_class=0;
        end

        points(i,1)=points_part+points_class;
        
       if strcmp(pstatus{i,1},'Left')==1 && strcmp(gamephase{1},'Finished')==1
            points(i,1)=2;
       end
    end
    
end

points=num2cell(points);
centers=num2cell(centers);

game_info = [player, pstatus, country, centers, date, game, points];

tabinf=cell2table(game_info,'VariableNames',tvars);

gametable= [gametable;tabinf];

clearvars -except urls gametable tvars
end

gametable;

writetable(gametable,'2020-05-webdiplomacy.xlsx');
