clc; clear all; close all;
load('hall.mat');
load('JpegCoeff.mat');
[xLen,yLen] = size(hall_gray);
%若用zeros初始化,导致imshow(double),>1则视为1,只能得到二值图像
res1 = hall_gray;
res2 = hall_gray;
for x = 1:xLen/8
    for y = 1:yLen/8
        D = dct2(hall_gray(8*x-7:8*x,8*y-7:8*y));
        temp1 = [D(:,1:4),zeros(8,4)];
        temp2 = [zeros(8,4),D(:,5:8)];
        res1(8*x-7:8*x,8*y-7:8*y) = idct2(temp1);
        res2(8*x-7:8*x,8*y-7:8*y) = idct2(temp2);
    end
end
figure;
imshow(hall_gray);
imwrite(hall_gray,'e2_ori.bmp','bmp')
figure;
imshow(res1);
imwrite(res1,'e2_3a.bmp','bmp')
figure;
imshow(res2);
imwrite(res2,'e2_3b.bmp','bmp')
