function back = search_back(j,i,orientation,confidence,w_low,step,max_theta,mask)
% msg = ('searching back...');
%  disp(msg)
k = 1;
back(1,1) = j;
back(1,2) = i;
health_p = 5;
hval = 5;
[m,n] = size(mask);

if floor(back(k,1))<=1||floor(back(k,2))<=1||floor(back(k,1))>=m||floor(back(k,2))>=n
    back = [];
else
    while health_p>0&&mask(floor(back(k,1)),floor(back(k,2)))
        y = back(k,1);
        x = back(k,2);
        if k==1
            y1 = y-step*sin(orientation(y,x));
            x1 = x+step*cos(orientation(y,x));
            theta(k) = orientation(y,x);
            k = k+1;
            theta(k) = getinterp(y1,x1,orientation);
            back(k,1) = y1;
            back(k,2) = x1;
%             acros = min(abs(theta(k)-theta(k-1)),abs(pi-(theta(k)-theta(k-1))));
            acros = abs(theta(k)-theta(k-1));
        else
        con = getinterp(y,x,confidence);
        if con>=w_low
            if acros<=max_theta
                y1 = y-step*sin(theta(k));
                x1 = x+step*cos(theta(k));
                k = k+1;
                theta(k) = getinterp(y1,x1,orientation);
                back(k,1) = y1;
                back(k,2) = x1;
%                 acros = min(abs(theta(k)-theta(k-1)),abs(pi-(theta(k)-theta(k-1))));
                acros = abs(theta(k)-theta(k-1));
                if health_p<hval
                    health_p = hval;
                end
            else
                theta(k) = theta(k-1);
                y1 = y-step*sin(theta(k));
                x1 = x+step*cos(theta(k));
                k = k+1;
                theta(k) = getinterp(y1,x1,orientation);
                back(k,1) = y1;
                back(k,2) = x1;
%                 acros = min(abs(theta(k)-theta(k-1)),abs(pi-(theta(k)-theta(k-1))));
                acros = abs(theta(k)-theta(k-1));
                health_p = health_p-1;
            end
        else
            if acros<=max_theta
                y1 = y-step*sin(theta(k));
                x1 = x+step*cos(theta(k));
                k = k+1;
                theta(k) = getinterp(y1,x1,orientation);
                back(k,1) = y1;
                back(k,2) = x1;
%                 acros = min(abs(theta(k)-theta(k-1)),abs(pi-(theta(k)-theta(k-1))));
                acros = abs(theta(k)-theta(k-1));
%                 health_p = health_p-1;
                if health_p<5
                    health_p = 5;
                end
            else
                theta(k) = theta(k-1);
                y1 = y-step*sin(theta(k));
                x1 = x+step*cos(theta(k));
                k = k+1;
                theta(k) = getinterp(y1,x1,orientation);
                back(k,1) = y1;
                back(k,2) = x1;
%                 acros = min(abs(theta(k)-theta(k-1)),abs(pi-(theta(k)-theta(k-1))));
                acros = abs(theta(k)-theta(k-1));
                health_p = health_p-1;
            end
        end
        end
        if floor(back(k,1))<=1||floor(back(k,2))<=1||floor(back(k,1))>=m||floor(back(k,2))>=n
            break
        end
    end
end
