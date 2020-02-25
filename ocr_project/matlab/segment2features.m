function features = segment2features(I)
% features = segment2features(I)

features = zeros(9,1);

% Find the region of interest (symbol)
[row, col] = find( I == 1 );
maxRow = max(row); minRow = min(row);
maxCol = max(col); minCol = min(col);
region = I(minRow:maxRow,minCol:maxCol);
area = size(region);

%First feature: "Holes", black areas surrounded by white 
features(1)=abs(bweuler(region)-1); %Corrections to give actual number of holes

%Second feature: Moment
features(2) = mean(moment(region,3));

%Third & Fourth features: x and y coordinates of the characters centroid 
%Improved to make scale invariant by dividing by size.
prop = regionprops (region, 'Centroid');
features(3) = prop.Centroid(1)/area(2);
features(4) = prop.Centroid(2)/area(1); 

% Added feature (5): Number of segments in lower part of image
cellI = mat2cell(region , [floor(area(1)/2)+3 ceil(area(1)/2)-3] , area(2));
features(5) = max(max(bwlabel(cellI{2})));

% Added features (6-9): Sums of intensities in different parts of the
% image divided by the sum of intensities in the image.
cellI = mat2cell(region,[floor(area(1)/2) ceil(area(1)/2) ], [floor(area(2)/2) ceil(area(2)/2)]);
for i = 6:9
    features(i)=sum(sum(cellI{i -5}))/nnz(region);
end


