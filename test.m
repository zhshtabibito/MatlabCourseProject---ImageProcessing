clc; clear all; close all;
N=16777216-1;
n=1:N;
nBin=dec2bin(n);
c=[bin2dec(nBin(:,24:-1:17)),...
    bin2dec(nBin(:,16:-1:9)),...
    bin2dec(nBin(:,8:-1:1))];

