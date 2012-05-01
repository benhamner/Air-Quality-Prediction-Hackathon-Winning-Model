function make_predictions()

prediction_offsets = [1 2 3 4 5 10 17 24 48 72];

data = read_data();

test_predictions = zeros(2100,39);

options = statset()

%%% Uncomment the lines below to train models in parallel
% matlabpool open 4
% options = statset('UseParallel','always');

for p=1:10
    prediction_offset = prediction_offsets(p);
    [fea_train, train_targets, fea_test, test_chunk_id] = features(data, prediction_offset);
    tic
    for i=1:size(train_targets,2)
        [p,i]
        locs = find(train_targets(:,i)>=0);
        tm = TreeBagger(12,fea_train(locs,:),train_targets(locs,i),'method','regression','minleaf',200,'options',options);
        pred = predict(tm,fea_test);
        for j=1:length(test_chunk_id)
            test_predictions(test_chunk_id(j)*10-10+p,i) = pred(j);
        end
    end
    toc
end

for i=1:210
    if isempty(find(i==test_chunk_id))
        for j=1:39
            test_predictions( (i-1)*10+1:i*10,j) = median(test_predictions(:,j));
        end
    end
end

dlmwrite('predictions.csv',test_predictions);
