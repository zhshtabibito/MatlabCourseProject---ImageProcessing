clc; clear all; close all;
load('hall.mat');
load('jpegcodes.mat');
output = length(DC) + length(AC);
input = length(dec2bin(255)) * xLen * yLen;
res = input/output