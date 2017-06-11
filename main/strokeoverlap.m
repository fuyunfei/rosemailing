clear all ; close all;
load('temp3.mat');
 

figure; imshow(Img{1}); hold on;
plot(Regions{1}(5),'showPixelList',true,'showEllipses',false);

figure; imshow(Img{2}); hold on;
plot(Regions{2}(12),'showPixelList',true,'showEllipses',false);

stroke1=Regions{1}(5).PixelList;
stroke2=Regions{2}(12).PixelList;

idx1 = sub2ind(size(Img{1}), stroke1(:,2), stroke1(:,1));
%%
testI=zeros(size(Img{1}));
testI(idx1)=255;
testI=imfill(testI,'hole');
idx1=find(testI>0);
%%
idx2 = sub2ind(size(Img{1}), stroke2(:,2), stroke2(:,1));

stroke1_max=max(depthlist{1,1}(idx1));

maxpoint=find(depthlist{1,1}==max(depthlist{1,1}(idx1)));

stroke1_depth=zeros(size(depthlist{1,1}));
stroke1_depth(idx1)=depthlist{1,1}(idx1);

stroke2_depth=zeros(size(depthlist{1,1}));
stroke2_depth(idx2)=depthlist{2}(idx2);

idx_over = intersect(idx1,idx2);
over_depth=zeros(size(sum));
over_depth(idx_over)=sum(idx_over);

stroke12_depth=stroke2_depth+stroke1_depth;
 
figure;
surf(stroke12_depth/100);

shading interp;
axis('equal');
view(2);
axis('off');
camlight('right') 
set(gca,'Ydir','reverse')
set(gca,'Xdir','reverse')
set(gca,'position',[0 0 1 1],'units','normalized')
iptsetpref('ImshowBorder','tight');

%%
[x_input y_input] = ginput(5);
x_static=uint16(x_input);
y_static=uint16(y_input);
idx_static = sub2ind(size(Img{1}),y_static,x_static);

% [lap1,V1]=lap(stroke1,depthlist{1,1}(idx1));
[lap2,V2]=lap1(stroke2,depthlist{1,2}(idx2),y_static,x_static);

% add constrain on overlap area. 
lap_over=zeros(length(idx_over),size(lap2,2));
V_over=zeros(length(idx_over),1);
for i=1:length(idx_over)
lap_over(i,find(idx2==idx_over(i)))=1;
V_over(i,1)=over_depth(idx_over(i))*1.2;
end

lap=[lap2;lap_over];
V=[V2;V_over];
z=lap\V;


%% 

load('lap_stroke_overlap.mat');

idx_over = intersect(idx1,idx2);
stroke1_over_depth=zeros(size(sum));
stroke1_over_depth(idx_over)=stroke1_depth(idx_over);


stroke2_new_depth=zeros(size(depthlist{1,1}));
stroke2_new_depth(idx2)=z;


stroke12_depth=stroke2_new_depth+stroke1_depth-stroke1_over_depth;
stroke12_depth_back=stroke12_depth;
%%
% stroke1_depth=imgaussfilt(stroke1_depth,3);
%%
stroke12_depth(idx1)=stroke1_depth(idx1);
stroke12_depth(idx_over)=stroke12_depth_back(idx_over);

stroke12_depth(stroke12_depth<0)=0;

figure;
surf((stroke12_depth)/100);

shading interp;
axis('equal');
view(2);
axis('off');
camlight('right') 
set(gca,'Ydir','reverse')
set(gca,'Xdir','reverse')
set(gca,'position',[0 0 1 1],'units','normalized')
iptsetpref('ImshowBorder','tight');



%% generate boundary  
clear all
load('lap_stroke_overlap.mat');

stroke12_depth(stroke12_depth<0)=0;
stroke12_max=max(stroke1_depth,stroke2_depth);
stroke12_max(stroke12_depth==0)=0;
stroke12_max=stroke12_max/10;
stroke12_depth=stroke12_depth/10;

stroke12_max = (stroke12_max-min(stroke12_max(:))) ./ (max(stroke12_max(:)-min(stroke12_max(:))));
stroke12_max=stroke12_max*30;
stroke12_depth = (stroke12_depth-min(stroke12_depth(:))) ./ (max(stroke12_depth(:)-min(stroke12_depth(:))));
stroke12_depth=stroke12_depth*30;

% %Its edges
% E = edge(stroke12_depth,'canny');
% %Dilate the edges
% Ed = imdilate(E,strel('disk',2));
% %Filtered image
% Ifilt = imgaussfilt(stroke12_depth,3);
% %Use Ed as logical index into I to and replace with Ifilt
% stroke12_depth(Ed) = Ifilt(Ed);

stroke12_max=imgaussfilt(stroke12_max,1);
figure;
surf(stroke12_max);

shading interp;
axis('equal');
view(2);
axis('off');
camlight('right') 
set(gca,'Ydir','reverse')
set(gca,'Xdir','reverse')
set(gca,'position',[0 0 1 1],'units','normalized')
iptsetpref('ImshowBorder','tight');

%% 
Z=stroke12_max(5:end-5,5:end-5);
[X,Y] = meshgrid(1:size(Z,2),1:size(Z,1));
saveobjmesh(['stroke12_max.obj'],X,-Y,Z);
 


