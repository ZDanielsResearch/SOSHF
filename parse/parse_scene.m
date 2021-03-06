dataFolder = [dataPath 'scene/'];

header = '';
numFeatures = 294;
numLabels = 6;
numAttributes = numFeatures + numLabels;
numInstances = 2407;
numSplits = 8;
data = zeros(numInstances,numAttributes);

originalFile = fopen([dataFolder 'scene.arff']);

count = 1;
tline = fgets(originalFile);
while ischar(tline)
    if tline(1) ~= '@'
        data2 = strsplit(tline,',');
        if length(data2) == numAttributes;
            data(count,:) = str2double(data2);
            count = count + 1;
        end
    end
    
    tline = fgets(originalFile);
end

fclose(originalFile);

removed = sum(data) < 20 | (sum(data) ./ sum(~data)) >= 50 | (sum(~data) ./ sum(data)) >= 50;
removed(1:numFeatures) = 0;
data = data(:,~removed);
removed = find(removed);

numLabels = numLabels - length(removed);
numAttributes = numFeatures + numLabels;

originalFile = fopen([dataFolder 'scene.xml']);
newFile = fopen([dataFolder 'sceneNew.xml'],'w');

count = numFeatures+1;
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

originalFile = fopen([dataFolder 'scene.arff']);

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

%cvIndices = crossvalind('Kfold',numInstances,numSplits);

cvIndices = [];
for i = 1:1:numSplits
    cvIndices = [cvIndices,crossvalind('HoldOut',numInstances,0.5)];
end

cvIndices = logical(cvIndices);
save([dataFolder 'data.mat'],'header','numFeatures','numLabels','numAttributes','numInstances','numSplits','cvIndices','data','removed','-v7.3');

outputFormat = [];

for j = 1:1:numFeatures
    outputFormat = [outputFormat, '%6.4f,'];
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