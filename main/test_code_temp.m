clear all; close all ; 
% % a=1:25;
% % a=reshape(a,[5,5]); 
% a=ones(5,5)*0.1;
% b= ones(20,20)*10000;
% b(10:14,10:14)=a; 
% p1=[12;12];
% p2=[];
% p=[p1 p2]
% options.values=[ones(size(p1,2),1)*10 ];
% [f1,S,q] = perform_fast_marching(b, p,options);
% clf;
% hold on;
% surf(f1);
% h = plot3(p(2,:), p(1,:), f1(p(1,:),p(2,:)), 'r.');
% set(h, 'MarkerSize',30);
% %colormap(gray(256));
% shading interp;
% axis('equal');
% view(110,45);
% axis('off');
% camlight('headlight')    


%% test for gabor filter 
clear;
clc;

img = imread('../pic/1_gray.jpg');
rawimg =double(imread('../pic/1.jpg'));

% img = zeros(100);
% img(45:54,:)=255;


if size(img,3) == 3
    img = rgb2gray(img);
end
img = im2double(img); 
mask = img<(200/255);

test = padarray(img, [10 10], 'symmetric');
theta = [-16:15]/16*pi;
for i = 1:length(theta)
   r = gaborkernel2d(test,0,2,theta(i),1.6,0.3,10);
   gbr(:,:,i) = r(11:end-10,11:end-10);
end
[res,orienMatrix] = calc_viewimage(gbr, [1:length(theta)], theta);
figure,imagesc(res);axis image;axis off;colormap(gray);

res=res-min(res(:));
res=res./max(res(:));

res=res>0.3;
imwrite(res,'res1.jpg');

for i=1:3
rawimg(:,:,i)=rawimg(:,:,i).*res; 
end
rawimg=uint8(rawimg);
imwrite(rawimg,'res.jpg');



