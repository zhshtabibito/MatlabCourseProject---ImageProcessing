%e2_6
function res = Category(CD)
if CD == 0
    res = 0;
else
    res = floor(log2(abs(CD)))+1;
end
end