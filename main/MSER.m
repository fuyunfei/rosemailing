clear all, close all; 
name = '../pic/0_gray.jpg';
I = imread(name);

regions = detectMSERFeatures(I);
figure; imshow(I); hold on;
plot(regions,'showPixelList',true,'showEllipses',false);