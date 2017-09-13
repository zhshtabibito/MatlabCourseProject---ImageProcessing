L=5;  %L=4,3
shift=8-L;
v=zeros(1,2^(3*L));
for cntFace=1:33
    u=zeros(1,2^(3*L));
    filename=strcat(num2str(cntFace),'.bmp');
    face=imread(filename);
    [xLen,yLen,~]=size(face);
    for x=1:xLen
        for y=1:yLen
            R=bitshift(face(x,y,1),-shift);
            G=bitshift(face(x,y,2),-shift);
            B=bitshift(face(x,y,3),-shift);
            n=bitshift(R,2*L)+bitshift(G,L)+B;
            u(n+1)=u(n+1)+1;  % n 0~255
        end
    end
    u=u./(xLen*yLen);
    v=v+u;
end
v=v./33;
