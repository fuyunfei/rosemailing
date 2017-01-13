clear all;
close all;

load('mserRegions.mat');
image = rawI;
% imshow(image,[0 255]);
depthlist={};
parfor i= 1:size(mserRegions,1)
region_idx= mserRegions(i,1).PixelList;
idx = sub2ind(size(I),region_idx(:,2),region_idx(:,1));
b=ones(size(image,1))*255; 
b(idx)=image(idx);
% imageblur = imgaussfilt(b,1);
%% edge smooth 
%Its edges
E = edge(b,'canny');
%Dilate the edges
Ed = imdilate(E,strel('disk',2));
%Filtered image
Ifilt = imgaussfilt(b,2);
%Use Ed as logical index into I to and replace with Ifilt
imageblur=b; 
imageblur(Ed) = Ifilt(Ed);
% imshow(imageblur,[0 255]);
%% SFS
depth = shapeFromShading(imageblur, 1500, 1/8);
depth=ones(size(depth))*depth(20,20)-depth;
depthlist{i}=depth;
% depth(idx)=depth(idx)+depth1(idx);

% figure
% % mesh(depth);
% % title('Surface reconstruction');
% % clf;
% surf(depth*10)
% shading interp;
% axis('equal');
% view(110,45);
% axis('off');
% camlight('headlight') 
end 
sum=zeros(size(image));
for i=1:size(depthlist,2)
sum=sum+depthlist{i};
end
figure
surf(sum(5:end-5,5:end-5 )*3)
shading interp;
axis('equal');
view(110,45);
axis('off');
camlight('headlight') 
save mserRegions

