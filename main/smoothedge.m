clear all; 
I = imread('cameraman.tif');
figure
imshow(I);
%Its edges
E = edge(I,'canny');
%Dilate the edges
Ed = imdilate(E,strel('disk',2));
%Filtered image
Ifilt = imfilter(I,fspecial('gaussian'));
%Use Ed as logical index into I to and replace with Ifilt
I(Ed) = Ifilt(Ed);
figure;
imshow(I);