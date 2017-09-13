load('hall.mat');
load('JpegCoeff.mat');
temp = hall_gray(1:8,1:8);
res1 = temp - 128
temp = dct2(temp);
temp(1,1) = temp(1,1) - 128*8;
res2 = idct2(temp)

