load('hall.mat');
load('JpegCoeff.mat');
temp = hall_gray(1:8,1:8);
res1 = dct2(temp)
res2 = mydct(temp)

function res = mydct(P) 
[M,~] = size(P);
D = sqrt(2/M).*cos(kron([0:M-1]',2.*[0:M-1]+1).*pi/2/M);
D(1,:) = 1/sqrt(M);
res = D*double(P)*D';
end