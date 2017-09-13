clc; clear all; close all;
load('hall.mat');
load('jpegcodes6.mat');
load('JpegCoeff.mat');
zigzag=zeros(64,xLen*yLen/64);
% DC
head=1;
cntBlock=1;
lenDC=length(DC);
while(head<=lenDC)
    for category=0:11
        len=DCTAB(category+1,1);
        if(DC(head:(head+len-1))==DCTAB(category+1,2:1+len))
            % right category
            head=head+len;
            code=DC(head:head+max(category,1)-1);
            head=head+max(category,1);
            if(category==0)
                zigzag(1,cntBlock)=0;
            elseif(code(1)==0)  % negative
                code=1-code;
                x=-bin2dec(num2str(code));
                zigzag(1,cntBlock)=x;
            else  % positive
                x=bin2dec(num2str(code));
                zigzag(1,cntBlock)=x;
            end
            cntBlock=cntBlock+1;
            break;
        end
    end
end
for cntBlock=2:(xLen*yLen/64)
    zigzag(1,cntBlock)=zigzag(1,cntBlock-1)-zigzag(1,cntBlock);
end
% AC
head=1;
headB=2;
cntBlock=1;
lenAC=length(AC);
EOB=[1,0,1,0];
ZRL=[1,1,1,1,1,1,1,1,0,0,1];
while(head<=lenAC)
    if(AC(head:head+3)==EOB)  % EOB
        head=head+4;
        cntBlock=cntBlock+1;
        headB=2;
        continue;
    elseif(AC(head:head+10)==ZRL)
        head=head+11;
        headB=headB+16;
        continue;
    else
        for RunSize=1:160
            len=ACTAB(RunSize,3);
            % 解决结尾时对比Huffman码越界问题
            if(head+len-1>lenAC)
                continue;
            end
            if(AC(head:(head+len-1))==ACTAB(RunSize,4:(4+len-1)))  % right RunSize
                head=head+len;
                Run=ACTAB(RunSize,1);
                headB=headB+Run;
                Size=ACTAB(RunSize,2);
                code=AC(head:(head+Size-1));
                head=head+Size;
                if(code(1)==0)  % negative
                    code=1-code;
                    x=-bin2dec(num2str(code));
                    zigzag(headB,cntBlock)=x;
                else  % positive
                    x=bin2dec(num2str(code));
                    zigzag(headB,cntBlock)=x;
                end
                % for_test=[headB,cntBlock]
                headB=headB+1;
                break;
            end         
        end
        continue;    
    end  
end

STX='00000010';  % start of text
ETX='00000011';  % end of text
cnt8=1;
res='';
ascii='';
flagNotOver=true;

myHall=zeros(xLen,yLen);
cntBlock=1;
D=zeros(8,8);
for x = 1:xLen/8
    for y = 1:yLen/8
        if(flagNotOver)
            yy=find(zigzag(:,cntBlock),1,'last');
            if(zigzag(yy,cntBlock)==1)
                ascii=[ascii,'1'];
            else
                ascii=[ascii,'0'];
            end
            if(cnt8==8)
                res=[res;ascii];
                if(ascii==ETX)
                    flagNotOver=false;
                end
                cnt8=1;
                ascii='';
            else
                cnt8=cnt8+1;
            end
        end
        D=antiZigZag(zigzag(:,cntBlock));  
        D=D.*QTAB;
        myHall(8*x-7:8*x,8*y-7:8*y)=idct2(D);
        cntBlock=cntBlock+1;
    end
end
myHall=uint8(round(myHall+128));
dec=bin2dec(res);
hidden=char(dec)';
hidden=hidden(2:end-1)
%PSNR
MSE=sum(sum((double(hall_gray)-double(myHall)).^2))/xLen/yLen;
PSNR=10*log10(255*255/MSE)
