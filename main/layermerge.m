clear all;
load('lap_stroke_overlap.mat');

idx_over = intersect(idx1,idx2);
k=1;
for i=1:length(idx_over)
k=min(k,stroke2_depth(idx_over(i))/stroke1_depth(idx_over(i)))
end

% reddd=zeros(size(Img{2}));
% reddd=Img{2}*0.8;
% reddd(idx_over)=255;
% overlap_I= cat(3,reddd,Img{2}*0.8,Img{2}*0.8);
% 
% imshow(overlap_I);

sum=max(stroke2_depth ,stroke1_depth*0.2);

figure;
surf(sum/100);

shading interp;
axis('equal');
view(2);
axis('off');
camlight('right') 
set(gca,'Ydir','reverse')
set(gca,'Xdir','reverse')
set(gca,'position',[0 0 1 1],'units','normalized')
iptsetpref('ImshowBorder','tight');