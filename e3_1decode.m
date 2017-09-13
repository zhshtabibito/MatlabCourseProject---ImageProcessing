clc; clear all; close all;
load('e3_1.mat');
% load('e3_1JPEG.mat');
[xLen,yLen] = size(hall_gray);
STX='00000010';  % start of text
ETX='00000011';  % end of text
cnt8=1;
cntRes=1;
res='';
ascii='';
flagBreak=false;
for x=1:xLen
    for y=1:yLen
        b=dec2bin(hall_gray(x,y));
        ascii=[ascii,b(end)];
        cnt8=cnt8+1;
        if(cnt8>8)
            cnt8=1;
            res=[res;ascii];
            if([x==1,y==8,ascii~=STX])
                res='';
                'No hidden info detected'
                flagBreak=true;
                break;
            end
            if(ascii==ETX)
                flagBreak=true;
                break;
            end
            ascii='';
        end        
    end
    if(flagBreak)
        break;
    end
end
dec=bin2dec(res);
hidden=char(dec)';
hidden=hidden(2:end-1)