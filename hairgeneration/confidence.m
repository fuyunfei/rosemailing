function conf = confidence(gbr, res, orienMatrix, theta)

[m,n] = size(res);
conf = zeros(m,n);
 for i = 1:m
     for j = 1:n
         response = reshape(gbr(i,j,:),1,length(theta));
         variance = (abs(response)-res(i,j)).^2;
         distance = abs(theta - orienMatrix(i,j));
         conf(i,j) = sqrt(sum(distance.*variance));
     end
 end

