load ocrsegments
S_feats = zeros(9, 100); % 7, since I use 7 features -- change appropriately!
for i = 1 : numel(S)
    S_feat = segment2features(S{i});
    S_feats(:, i) = S_feat;
end
classification_data = class_train(S_feats, y);
% We can now save classification_data, since it will be loaded in some of
% the other functions used in this task (e.g. in inl3_test_and_benchmark.m).
save('classification_data.mat', 'classification_data')
