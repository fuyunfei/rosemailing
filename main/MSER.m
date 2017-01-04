clear all, close all; 
name = '../pic/1_gray.jpg';
% name = '../output/strokes.jpg';
I = imread(name);
% I=rgb2gray(I);
var=struct(...
    'ThresholdDelta', 5*150/255, ...
    'RegionAreaRange', [1000 30000], ...
    'MaxAreaVariation', 0.1,...
    'ROI', [1 1 size(I,2) size(I,1)]);


regions = detectMSERFeatures(I,var);
figure; imshow(I); hold on;
plot(regions,'showPixelList',true,'showEllipses',false);


for i= 1:size(regions)
region_idx= regions(i,1).PixelList;
idx = sub2ind(size(I),region_idx(:,2),region_idx(:,1));
b=ones(size(I,1),size(I,2))*255;
b(idx)=I(idx);
figure
imshow(b,[0,255]);
end