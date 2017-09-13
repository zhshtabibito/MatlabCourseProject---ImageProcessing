clc; clear all; close all;
load('hall.mat');
load('JpegCoeff.mat');
hall_gray = hall_gray-128;
[xLen,yLen] = size(hall_gray);  %x行数y列数
res = zeros(64,(xLen/8)*(yLen/8));
cnt = 1;
for x = 1:xLen/8
    for y = 1:yLen/8
        D = dct2(hall_gray(8*x-7:8*x,8*y-7:8*y));
        D = round(D./QTAB);
        res(:,cnt) = ZigZag(D);
        cnt=cnt+1;
    end
end
