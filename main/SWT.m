function mserRegions=SWT(I,mserRegions)
%% Step 2: Remove Non-Text Regions Based On Basic Geometric Properties
% Although the MSER algorithm picks out most of the text, it also detects
% many other stable regions in the image that are not text. You can use a
% rule-based approach to remove non-text regions. For example, geometric
% properties of text can be used to filter out non-text regions using
% simple thresholds. Alternatively, you can use a machine learning approach
% to train a text vs. non-text classifier. Typically, a combination of the
% two approaches produces better results [4]. This example uses a simple
% rule-based approach to filter non-text regions based on geometric
% properties.
%
% There are several geometric properties that are good for discriminating
% between text and non-text regions [2,3], including:
%
% * Aspect ratio
% * Eccentricity 
% * Euler number
% * Extent
% * Solidity
%
% Use |regionprops| to measure a few of these properties and then remove
% regions based on their property values.

% First, convert the x,y pixel location data within mserRegions into linear
% indices as required by regionprops.


sz = size(I);
pixelIdxList = cellfun(@(xy)sub2ind(sz, xy(:,2), xy(:,1)), ...
    mserRegions.PixelList, 'UniformOutput', false);

% Next, pack the data into a connected component struct.
mserConnComp.Connectivity = 8;
mserConnComp.ImageSize = sz;
mserConnComp.NumObjects = mserRegions.Count;
mserConnComp.PixelIdxList = pixelIdxList;

% Use regionprops to measure MSER properties
mserStats = regionprops(mserConnComp, 'BoundingBox', 'Eccentricity', ...
    'Solidity', 'Extent', 'Euler', 'Image','Extrema','perimeter');

% % Compute the aspect ratio using bounding box data.
bbox = int64(vertcat(mserStats.BoundingBox));
% w = bbox(:,3);
% h = bbox(:,4);
% aspectRatio = w./h;
% 
% % Threshold the data to determine which regions to remove. These thresholds
% % may need to be tuned for other images.
% filterIdx = aspectRatio' > 3; 
% filterIdx = filterIdx | [mserStats.Eccentricity] > .995 ;
% filterIdx = filterIdx | [mserStats.Solidity] < .3;
% filterIdx = filterIdx | [mserStats.Extent] < 0.2 | [mserStats.Extent] > 0.9;
% filterIdx = filterIdx | [mserStats.EulerNumber] < -4;
% 
% % Remove regions
% mserStats(filterIdx) = [];
% mserRegions(filterIdx) = [];
% 
% % Show remaining regions
% figure
% imshow(I)
% hold on
% plot(mserRegions, 'showPixelList', true,'showEllipses',false)
% title('After Removing Non-Text Regions Based On Geometric Properties')
% hold off

% %% Step 3: Remove Non-Text Regions Based On Stroke Width Variation
% % Another common metric used to discriminate between text and non-text is
% % stroke width. _Stroke width_ is a measure of the width of the curves and
% % lines that make up a character. Text regions tend to have little stroke
% % width variation, whereas non-text regions tend to have larger variations.
% %
% % To help understand how the stroke width can be used to remove non-text
% % regions, estimate the stroke width of one of the detected MSER regions.
% % You can do this by using a distance transform and binary thinning
% % operation [3].
% 
% % Get a binary image of the a region, and pad it to avoid boundary effects
% % during the stroke width computation.
% regionImage = mserStats(6).Image;
% regionImage = padarray(regionImage, [1 1]);
% 
% % Compute the stroke width image.
% distanceImage = bwdist(~regionImage); 
% skeletonImage = bwmorph(regionImage, 'thin', inf);
% 
% strokeWidthImage = distanceImage;
% strokeWidthImage(~skeletonImage) = 0;
% 
% % Show the region image alongside the stroke width image. 
% figure
% subplot(1,2,1)
% imagesc(regionImage)
% title('Region Image')
% 
% subplot(1,2,2)
% imagesc(strokeWidthImage)
% title('Stroke Width Image')

%%
% The procedure shown above must be applied separately to each detected
% MSER region. The following for-loop processes all the regions, and then
% shows the results of removing the non-text regions using stroke width
% variation.

% Process the remaining regions

strokeWidthThreshold=0.5;

for j = 1:numel(mserStats)
    
    regionImage = mserStats(j).Image;
    regionImage = padarray(regionImage, [1 1], 0);
    
  distanceImage = bwdist(~regionImage);
 
%   distanceImage = single(regionImage).*single(b);
    skeletonImage = bwmorph(regionImage, 'skel', inf);
    
    strokeWidthValues = distanceImage(skeletonImage);
    
    strokeWidthMetric = std(strokeWidthValues)/mean(strokeWidthValues);
    
    strokeWidthFilterIdx(j) = strokeWidthMetric > strokeWidthThreshold;
    
    strokeWidthImage = distanceImage;
    strokeWidthImage(~skeletonImage) = 0;
    
    disp([std(strokeWidthValues),mean(strokeWidthValues),strokeWidthMetric])
    
    txt = texlabel(mat2str([std(strokeWidthValues),mean(strokeWidthValues),strokeWidthMetric]));
    text(3,5,txt);
    
    b=I( bbox(j,2):(bbox(j,2)+bbox(j,4))+1, bbox(j,1):(bbox(j,1)+bbox(j,3))+1);
    subplot(2,4,1)
    imagesc(regionImage)
    title('Region Image')

    subplot(2,4,2)
    imagesc(distanceImage)
    title('distanceImage')
    
    subplot(2,4,3)
    imagesc(strokeWidthImage)
    title('strokeWidthImage')

    subplot(2,4,4)
    imagesc(b);
    
    subplot(2,4,[5:8]); imshow(I); hold on;
    plot(mserRegions(j),'showPixelList',true,'showEllipses',false);hold on ;
    
end

% Remove regions based on the stroke width variation
mserRegions(strokeWidthFilterIdx) = [];
mserStats(strokeWidthFilterIdx) = [];

% Show remaining regions
figure;imshow(I);hold on;
plot(mserRegions, 'showPixelList', true,'showEllipses',false);
% title('After Removing Non-Text Regions Based On Stroke Width Variation')
hold off


% for i= 1:size(mserRegions,1)
% region_idx= mserRegions(i,1).PixelList;
% idx = sub2ind(size(I),region_idx(:,2),region_idx(:,1));
% b=zeros(size(I,1),size(I,2));
% b(idx)=I(idx);
% % b(idx)=255;
% % imwrite(b,['../output/regions/', int2str(i) ,'.jpg'])
% % figure
% imshow(b,[0,255]);
% end



end 