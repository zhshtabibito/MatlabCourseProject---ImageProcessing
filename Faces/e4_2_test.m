clc; clear; close all;
load('v.mat'); load('e.mat');
% to change
L=4; v=v4; e=e4;
block=30;

shift=8-L;
filename='test.bmp';
face=imread(filename);
%face=imrotate(face,-90);
[xLen,yLen,~]=size(face);
face=imresize(face,[xLen yLen*2]);
%face=imadjust(face,[.2 .3 0; .6 .7 1],[]);

[xLen,yLen,~]=size(face);
res=zeros(floor(xLen/block),floor(yLen/block));
for x=1:xLen/block
    for y=1:yLen/block
        u=zeros(1,2^(3*L));
        D1=face((x*block-block+1):(x*block),(y*block-block+1):(y*block),1);
        D2=face((x*block-block+1):(x*block),(y*block-block+1):(y*block),2);
        D3=face((x*block-block+1):(x*block),(y*block-block+1):(y*block),3);
        for xx=1:block
            for yy=1:block
                R=bitshift(D1(xx,yy),-shift);
                G=bitshift(D2(xx,yy),-shift);
                B=bitshift(D3(xx,yy),-shift);
                n=bitshift(R,2*L)+bitshift(G,L)+B;
                u(n+1)=u(n+1)+1;  % n 0~255
            end
        end
        u=u./(block*block);
        d=1-sqrt(u)*(sqrt(v))';
        if(d<=e)
            res(x,y)=1;
        end
    end
end
for x=1:xLen/block
    for y=1:yLen/block
        if(res(x,y)==1)
            if(res(x,y+1)==1 && res(x+1,y)==1)
                cntX=1; cntY=1;
                %while(res(x+cntX+1,y)==1||res(x+cntX+1,y+1)==1)
                while(res(x+cntX+1,y)==1)
                    cntX=cntX+1;
                end
                %while(res(x,y+cntY+1)==1||res(x+1,y+cntY+1)==1)
                while(res(x,y+cntY+1)==1)
                    cntY=cntY+1;
                end
                res(x:(x+cntX),y:(y+cntY))=0;
                face(x*block-block+1,(y*block-block+1):((y+cntY)*block),1)=255;
                face(x*block-block+1,(y*block-block+1):((y+cntY)*block),2)=0;
                face(x*block-block+1,(y*block-block+1):((y+cntY)*block),3)=0;
                face((x+cntX)*block,(y*block-block+1):((y+cntY)*block),1)=255;
                face((x+cntX)*block,(y*block-block+1):((y+cntY)*block),2)=0;
                face((x+cntX)*block,(y*block-block+1):((y+cntY)*block),3)=0;
                face((x*block-block+1):((x+cntX)*block),y*block-block+1,1)=255;
                face((x*block-block+1):((x+cntX)*block),y*block-block+1,2)=0;
                face((x*block-block+1):((x+cntX)*block),y*block-block+1,3)=0;
                face((x*block-block+1):((x+cntX)*block),(y+cntY)*block,1)=255;
                face((x*block-block+1):((x+cntX)*block),(y+cntY)*block,2)=0;
                face((x*block-block+1):((x+cntX)*block),(y+cntY)*block,3)=0;
            end
        end
    end
end
imshow(face);
%imwrite(face,'e4_2.bmp','bmp');
%imwrite(face,'e4_3_1.bmp','bmp');
imwrite(face,'e4_3_2.bmp','bmp');
%imwrite(face,'e4_3_3.bmp','bmp');
