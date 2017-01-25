clear all, close all; 
name = '../pic/9.jpg';
smoothratio=1;
scaleratio=2;
I=imread(name);
I = imresize(I,scaleratio);
I = im2double(I); 

if(size(I,3)==3)  
I=rgb2gray(I);
end 
Is = imguidedfilter(I);
% imshowpair(Is,I,'montage');

% I = imgaussfilt(I,smoothratio);
sz=size(I,1)*size(I,2);
mservar=struct(...
    'ThresholdDelta',  0.99, ...
    'RegionAreaRange', [int64(sz*0.001) int64(sz*0.1)], ...
    'MaxAreaVariation', 0.1);
% [G,~]=imgradient(I);
mserRegions = detectMSERFeatures(Is,mservar);
figure; imshow(Is); hold on;
plot(mserRegions,'showPixelList',true,'showEllipses',false);

strokes=SWT(I,mserRegions);
% Leftregions(I,mserRegions);

% save mserRegions


% % 
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
