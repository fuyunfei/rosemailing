clear;
clc;

[filename,pathname] = uigetfile('*.png;*.jpg','select test hair image');
if isequal(filename,0)
   disp('User selected Cancel')
else
   disp(['User selected ', fullfile(pathname, filename)])
end

img1 = imread(fullfile(pathname, filename));

if size(img1,3) == 3
    img = rgb2gray(img1);
end
img = im2double(img); 
mask = img<(200/255);

test = padarray(img, [10 10], 'symmetric');
theta = [-32:31]/64*pi;
parfor i = 1:length(theta)
   r = gaborkernel2d(test,0,3,theta(i),0,0.5,1);
   gbr(:,:,i) = r(11:end-10,11:end-10);
end
[res,orienMatrix] = calc_viewimage(gbr, [1:length(theta)], theta);
figure,imagesc(res);axis image;axis off;colormap(gray);
conf = confidence(gbr, res, orienMatrix, theta).*mask;

test = padarray(conf, [10 10], 'symmetric');
%iterative refinement 1st
parfor i = 1:length(theta)
   r = gaborkernel2d(test,0,3,theta(i),0,0.5,1);
   gbr1(:,:,i) = r(11:end-10,11:end-10);
end
[res1,orienMatrix1] = calc_viewimage(gbr1, [1:length(theta)], theta);
conf1 = confidence(gbr1, res1, orienMatrix1, theta).*mask;

test = padarray(conf1, [10 10], 'symmetric');
%%iterative refinement 2nd
parfor i = 1:length(theta)
   r = gaborkernel2d(test,0,3,theta(i),0,0.5,1);
   gbr2(:,:,i) = r(11:end-10,11:end-10);
end
[res2,orienMatrix2] = calc_viewimage(gbr2, [1:length(theta)], theta);
% 
%%calculate seed points
orientation = orienMatrix2+pi/2;

seed = find_seed(orientation,conf1);
hair = tracing(seed, orientation, conf1, mask);

figure
y = linspace(0,1,50);
for i = 1:length(hair)
%     [~,~,hair1{i}] = CASTELJAU(0,1,hair{i},y);
    plot(hair{i}(:,2),hair{i}(:,1),'LineWidth', 1.5); axis ij; axis image; hold on
end
axis off; hold off

hair_length=zeros(1,length(hair));
for i=1:length(hair)
    hai=hair{i};
    hair_length(i)=size(hai,1);
end
[hair_length,idx]=sort(hair_length,'ascend');


for i = length(idx)-200:length(idx)
%     [~,~,hair1{idx(i)}] = CASTELJAU(0,1,hair{idx(i)},y);
    plot(hair{idx(i)}(:,2),hair{idx(i)}(:,1),'LineWidth', 1.5); axis ij; axis image; hold on
end
axis off; hold off

