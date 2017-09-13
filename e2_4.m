clc; clear all; close all;
load('hall.mat');
load('JpegCoeff.mat');
[xLen,yLen] = size(hall_gray);
res1 = hall_gray;
res2 = hall_gray;
res3 = hall_gray;
for x = 1:xLen/8
    for y = 1:yLen/8
        D = dct2(hall_gray(8*x-7:8*x,8*y-7:8*y));
        temp1 = D';
        temp2 = rot90(D);
        temp3 = rot90(rot90(D));
        res1(8*x-7:8*x,8*y-7:8*y) = idct2(temp1);
        res2(8*x-7:8*x,8*y-7:8*y) = idct2(temp2);
        res3(8*x-7:8*x,8*y-7:8*y) = idct2(temp3);
    end
end
figure;
imshow(res1);
imwrite(res1,'e2_4a.bmp','bmp')
figure;
imshow(res2);
imwrite(res2,'e2_4b.bmp','bmp')
figure;
imshow(res3);
imwrite(res3,'e2_4c.bmp','bmp')