close all
load('femfel.mat');

%shift images back

im1 = femfel1(1:748,:,:);
im2 = femfel2(3:750,:,:);


im1(:,:,1) = wiener2(im1(:,:,1), [5,5]);
im1(:,:,2) = wiener2(im1(:,:,2), [5,5]);
im1(:,:,3) = wiener2(im1(:,:,3), [5,5]);

im2(:,:,1) = wiener2(im2(:,:,1), [5,5]);
im2(:,:,2) = wiener2(im2(:,:,2), [5,5]);
im2(:,:,3) = wiener2(im2(:,:,3), [5,5]);

diff = abs(im1 - im2);

diff(:,:,1) = medfilt2(diff(:,:,1), [7,7]);
diff(:,:,2) = medfilt2(diff(:,:,2), [7,7]);
diff(:,:,3) = medfilt2(diff(:,:,3), [7,7]);


diff = rgb2gray(diff);

diff = diff > 40;
diff = bwlabel(diff);

%too many clusters, find clusters to pair
maxim = max(diff(:));
centers = zeros(2,maxim);

for i = 1:maxim
    [x,y] = find(diff == i);
    centers(1,i) = mean(x);
    centers(2,i) = mean(y);
end
dists = zeros(maxim-1, maxim-1);

for i = 1:maxim-1
    for k = i+1:maxim
        dists(i,k) = norm(centers(:,i) - centers(:,k));
    end
end

clusters_to_pair = zeros(2,2)

dists(find(dists == 0)) = 1000;

minimum = min(dists(:))

[x,y] = find(dists == minimum)

clusters_to_pair(:,1) = [x; y];

dists(x,y) = 1000;

minimum = min(dists(:))

[x,y] = find(dists == minimum)

clusters_to_pair(:,2) = [x; y];

diff(find(diff == clusters_to_pair(2,1))) = clusters_to_pair(1,1);
diff(find(diff == clusters_to_pair(2,2))) = clusters_to_pair(1,2);

box = regionprops(diff, 'BoundingBox');
imshow(im1)
hold on
for i = 1:length(box)
    rectangle('Position', box(i).BoundingBox, 'EdgeColor', 'r','LineWidth',3)
end

figure
imshow(im2)
hold on
for i = 1:length(box)
    rectangle('Position', box(i).BoundingBox, 'EdgeColor', 'r','LineWidth',3)
end