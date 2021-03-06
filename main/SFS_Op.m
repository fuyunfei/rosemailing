clear all, close all; 
getd = @(p)path(p,path);
getd('../lib/toolbox_signal/');
getd('../lib/toolbox_general/');
getd('../lib/toolbox_graph/');

% name = '../pic/0_gray_resize';
% name = 'mozart';
name = '../pic/1_gray';
f = load_image(name);
% set all white area into black (which is not like reverse)
n = size(f,1);
h = n*.4;
f = rescale(f,0,h);
clf;
imageplot(f);


options.order = 2;
N0 = cat(3, grad(f,options), ones(n));

s = sqrt( sum(N0.^2,3) );
N = N0 ./ repmat( s, [1 1 3] );

clf;
imageplot(N);

d = [0 0 1];
L = max(0, sum( N .* repmat(reshape(d,[1 1 3]), [n n 1]),3 ) );

vmin = .3;
clf;
imageplot(max(L,vmin));

%For a vertical ligthing direction d=(0,0,1) 
d = [0 0 1];

% Compute the luminance map for d=(0,0,1)d=(0,0,1). 

L = sum( N .* repmat(reshape(d,[1 1 3]), [n n 1]),3 ); 
epsilon = 1e-9;
clf;
imageplot(L>1-epsilon);
W = sqrt(1./L.^2-1);
W = max(W,epsilon)*20;
clf;
imageplot(min(W,3));
p = [207 ;253];
% %p=[237 206 205 212 70 57 80 133 367 318;185 206 245 272 319 287 254 251 258 294]
ske_name = '../pic/1_gray_ske';
ske_pic = load_image(ske_name);
ske=(ske_pic(:,:,1)>150&ske_pic(:,:,2)<100);
[row,col]=find(ske);
% set p1 on the skeleton 
pr=[row(:) col(:)]';
ske=(ske_pic(:,:,3)>100&ske_pic(:,:,1)<150);
[row,col]=find(ske);
pb=[row(:) col(:)]';
% set p2 on the panel  
p0= [100 100]';
p= [pr  p0];
%set the initial distance value for starting points
options.values=[ones(size(pr,2),1)*-20;0];
% options.values=[1:871]'/10;
[f1,S,q] = perform_fast_marching(1./W, p,options);
f1 = -f1;
% f1(f<10)=Inf;
clf;
hold on;
surf(f1);
indices = sub2ind(size(f1), p(1,:), p(2,:));
h = plot3(p(2,:), p(1,:), f1(indices), 'r.');   
% set(h, 'MarkerSize',30);
% colormap(gray(256));
shading interp;
axis('equal');
view(110,45);
axis('off');
camlight('headlight') 

