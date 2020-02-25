function [S] = im2segment(im)
% [S] = im2segment(im)
im = mat2gray(im); % use grayscale image
im = imsharpen(im, 'Amount', 0.3);
im = imbinarize(im,0.5); %make intensity binary
im=~im; %invert matrix to get it the right way round

%Fill in holes (new)
filled = imfill(im, 'holes');
holes = filled & ~im;
bigholes = bwareaopen(holes, 3);
smallholes = holes & ~bigholes;
im = im | smallholes;

[L, nbrofsegments] = bwlabel(im);%find 8-connected pixels
i=1;
for kk=1:nbrofsegments
    % Improved: If segment is too small do not add it (noise removal).
    if (nnz(L == kk) > 10)
        S{i}= L == kk;
        i = i + 1;
    end
end
