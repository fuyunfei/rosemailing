clear all, close all; 
name = './pics/2strokes1.png';
% name_edge = '/home/sun/Cloud/rosemailing/SWT/coherent_line_drawing/out.jpg';

smoothratio=1;
scaleratio=1;
% I = imread(name);
 [icon, map, I] = imread(name);
% I = 1-im2double(imread(name));
if(size(I,3)==3)  
I=rgb2gray(I);
end 
% I_edge=imread(name_edge);
% I(I_edge<150)=I(I_edge<150)-10;
 
I = imresize(I,scaleratio);
% I = imguidedfilter(I);
% I1=uint8(double(I).*double(line)/255);

sz=size(I,1)*size(I,2);
mservar=struct(...
    'ThresholdDelta', 0.1, ...
    'RegionAreaRange', [int64(sz*0.01) int64(sz*0.4)], ...
    'MaxAreaVariation', 0.1);
% [G,~]=imgradient(I);
Regions = detectMSERFeatures(I,mservar);

% stats = regionprops(mserConnComp,'MeanIntensity')

figure; imshow(I); hold on;
plot(Regions,'showPixelList',true,'showEllipses',false);

strokes=SWT(I,Regions);

Regions = detectMSERFeatures(I1,mservar);

% stats = regionprops(mserConnComp,'MeanIntensity')

figure; imshow(I1); hold on;
plot(Regions,'showPixelList',true,'showEllipses',false);

% save mserRegions

%% 

figure
I=rgb2gray(imread('a4.png'));
I = imresize(I,scaleratio);
for i= 1:size(Regions,1)
region_idx= Regions(i,1).PixelList;
idx = sub2ind(size(I),region_idx(:,2),region_idx(:,1));
b=ones(size(I,1),size(I,2))*255;
b(idx)=I(idx);
% b(idx)=255;
% imwrite(b,['../output/regions/', int2str(i) ,'.jpg'])
imshow(b,[0 255]);
end

% 
% Z=sum/200;
% [X,Y] = meshgrid(1:size(Z,2),1:size(Z,1));
% saveobjmesh('layer_max_new.obj',X,Y,-Z);

