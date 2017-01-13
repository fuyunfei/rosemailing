clear all, close all; 
name = '../pic/3.jpg';
smoothratio=0.5;
mservar=struct(...
    'ThresholdDelta',  0.99, ...
    'RegionAreaRange', [1500 50000], ...
    'MaxAreaVariation', 0.4);

I=imread(name);
I = imresize(I, [5000 5000]);
if(size(I,3)==3)  
I=rgb2gray(I);
I = imresize(I,[min(size(I)) min(size(I))]);
% I = imgaussfilt(I,smoothratio);
end 

mserRegions = detectMSERFeatures(I,mservar);
figure; imshow(I); hold on;
plot(mserRegions,'showPixelList',true,'showEllipses',false);

SWT(I,mserRegions);
% save mserRegions



% for i= 1:size(mserRegions,1)
% region_idx= mserRegions(i,1).PixelList;
% idx = sub2ind(size(I),region_idx(:,2),region_idx(:,1));
% b=zeros(size(I,1),size(I,2));
% b(idx)=I(idx);
% % b(idx)=255;
% % imwrite(b,['../output/regions/', int2str(i) ,'.jpg'])
% figure
% imshow(b,[0,255]);
% end
