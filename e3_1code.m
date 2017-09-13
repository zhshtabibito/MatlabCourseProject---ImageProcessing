% Hidden: "XinHaoYuXiTongHenYouQv"
clc; clear all; close all;
load('hall.mat');
[xLen,yLen] = size(hall_gray);
STX='00000010';  % start of text
ETX='00000011';  % end of text
text='XinHaoYuXiTongHenYouQv';
ascii=dec2bin(text);
[nChar,len]=size(ascii);
if(len<8)
    ascii=[char(ones(nChar,8-len).*48),ascii];
end
ascii=[STX;ascii;ETX];
nChar=nChar+2;
xHall=1; yHall=1;
for x=1:nChar
    for y=1:8
        if(yHall>yLen)
            xHall=xHall+1;
            yHall=1;
        end
        temp=dec2bin(hall_gray(xHall,yHall));
        temp(end)=ascii(x,y);
        hall_gray(xHall,yHall)=bin2dec(temp);
        yHall=yHall+1;
    end
end
save('e3_1.mat','hall_gray');