dataFolder = [dataPath 'rcvsubset2/'];

header = '';
numFeatures = 47236;
numFeaturesOld = numFeatures;
numLabels = 101;
numAttributes = numFeatures + numLabels;
numInstances = 6000;
numSplits = 8;
data = zeros(numInstances,numAttributes);

originalFile = fopen([dataFolder 'rcv1subset2.arff'],'r');

count = 1;
tline = fgets(originalFile);
while ischar(tline)
    
    if mod(count,100) == 0
        disp(count);
    end
    
    if tline(1) == '{'
        data2 = strsplit(tline,',');
        for i = 1:1:length(data2)
            dataTemp = data2{i};
            if i == 1
                dataTemp = dataTemp(2:length(dataTemp));
            end
            if i == length(data2)
                dataTemp = dataTemp(1:strfind(dataTemp,'}')-1);
            end
            dataTemp = strsplit(dataTemp,' ');
            index = int32(str2double(dataTemp{1})) + 1;
            value = str2double(dataTemp{2});
            data(count,index) = value;
        end
        count = count + 1;
    end
    
    tline = fgets(originalFile);
end

fclose(originalFile);

data2 = data > 0;
removed = (sum(data2) ./ sum(~data2)) >= 50 | (sum(~data2) ./ sum(data2)) >= 50 | sum(data2) < 20;
removed(1:numFeatures) = 0;
removed = removed | sum(data2) < round(0.01 .* numInstances);
data = data(:,~removed);
removed = find(removed);

numFeatures2 = numFeatures - sum(removed <= numFeatures);
numLabels = numLabels - sum(removed > numFeatures);
numFeatures = numFeatures2;
numAttributes = numFeatures + numLabels;

originalFile = fopen([dataFolder 'rcv1subset2.xml']);
newFile = fopen([dataFolder 'rcv1subset2New.xml'],'w');

count = numFeaturesOld+1;
tline = fgets(originalFile);
while ischar(tline)
    if ~isempty(strfind(tline, 'label name'))
        if ~ismember(count,removed)
            fprintf(newFile,tline);
        end
        count = count + 1;
    else
        fprintf(newFile,tline);
    end
    
    tline = fgets(originalFile);
end

fclose(originalFile);
fclose(newFile);

originalFile = fopen([dataFolder 'rcv1subset2.arff']);

count = 0;
tline = fgets(originalFile);
while ischar(tline)
    if tline(1) == '@'
        if ~ismember(count,removed)
            header = [header tline];
        end
        count = count + 1;
    end
    
    tline = fgets(originalFile);
end

fclose(originalFile);

cvIndices = [];
for i = 1:1:numSplits
    cvIndices = [cvIndices,crossvalind('HoldOut',numInstances,0.5)];
end

cvIndices = logical(cvIndices);
save([dataFolder 'data.mat'],'header','numFeatures','numLabels','numAttributes','numInstances','numSplits','cvIndices','data','removed','-v7.3');

outputFormat = [];

for j = 1:1:numFeatures
    outputFormat = [outputFormat, '%d,'];
end

for j = 1:1:numLabels
    outputFormat = [outputFormat, '%d,'];
end
outputFormat = outputFormat(1:length(outputFormat)-1);
outputFormat = [outputFormat, '\n'];

for i = 1:1:numSplits
    outputTraining = [dataFolder 'training_' num2str(i) '.arff'];
    outputTest = [dataFolder 'test_' num2str(i) '.arff'];
    
    trainingFile = fopen(outputTraining,'w');
    fprintf(trainingFile,header);
    
    testFile = fopen(outputTest,'w');
    fprintf(testFile,header);
    
    trainingFeatures = data(cvIndices(:,i),1:numFeatures);
    trainingMean = mean(trainingFeatures);
    trainingStd = std(trainingFeatures);
    data2 = data;
    data2(:,1:numFeatures) = bsxfun(@minus,data2(:,1:numFeatures),trainingMean);
    data2(:,1:numFeatures) = bsxfun(@rdivide,data2(:,1:numFeatures),trainingStd);
    data2(isnan(data2)) = 0;
    data2(isinf(data2)) = 0;
    
    for j = 1:1:numInstances
        if cvIndices(j,i) == 0
            fprintf(testFile,outputFormat,data2(j,:));
        else
            fprintf(trainingFile,outputFormat,data2(j,:));
        end
    end
    
    fclose(trainingFile);
    fclose(testFile);
end