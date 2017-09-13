clc; clear all; close all;
load('e3_1.mat');
load('JpegCoeff.mat');
hall_gray = double(hall_gray)-128;
% hall_gray = hall_gray-128;
[xLen,yLen] = size(hall_gray);  %x行数y列数
zigzag = zeros(64,(xLen/8)*(yLen/8));
cntBlock = 1;
for x = 1:xLen/8
    for y = 1:yLen/8
        D = dct2(hall_gray(8*x-7:8*x,8*y-7:8*y));
        D = round(D./QTAB);
        zigzag(:,cntBlock) = ZigZag(D);
        cntBlock=cntBlock+1;
    end
end
cntBlock = cntBlock-1;
% DC
CD = zigzag(1,:);
CD(2:cntBlock)= CD(1:(cntBlock-1))-CD(2:cntBlock);
DC=[];
for i=1:cntBlock
    ctg=Category(CD(i));
    len=DCTAB(ctg+1,1);
    % code=bitget(abs(CD(i)),max(ctg,1):-1:1);
    code=fliplr(bitget(abs(CD(i)),1:max(ctg,1)));
    if(CD(i)<0)
        code=1-code;
    end
    DC=[DC,DCTAB(ctg+1,2:1+len),code];
end
%AC
AC=[];
EOB=[1,0,1,0];
ZRL=[1,1,1,1,1,1,1,1,0,0,1];
for i=1:cntBlock
    cnt0=0;
    for j=2:64
        if(zigzag(j,i)==0)
            if(j==64)
 %               AC=[AC,EOB];
                continue;
            end
            cnt0=cnt0+1;
        else  %zigzag(j,i)~=0
            %Run=cnt0, Size=Category, Amp=xxx
            Size=Category(zigzag(j,i));
            if(cnt0>15)
                while(cnt0>15)
                    AC=[AC,ZRL];
                    cnt0=cnt0-16;
                end
            end
            codeLen=ACTAB(10*cnt0+Size,3);
            % code=fliplr(bitget(abs(zigzag(j,i)),1:Size));
            code=bitget(abs(zigzag(j,i)),Size:-1:1);
            if(zigzag(j,i)<0)
                code=1-code;
            end
            AC=[AC,ACTAB(10*cnt0+Size,4:(3+codeLen)),code];
            cnt0=0;
        end        
    end
    AC=[AC,EOB];
end
save('jpegcodes4.mat','DC','AC','xLen','yLen');


clc; clear all; close all;
load('hall.mat');
load('jpegcodes4.mat');
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
myHall=zeros(xLen,yLen);
cntBlock=1;
D=zeros(8,8);
for x = 1:xLen/8
    for y = 1:yLen/8
        D=antiZigZag(zigzag(:,cntBlock));
        D=D.*QTAB;
        myHall(8*x-7:8*x,8*y-7:8*y)=idct2(D);
        cntBlock=cntBlock+1;
    end
end
hall_gray=uint8(round(myHall+128));
save('e3_1JPEG.mat','hall_gray');


function res = antiZigZag(vec)
res=zeros(8,8);
Hash=[1, 2, 6, 7, 15,16,28,29;
      3, 5, 8, 14,17,27,30,43;
      4, 9, 13,18,26,31,42,44;
      10,12,19,25,32,41,45,54;
      11,20,24,33,40,46,53,55;
      21,23,34,39,47,52,56,61;
      22,35,38,48,51,57,60,62;
      36,37,49,50,58,59,63,64];
for row=1:8
    for col=1:8
        res(row,col)=vec(Hash(row,col));
    end
end
end
