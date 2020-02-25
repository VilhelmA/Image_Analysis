function classification_data = class_train(X, Y)
% Returns a cell array with:
% - Mean of the features
% - Standard deviation of features
nbr_of_features=26;
classification_data=cell(26,2);

for i=1:nbr_of_features
    class_data=X(:,Y == i);
    class_std = std(class_data, 0, 2);
    class_mean = mean(class_data, 2);
    classification_data{i,1}=class_std;
    classification_data{i,2}=class_mean;
end
end

