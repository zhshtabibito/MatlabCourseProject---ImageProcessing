load('hall.mat');
temp = hall_color;
[xLen,yLen,~] = size(hall_color);
r = min(xLen,yLen)/2;
xCen = (1+xLen)/2;
yCen = (1+yLen)/2;
for x = 1:xLen
    if abs(x-xCen)>r
        continue
    else
        y1 = round(yCen+sqrt(r^2-(x-xCen)^2));
        y2 = round(yCen-sqrt(r^2-(x-xCen)^2));
        temp(x,y1,1)=255;
        temp(x,y2,1)=255;
        temp(x,y1,2)=0;
        temp(x,y2,2)=0;
        temp(x,y1,3)=0;
        temp(x,y2,3)=0;    
    end
end
for y = 1:yLen
    if abs(y-yCen)>r
        continue
    else
        x1 = round(xCen+sqrt(r^2-(y-yCen)^2));
        x2 = round(xCen-sqrt(r^2-(y-yCen)^2));
        temp(x1,y,1)=255;
        temp(x2,y,1)=255;
        temp(x1,y,2)=0;
        temp(x2,y,2)=0;
        temp(x1,y,3)=0;
        temp(x2,y,3)=0;    
    end
end
imshow(temp);
imwrite(temp,'e1_2_a.bmp','bmp');