raw_deck_A = dlmread('deck_A.dat');
raw_deck_B = dlmread('deck_B.dat');
raw_deck_C = dlmread('deck_C.dat');
raw_deck_D = dlmread('deck_D.dat');

for i=1:40
    
        deck_A{i}(1) = raw_deck_C(i,1);
        deck_A{i}(2) = raw_deck_C(i,2);
        deck_A{i}(3) = raw_deck_C(i,3);
end

for i=1:40
    
        deck_B{i}(1) = raw_deck_D(i,1);
        deck_B{i}(2) = raw_deck_D(i,2);
        deck_B{i}(3) = raw_deck_D(i,3);
end

for i=1:40    
        deck_C{i}(1) = raw_deck_A(i,1);
        deck_C{i}(2) = raw_deck_A(i,2);
        deck_C{i}(3) = raw_deck_A(i,3);
end


for i=1:40
        deck_D{i}(1) = raw_deck_B(i,1);
        deck_D{i}(2) = raw_deck_B(i,2);
        deck_D{i}(3) = raw_deck_B(i,3);
end
total_cards = size(deck_A,2);
have_cards = [1 1 1 1];
which_deck = 1;

deck = {deck_A; deck_B; deck_C; deck_D};

cash = 2000;
cash_previous = 2000;

screens=Screen('Screens');
curScreen=max(screens);
[w,wrect] = Screen('OpenWindow',curScreen,[250 249 222]);
KbName('UnifyKeyNames');
EscapeKey=KbName('ESCAPE');
font =Screen('TextFont', w ,'微软雅黑');



black_imdata = imread('static\3.png');
% red_imdata = imread('4.png');
front_red = imread('static\red.png');
front_black = imread('static\black.png');
front_nocard = imread('static\nocard.png');
tex = [0 0 0 0];
for i =1:4
        tex(i)= Screen('MakeTexture', w, black_imdata); 
end

width = wrect(3);
height = wrect(4);
h1_str = 3/4*height;
h4_str = 0.18*height;
h3_str = 0.13*height;
h2_str = 0.23*height;

str11 = 'A';
str12 = 'B';
str13 = 'C';
str14 = 'D';


