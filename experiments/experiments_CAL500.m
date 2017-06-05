setup;

currentPath = pwd;
dataFolder = [dataPath 'CAL500/'];
load([dataFolder 'data.mat']);
xmlLocation = 'CAL500New.xml';

disp('Dataset Statistics');
disp(['Num Instances: ' num2str(numInstances)]);
disp(['Num Labels: ' num2str(numLabels)]);
disp(['Num Features: ' num2str(numFeatures)]);
labels = data(:,numFeatures+1:numFeatures + numLabels);
imbalance = max(sum(labels),sum(~labels)) ./ min(sum(labels),sum(~labels));
disp(['Max Imbalance: ' num2str(max(imbalance))]);
disp(['Min Imbalance: ' num2str(min(imbalance))]);
disp(['Mean Imbalance: ' num2str(mean(imbalance))]);

%1: Both OHF and All Other Methods
%2: OHF Only
%3: All Other Methods Only
runFlag = 1;

normalizeFlag = true;

minLeaf = 3;
tradeoff = [];%0.5;
maxIters = 3000;
labelSampling = 0.75;
featureSampling = 0.75;
instanceSampling = 0.75;
usedWeightParam = 5;
marginParam = 0.1;

if exist([dataFolder 'output_fixed.mat'],'file')
    load([dataFolder 'output_fixed.mat']);
end

if ~exist('precisionAll','var')
    precisionAll = [];
end
if ~exist('recallAll','var')
    recallAll = [];
end
if ~exist('f1All','var')
    f1All = [];
end
if ~exist('AUCAll','var')
    AUCAll = [];
end

[precisionAll,recallAll,f1All,AUCAll] = run_experiments(minLeaf,tradeoff,marginParam,maxIters,labelSampling,featureSampling,instanceSampling,usedWeightParam,normalizeFlag,runFlag,currentPath,dataFolder,xmlLocation,mulanPath,data,cvIndices,numSplits,numLabels,numFeatures,precisionAll,recallAll,f1All,AUCAll);

save([dataFolder 'output_fixed.mat'],'precisionAll','recallAll','f1All','AUCAll','-v7.3');