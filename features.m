function [fea_train, train_targets, fea_test, test_chunk_id] = features(data, prediction_offset)

time_back = 8;

fea_train = zeros(40000, 3 + 89*time_back);
fea_test = zeros(500, 3 + 89*time_back);

train_targets = zeros(40000, 39);

test_chunk_id = [];

fea_cnt = 0;
test_cnt = 0;
for i=1:size(data,1)-time_back-prediction_offset+1
    if data(i,2)==data(i+time_back+prediction_offset-1,2)
        fea_cnt = fea_cnt + 1;
        fea_train(fea_cnt,1:3) = data(i, 4:6);
        this_fea = data(i:i+time_back-1,7:95);
        fea_train(fea_cnt,4:end) = this_fea(:)';
        
        train_targets(fea_cnt, :) = data(i+time_back+prediction_offset-1, 95-39+1:95);
    end
    
    if data(i,2) ~= data(i+1,2)
        test_cnt = test_cnt + 1;
        i_back = i - time_back + 1;
        fea_test(test_cnt,1:3) = data(i_back, 4:6);

        this_fea = data(i_back:i_back+time_back-1,7:95);
        fea_test(test_cnt,4:end) = this_fea(:)';
        test_chunk_id(end+1) = data(i_back,2);
    end
end

test_cnt = test_cnt + 1;
i_back = size(data,1) - time_back + 1;
fea_test(test_cnt,1:3) = data(i_back, 4:6);

this_fea = data(i_back:i_back+time_back-1,7:95);
fea_test(test_cnt,4:end) = this_fea(:)'; 
test_chunk_id(end+1) = data(i_back,2);

train_targets = train_targets(1:fea_cnt,:);
fea_train = fea_train(1:fea_cnt,:);
fea_test = fea_test(1:test_cnt, :);
