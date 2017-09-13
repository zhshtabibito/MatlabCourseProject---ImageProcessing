load('hall.mat');
temp = hall_color;
[xLen,yLen,~] = size(hall_color);
for x = 1:xLen/8
    for y = 1:yLen/8
       if mod(x+y,2)==0
           temp(8*(x-1)+1:8*(x-1)+8,8*(y-1)+1:8*(y-1)+8,1)=0;
           temp(8*(x-1)+1:8*(x-1)+8,8*(y-1)+1:8*(y-1)+8,2)=0;
           temp(8*(x-1)+1:8*(x-1)+8,8*(y-1)+1:8*(y-1)+8,3)=0;  
       end
    end
end
imshow(temp);
imwrite(temp,'e1_2_b.bmp','bmp');