clear all,close all; 
ske_name = '../pic/1_gray_ske';
ske_pic = load_image(ske_name);
ske=(ske_pic(:,:,1)>150&ske_pic(:,:,2)<100);
[row,col]=find(ske);
p=[col row]';
scatter(row(1:10:end),col(1:10:end));