function int_v = getinterp(y,x,value)

xpos = floor(x);
ypos = floor(y);

alpha = x-xpos;
beta = y-ypos;

if ypos>0&&xpos>0&&ypos+1<size(value,1)&&xpos+1<size(value,2)
    A = value(ypos,xpos);
    B = value(ypos,xpos+1);
    C = value(ypos+1,xpos);
    D = value(ypos+1,xpos+1);
    int_v = A*(1-alpha)*(1-beta)+B*alpha*(1-beta)+C*(1-alpha)*beta+D*alpha*beta;
else
    int_v = 0;
end
    




