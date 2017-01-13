clear all, close all; 
getd = @(p)path(p,path);
getd('../lib/toolbox_signal/');
getd('../lib/toolbox_general/');
getd('../lib/toolbox_graph/');

load('mserRegions.mat');
%load('sum_depth.mat');

f=sum; 
n = size(f,1);
h = n*0.4;
f = rescale(f, h,0);

clf;
imageplot(f);

options.order = 2;
N0 = cat(3, -grad(f,options), ones(n));
s=zeros(size(rawI));
for i=1:size(N0,1)
    for j=1:size(N0,1)
    s(i,j)=N0(i,j,1)^2+N0(i,j,2)^2+N0(i,j,3)^2;
    end
end
% s = sqrt(sum(N0.^2,3) );
N = N0 ./ repmat( s, [1 1 3] );

clf;
imageplot(N);
% d=[0,0,1];
% L = sum( N .* repmat(reshape(d,[1 1 3]), [n n 1]),3 ); 
epsilon = 1e-9;
% clf;
% imageplot(L>1-epsilon);

I=rescale(double(rawI),0,1);
W = sqrt(1./I.^2-1);
W = max(W,epsilon);
clf;
imageplot(min(W,3));

p = [20  ;20 ];
[f1,S,q] = perform_fast_marching(1./W, p);
f1 = f1*n;
figure;
newdepth=f1/10+sum*8;
surf(newdepth(5:end-5,5:end-5));
shading interp;
axis('equal');
view(0,20);
axis('off');
camlight('headlight') 