str9 = double(sprintf('Name:'));
% str8 = double(sprintf('Trials:'));
subject_name = GetEchoString(w,str9,width/3,height/2,[0 0 0],[250 249 222]);
Screen('Flip',w);
% total_trials = GetEchoNumber(w,str8,width/3,height/2,[0 0 0],[]);
% Screen('Flip',w);
datafilename =  strcat('data\',subject_name,'.dat'); % name of data file to write to

datafilepointer = fopen(datafilename,'wt'); % open ASCII file for writing
left_border = (width - 300*4)/4;
step_l = 300 + left_border;
top_border = 0.278 * height;
bottom_border = top_border+300;
h5_str = bottom_border;

click_width = width/2 - 60;
click_height = h1_str +60; 
% soundfile = 'slot.wav';
%%%%%%%%%%%%%%%%%%%%%%%%%
% for x_count=1:37
%     deck{1}(1) = [];
%     deck{2}(1) = [];
%     deck{3}(1) = [];
%     deck{4}(1) = [];
% end
%%%%%%%%%%%%%%%%%%%%%%%%%
total_trials = 100;
for trials=1:total_trials

Screen('TextStyle', w ,1);
Screen('TextSize',w,30);
rect = [left_border left_border+step_l left_border+2*step_l left_border+3*step_l; top_border top_border top_border top_border; step_l 2*step_l 3*step_l 4*step_l; bottom_border bottom_border bottom_border bottom_border];
Screen('DrawTextures', w, tex, [],rect);

for which  = 1:4
    if have_cards(which) ==0
        nocard_tex = Screen('MakeTexture',w,front_nocard);
        Screen('DrawTexture',w,nocard_tex,[],rect(:,which));
    end
end

str0 = double(sprintf('抽牌')); 
str4 = double(sprintf('总分: %i',cash));
str10 = double(sprintf('上轮总分: %i',cash_previous));
str5 = double(sprintf('%i / %i 卡片',trials,total_trials));
DrawFormattedText(w, str0, 'center', h1_str, BlackIndex(w));
DrawFormattedText(w, str4, 'center', h2_str, BlackIndex(w));
DrawFormattedText(w, str5, 'center', h3_str, BlackIndex(w));
DrawFormattedText(w, str10, 'center', h4_str, BlackIndex(w));
DrawFormattedText(w, str11, left_border+120, h5_str, BlackIndex(w));
DrawFormattedText(w, str12, left_border+step_l+120, h5_str, BlackIndex(w));
DrawFormattedText(w, str13, left_border+2*step_l+120, h5_str, BlackIndex(w));
DrawFormattedText(w, str14, left_border+3*step_l+120, h5_str, BlackIndex(w));
start_time = Screen('Flip',w);


while 1
[clicks,x,y] = GetClicks(w);
    flag = 1;
    [KeyIsDown, endrt, KeyCode]=KbCheck;
    if KeyIsDown      
        if KeyCode(EscapeKey)
            Screen('CloseAll');
            fclose('all');
            return   
        end
    end
    if rect(1,1)<x && x<rect(3,1) && rect(2,1)<y&& y<rect(4,1)&& have_cards(1)
         which_deck =1;
    elseif rect(1,2)<x&&x<rect(3,2) && rect(2,2)<y&&y<rect(4,2)&& have_cards(2)
        which_deck =2;
    elseif rect(1,3)<x&&x<rect(3,3) && rect(2,3)<y&&y<rect(4,3)&& have_cards(3)
        which_deck=3;
    elseif rect(1,4)<x&&x<rect(3,4) && rect(2,4)<y&&y<rect(4,4)&&have_cards(4)
        which_deck=4;
    else
        flag = 0;
    end
    if clicks~=0 && flag==1
        click_time = GetSecs;
        break;
    end
end

% which_deck = ceil(4*rand);
 color = deck{which_deck}{1}(1);
    reward = deck{which_deck}{1}(2);
    punish = deck{which_deck}{1}(3);
    cash_previous = cash;
    cash = cash + reward + punish;
    deck{which_deck}(1) = [];
    s = size(deck{which_deck});
    if s(2) ==0
        have_cards(which_deck) =0;
    end
for i =1:4
        tex(i)= Screen('MakeTexture', w, black_imdata);
end
Screen('DrawTextures', w, tex, [],rect);

for which  = 1:4
    if have_cards(which) ==0
        nocard_tex = Screen('MakeTexture',w,front_nocard);
        Screen('DrawTexture',w,nocard_tex,[],rect(:,which));
    end
end

if color ==1
    front_tex = Screen('MakeTexture',w,front_red);
else
    front_tex = Screen('MakeTexture',w,front_black);
end
Screen('DrawTexture',w,front_tex,[],rect(:,which_deck));



str2 = double(sprintf('+%i分',reward));
str3 = double(sprintf(' -%i分',abs(punish)));
str4 = double(sprintf('总分: %i',cash));
str5 = double(sprintf('%i / %i 卡片',trials,total_trials));
str6 = double(sprintf('继续'));
str7 = double(sprintf('测试结束，谢谢参与'));
str10 = double(sprintf('上轮总分: %i',cash_previous));

% DrawFormattedText(w, str, 'center', 700, BlackIndex(w));
Screen('TextSize',w,25);
DrawFormattedText(w, str2, (rect(3,which_deck)-rect(1,which_deck))*0.3+rect(1,which_deck), (rect(4,which_deck)-rect(2,which_deck))*0.4+rect(2,which_deck), [255 255 255]);
if punish ~= 0
    DrawFormattedText(w, str3, (rect(3,which_deck)-rect(1,which_deck))*0.3+rect(1,which_deck), (rect(4,which_deck)-rect(2,which_deck))*0.5+rect(2,which_deck), [255 255 255]);
end


Screen('TextSize',w,30);
DrawFormattedText(w, str4, 'center', h2_str, BlackIndex(w));
DrawFormattedText(w, str5, 'center', h3_str, BlackIndex(w));
DrawFormattedText(w, str10, 'center', h4_str, BlackIndex(w));
Screen('TextStyle',w,1);
Screen('FillRect',w,[44 62 80],[width/2-120;height*0.75;width/2+120;height*0.75+60],4)
DrawFormattedText(w, str6, 'center', h1_str, WhiteIndex(w));
DrawFormattedText(w, str11, left_border+120, h5_str, BlackIndex(w));
DrawFormattedText(w, str12, left_border+step_l+120, h5_str, BlackIndex(w));
DrawFormattedText(w, str13, left_border+2*step_l+120, h5_str, BlackIndex(w));
DrawFormattedText(w, str14, left_border+3*step_l+120, h5_str, BlackIndex(w));

Screen('Flip', w);

while 1
[clicks,x,y] = GetClicks(w);
    flag = 0;
    if width/2-120<x && x<width/2+120 && height*0.75<y&& y<height*0.75+60
         flag=1;
    end
    if clicks~=0 && flag==1
        click_time = GetSecs;
        break;
    end
end


response_time = click_time-start_time;
% response_time = rand;
now_cards = size(deck{which_deck},2);
card_num = total_cards - now_cards;
fprintf(datafilepointer,'%g %g %g %g %g %g %g %g\n', ...
            trials, ...
            which_deck, ...
            card_num, ...
            color,...
            reward,...
            punish,...
            cash,...
            response_time);
end
Screen('TextStyle',w,1)
DrawFormattedText(w, str7, 'center', 'center', BlackIndex(w));
Screen('Flip',w);

while 1
      [KeyIsDown, endrt, KeyCode]=KbCheck;
            if KeyIsDown                
                    Screen('CloseAll');
                    fclose('all');
                    break               
            end
end
