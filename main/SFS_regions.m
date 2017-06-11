getd = @(p)path(p,path);
getd('../lib/toolbox_signal/');
getd('../lib/toolbox_general/');
getd('../lib/toolbox_graph/');
getd('/home/sun/Cloud/SFS/cvision-algorithms/');


depthlist={};
for i= 1:size(Regions,1)
region_idx= Regions(i,1).PixelList;
idx = sub2ind(size(I),region_idx(:,2),region_idx(:,1));
b=ones(size(I,1),size(I,2))*255; 
b(idx)=I(idx);
% imagesc(b);
% imageblur = imgaussfilt(b,1);
%% edge smooth 
% % %Its edges
% E = edge(b,'canny');
% %Dilate the edges
% Ed = imdilate(E,strel('disk', 2));
% %Filtered image
% Ifilt = imgaussfilt(b,3);
% %Use Ed as logical index into I to and replace with Ifilt
% imageblur=b; 
% imageblur(Ed) = Ifilt(Ed);
% imshow(uint8(imageblur));
% imageblur = imguidedfilter(b,'NeighborhoodSize',[3 3]);
imageblur= imgaussfilt(b,3);
%% SFS
% depth = shapeFromShading(imageblur, 1000, 1/8);
depth  = shapemarching(double(imageblur));
% depth=ones(size(depth))*depth(20,20)-depth;
depthlist{i}=depth;
% % depth(idx)=depth(idx)+depth1(idx);    
% figure
% % mesh(depth);
% % title('Surface reconstruction');
% % clf;
% surf(-depth/20)
% shading interp;
% axis('equal');
% view(110,45);
% axis('off');
% camlight('headlight') 
end 
sum=zeros(size(depthlist{1}));
for i=1:size(depthlist,2)
sum=sum+depthlist{i};
end
figure
surf(sum(5:end-5,5:end-5 )/20)
shading interp;
axis('equal');
view(110,45);
axis('off');
camlight('headlight') 
% save Regions

% Z=sum(10:end-10,10:end-10 )*1.3;
% [X,Y] = meshgrid(1:size(Z,2),1:size(Z,1));
% saveobjmesh('s2.obj',X,Y,-Z);