clear all, close all; 
name = '../pic/4.jpg';
smoothratio=1.5;
mservar=struct(...
    'ThresholdDelta',  1.99, ...
    'RegionAreaRange', [1000 30000], ...
    'MaxAreaVariation', 0.2);

I=imread(name);
if(size(I,3)==3)  
I=rgb2gray(I);
rawI = imresize(I,[min(size(I)) min(size(I))]);
I = imgaussfilt(rawI,smoothratio);
end 



mserRegions = detectMSERFeatures(I,mservar);
figure; imshow(I); hold on;
plot(mserRegions,'showPixelList',true,'showEllipses',false);

save mserRegions

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

