clear all; close all ;
getd = @(p)path(p,path);
getd('../lib/toolbox_signal/');
getd('../lib/toolbox_general/');
getd('../lib/toolbox_graph/');
getd('../lib/Tubeplot/');

%% 
t=0:(2*pi/100):(2*pi);
x=cos(t*2).*(2+sin(t*3)*.3);
y=sin(t*2).*(2+sin(t*3)*.3);
z=cos(t*3)*.3;
tubeplot(x,y,z,0.1,t,25)
axis equal;

%% 
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
for j=1:8
    scaleratio=0.2+0.1*j;
    s_I = imresize(img,scaleratio);
    test = padarray(s_I, [10 10], 'symmetric');
    theta = [-8:7]/16*pi;
    for i = 1:length(theta)
       r = gaborkernel2d(test,0,3,theta(i),0,0.5,1);
       gbr(:,:,i) = r(11:end-10,11:end-10);
    end

    
    [res,orienMatrix] = calc_viewimage(gbr, [1:length(theta)], theta);
    res=imresize(res,size(img));
    orienMatrix=imresize(orienMatrix,size(img));
    list_res(:,:,j)=res;
    list_or(:,:,j)=orienMatrix;
    
    gbr=[];
%     figure,imagesc(res);axis image;axis off;colormap(gray);
end

[M,I]=min(list_res,[],3);

% for i= 1:size(list_res_or,1)
%     tem= list_res_or{1,i}-list_res_or{1,i+1};
%     select=tem>0;
%     list_res_or{1,i}*select+list_res_or{1,i+1}
% end


res=res-min(res(:));
res=res./max(res(:));

res=res>0.3;
imwrite(res,'res1.jpg');

for i=1:3
rawimg(:,:,i)=rawimg(:,:,i).*res; 
end
rawimg=uint8(rawimg);
imwrite(rawimg,'res.jpg');

%% test for multi-scale
clear all, close all; 
name = '../pic/1.jpg';
smoothratio=2;
scaleratio=0.5;
I=imread(name);
if(size(I,3)==3)  
I=rgb2gray(I);
end 

for i = 1:5
    scaleratio=0.5+0.1*i;
    s_I = imresize(I,scaleratio);
    figure; imshow(s_I);
end








