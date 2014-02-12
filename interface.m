datafilename = strcat('a','.dat'); % name of data file to write to

datafilepointer = fopen(datafilename,'wt'); % open ASCII file for writing


load('deck_A.mat');
load('deck_B.mat');
load('deck_C.mat');
load('deck_D.mat');
total_cards = size(deck_A,2);


deck = {deck_A; deck_B; deck_C; deck_D};

cash = 2000;

screens=Screen('Screens');
curScreen=max(screens);
w = Screen('OpenWindow',curScreen,[250 249 222]);
KbName('UnifyKeyNames');
EscapeKey=KbName('ESCAPE');
total_trials =3;
font =Screen('TextFont', w ,'Î¢ÈíÑÅºÚ');

black_imdata = imread('3.png');
red_imdata = imread('4.png');
front_imdata = imread('front.png');
tex = [0 0 0 0];
for i =1:4
    if deck{i}{1}(1) ==1
        tex(i)= Screen('MakeTexture', w, red_imdata); 
    else
        tex(i)= Screen('MakeTexture', w, black_imdata);
    end
end


for trials=1:total_trials

Screen('TextStyle', w ,1);
Screen('TextSize',w,30);
rect = [175 650 1125 1600; 300 300 300 300; 475 950 1425 1900; 600 600 600 600];
Screen('DrawTextures', w, tex, [],rect);
str0 = double(sprintf('³éÅÆ')); 
str4 = double(sprintf('×Ü·Ö: %i',cash));
str5 = double(sprintf('%i / 50 ¿¨Æ¬',trials));
DrawFormattedText(w, str0, 'center', 800, BlackIndex(w));
DrawFormattedText(w, str4, 'center', 250, BlackIndex(w));
DrawFormattedText(w, str5, 'center', 200, BlackIndex(w));
start_time = Screen('Flip',w);


while 1
[clicks,x,y] = GetClicks(w);
    flag = 1;
    if rect(1,1)<x && x<rect(3,1) && rect(2,1)<y&& y<rect(4,1)
         which_deck =1;
    elseif rect(1,2)<x&&x<rect(3,2) && rect(2,2)<y&&y<rect(4,2)
        which_deck =2;
    elseif rect(1,3)<x&&x<rect(3,3) && rect(2,3)<y&&y<rect(4,3)
        which_deck=3;
    elseif rect(1,4)<x&&x<rect(3,4) && rect(2,4)<y&&y<rect(4,4)
        which_deck=4;
    else
        flag = 0;
    end
    if clicks~=0 && flag==1
        click_time = GetSecs;
        break;
    end
end

 color = deck{which_deck}{1}(1);
    reward = deck{which_deck}{1}(2);
    punish = deck{which_deck}{1}(3);
    cash = cash + reward + punish;
    deck{which_deck}(1) = [];
for i =1:4
    if deck{i}{1}(1) ==1
        tex(i)= Screen('MakeTexture', w, red_imdata);
    else
        tex(i)= Screen('MakeTexture', w, black_imdata);
    end
end
Screen('DrawTextures', w, tex, [],rect);
front_tex = Screen('MakeTexture',w,front_imdata);
Screen('DrawTexture',w,front_tex,[],rect(:,which_deck));
str2 = double(sprintf('+%i·Ö',reward));
str3 = double(sprintf('-%i·Ö',abs(punish)));
str4 = double(sprintf('×Ü·Ö: %i',cash));
str5 = double(sprintf('%i / 50 ¿¨Æ¬',trials));
str6 = double(sprintf('¼ÌÐø'));
str7 = double(sprintf('²âÊÔ½áÊø£¬Ð»Ð»²ÎÓë'));

% DrawFormattedText(w, str, 'center', 700, BlackIndex(w));
Screen('TextSize',w,19);
DrawFormattedText(w, str2, (rect(3,which_deck)-rect(1,which_deck))*0.3+rect(1,which_deck), (rect(4,which_deck)-rect(2,which_deck))*0.4+rect(2,which_deck), [9 175 158]);
DrawFormattedText(w, str3, (rect(3,which_deck)-rect(1,which_deck))*0.3+rect(1,which_deck), (rect(4,which_deck)-rect(2,which_deck))*0.5+rect(2,which_deck), [236 87 78]);
Screen('TextSize',w,30);
DrawFormattedText(w, str4, 'center', 250, BlackIndex(w));
DrawFormattedText(w, str5, 'center', 200, BlackIndex(w));
Screen('TextStyle',w,4+1);
[nx,ny]=DrawFormattedText(w, str6, 'center', 800, BlackIndex(w));

Screen('Flip', w);

while 1
[clicks,x,y] = GetClicks(w);
    flag = 1;
    if 900<x && x<1020 && 770<y&& y<860
         which_deck =1;
    else
        flag = 0;
    end
    if clicks~=0 && flag==1
        click_time = GetSecs;
        break;
    end
end


response_time = click_time-start_time;
now_cards = size(deck{which_deck},2);
card_num = total_cards - now_cards;
fprintf(datafilepointer,'%g %g %g %g %g %g %g\n', ...
            trials, ...
            which_deck, ...
            card_num, ...
            color,...
            reward,...
            punish,...
            response_time)
end
Screen('TextStyle',w,0)
DrawFormattedText(w, str7, 'center', 'center', BlackIndex(w));
Screen('Flip',w);
while 1
      [KeyIsDown, endrt, KeyCode]=KbCheck;
            if KeyIsDown
                if KeyCode(EscapeKey)
                    Screen('CloseAll');
                    fclose('all');
                    break
                end
            end
end
