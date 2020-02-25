function y = classify(x, classification_data)
% Classification data: 
% - Mean of featurse 
% - Standard deviation of features
nbr_classes = size(classification_data,1);
p = zeros(1,nbr_classes);
for i=1:nbr_classes
    mean = classification_data{i,1};
    dev = classification_data{i,2};
    % Calculate class probability
    p_features = feature_probability(mean, dev, x);
    p(i) = sum(log(p_features));
end
[~,y] = max(p);
end

function p = feature_probability(m, s, x)
% Gaussian probability function
p = zeros(numel(x), 1); 
for i=1:numel(x)
    dev = max(s(i), eps);
    p(i) = normpdf(x(i), m(i), dev);
    if p(i)> 2
        p(i)
    end
end
p(p==0) = eps;
end



