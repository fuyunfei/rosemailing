clear all; close all ; 
% a=1:25;
% a=reshape(a,[5,5]); 
a=ones(5,5)*0.1;
b= ones(20,20)*10000;
b(10:14,10:14)=a; 
p1=[12;12];
p2=[];
p=[p1 p2]
options.values=[ones(size(p1,2),1)*10 ];
[f1,S,q] = perform_fast_marching(b, p,options);
clf;
hold on;
surf(f1);
h = plot3(p(2,:), p(1,:), f1(p(1,:),p(2,:)), 'r.');
set(h, 'MarkerSize',30);
%colormap(gray(256));
shading interp;
axis('equal');
view(110,45);
axis('off');
camlight('headlight')                                                                                                                                            