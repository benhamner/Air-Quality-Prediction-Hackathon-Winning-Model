function data = read_data()

fprintf('Reading data ...\n');
fid = fopen('TrainingData.csv');
fgetl(fid);

data = zeros(37821,95);
days = {'"Saturday"','"Sunday"','"Monday"','"Tuesday"','"Wednesday"','"Thursday"','"Friday"'};
row_cnt = 0;

while ~feof(fid)
    row_cnt = row_cnt + 1;
    line = fgetl(fid);
    C = strread(line,'%s','delimiter',',');
    for i=1:95
        if i==5
            data(row_cnt,5) = find(strcmp(days,C{5}));
        else
            if strcmp(C{i},'NA')
                data(row_cnt,i) = -1000000;
            else
                data(row_cnt,i) = str2num(C{i});
            end
        end
    end
end

fprintf('Read in %d rows\n', row_cnt);
