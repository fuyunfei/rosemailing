clear all; close all; 
getd = @(p)path(p,path);
getd('../lib/toolbox_signal/');
getd('../lib/toolbox_general/');
getd('../lib/toolbox_graph/');
getd('../lib/Tubeplot/');

load('I_mser.mat')

idx=6;

bbox = int64(vertcat(mserStats.BoundingBox));

regionImage = mserStats(idx).Image;
regionImage = padarray(regionImage, [1 1], 0);

distanceImage = bwdist(~regionImage);
b=I( bbox(idx,2):(bbox(idx,2)+bbox(idx,4))+1, bbox(idx,1):(bbox(idx,1)+bbox(idx,3))+1);
b(~regionImage)=1;
%     distanceImage = single(regionImage).*single(b);
skeletonImage = bwmorph(regionImage, 'thin', inf);

strokeWidthValues = distanceImage(skeletonImage);

strokeWidthImage = distanceImage;
strokeWidthImage(~skeletonImage) = 0; 
%% 
[col,row] = find(skeletonImage>0); 
anchor=[90 5;4 79];
row_an=[row;anchor(:,1);anchor(:,1);anchor(:,1);anchor(:,1);anchor(:,1);anchor(:,1);anchor(:,1);anchor(:,1);anchor(:,1);anchor(:,1);anchor(:,1);anchor(:,1)];
col_an=[col;anchor(:,2);anchor(:,2);anchor(:,2);anchor(:,2);anchor(:,2);anchor(:,2);anchor(:,2);anchor(:,2);anchor(:,2);anchor(:,2);anchor(:,2);anchor(:,2)];
f=fit(row_an,col_an,'poly2');
newS=zeros(size(strokeWidthImage));
newS(sub2ind(size(strokeWidthImage), uint8(f(row_an)'),uint8(row_an')))=1;
strokeWidthImage = distanceImage;
strokeWidthImage(~newS) = 0; 



%%
subplot(2,4,1)
imagesc(regionImage)
title('Region Image')

subplot(2,4,2)
imagesc(distanceImage)
title('distanceImage')

subplot(2,4,3)
imagesc(strokeWidthImage)
title('strokeWidthImage'); 

subplot(2,4,4)
imagesc(b);hold on;
plot(f(row),row);

subplot(2,4,[5:8]); imshow(I); hold on;
plot(mserRegions(idx),'showPixelList',true,'showEllipses',true);

%% 
p= uint32([f(row) row]');
W= double(regionImage);
% W=zeros(20,10);
W = max(W,1e-3);
options.values= -strokeWidthValues;
options.order = 2;

[f1,S,q] = perform_fast_marching(1./W,p,options);
figure;
surf(f1*80);
colormap(gray(256));
shading interp;
axis('equal');
axis('off');
camlight('headlight') 
indices = sub2ind(size(f1), p(1,:), p(2,:));hold on;
h = plot3(p(2,:), p(1,:), strokeWidthValues', 'r.');
set(h, 'MarkerSize',10);


%% 
t=0:(2*pi/89):(2*pi);
x= row';
y= f(row)';
z= double(strokeWidthValues');

t=0:(2*pi/100):(2*pi);
x=cos(t*2).*(2+sin(t*3)*.3);
y=sin(t*2).*(2+sin(t*3)*.3);
z=cos(t*3)*.3;

tubeplot(x,y,z,0.1,t,10)
 
    





    
    
