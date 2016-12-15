clear all, close all; 
getd = @(p)path(p,path);
getd('../lib/toolbox_signal/');
getd('../lib/toolbox_general/');
getd('../lib/toolbox_graph/');

%name = '../pic/0_gray_resize';
name = 'mozart';
name = '../pic/1_gray';
f = load_image(name)/20;
% set all white area into black (which is not like reverse)
%f(f>200)=0;

n = size(f,1);
h = n*.4;
f = rescale(f,0,h);
clf;
imageplot(f);

clf;
surf(f/20);
colormap(gray(256));
shading interp;
axis equal;
view(110,45);
axis('off');
camlight;


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

exo1;% four ligth direction 

%For a vertical ligthing direction d=(0,0,1) 
d = [0 0 1];

% Compute the luminance map for d=(0,0,1)d=(0,0,1). 

L = sum( N .* repmat(reshape(d,[1 1 3]), [n n 1]),3 ); 
epsilon = 1e-9;
clf;
imageplot(L>1-epsilon);
W = sqrt(1./L.^2-1);
W = max(W,epsilon);
clf;
imageplot(min(W,3));
p = [207 ;253];
% %p=[237 206 205 212 70 57 80 133 367 318;185 206 245 272 319 287 254 251 258 294]
ske_name = '../pic/1_gray_ske';
ske_pic = load_image(ske_name);
ske=(ske_pic(:,:,1)>150&ske_pic(:,:,2)<100);
[row,col]=find(ske);
p=[row(:) col(:)]';

[f1,S] = perform_fast_marching(20./W, p);
f1 = -f1*n;
clf;
hold on;
surf(f1);
% h = plot3(p(2,:), p(1,:), f1(p(1,:),p(2,:)), 'r.');
% set(h, 'MarkerSize',30);
colormap(gray(256));
shading interp;
axis('equal');
view(110,45);
axis('off');
camlight('headlight') 
exo2;
exo3;
