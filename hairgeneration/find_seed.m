function seed = find_seed(orientation, confidence)

xAxis = sin(orientation);
yAxis = cos(orientation);

[m,n] = size(orientation);
k = 1;
w_high = 0.8;
epsai = 0.05;

for y = 1:m
    for x = 1:n
        if confidence(y,x)>w_high
            left = getinterp(y-yAxis(y,x), x-xAxis(y,x), confidence);
            right = getinterp(y+yAxis(y,x), x+xAxis(y,x), confidence);
            hasMax = confidence(y,x)>left&&confidence(y,x)>right;
            err = (confidence(y,x)-max(left,right))/(confidence(y,x)-100)*1000;
            if hasMax && abs(err)>epsai
                seed(k) = complex(y,x);
                k = k+1;
            end
        end
    end
end
            