setup;

methodNames = {'SVM-Cost','SVM-Down','SVM-ADASYN','RF-Cost','RF-Down','RF-ADASYN','ML-KNN','IBLR','ECC','CLR','RAKEL','HOMER','COCOA','SF','SF-LR','SF-LR-CS','SF-H','SF-H-CS'};

%skip = [4,5,6,10,11,12,20,22,23,18];
skip = [];

methodNames(skip) = [];

dataTableAUCMean = [];
dataTableFMeasureMean = [];
dataTableAUCStd = [];
dataTableFMeasureStd = [];
dataTableAUCRank = [];
dataTableFMeasureRank = [];
meanRankAUC = [];
meanRankFMeasure = [];
significantAUC = [];
significantFMeasure = [];

%CAL500
dataLoc = [dataPath 'CAL500/'];
load([dataLoc 'output_fixed.mat']);
dataTableAUCMean = [dataTableAUCMean, mean(mean(AUCAll,3),2)];
dataTableFMeasureMean = [dataTableFMeasureMean, mean(mean(f1All,3),2)];
data = [];
for i = 1:1:18
    resultVals = squeeze(AUCAll(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableAUCStd = [dataTableAUCStd, data];
data = [];
for i = 1:1:18
    resultVals = squeeze(f1All(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableFMeasureStd = [dataTableFMeasureStd, data];

%Emotions
dataLoc = [dataPath 'emotions/'];
load([dataLoc 'output_fixed.mat']);
dataTableAUCMean = [dataTableAUCMean, mean(mean(AUCAll,3),2)];
dataTableFMeasureMean = [dataTableFMeasureMean, mean(mean(f1All,3),2)];
data = [];
for i = 1:1:18
    resultVals = squeeze(AUCAll(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableAUCStd = [dataTableAUCStd, data];
data = [];
for i = 1:1:18
    resultVals = squeeze(f1All(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableFMeasureStd = [dataTableFMeasureStd, data];

%Medical
dataLoc = [dataPath 'medical/'];
load([dataLoc 'output_fixed.mat']);
dataTableAUCMean = [dataTableAUCMean, mean(mean(AUCAll,3),2)];
dataTableFMeasureMean = [dataTableFMeasureMean, mean(mean(f1All,3),2)];
data = [];
for i = 1:1:18
    resultVals = squeeze(AUCAll(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableAUCStd = [dataTableAUCStd, data];
data = [];
for i = 1:1:18
    resultVals = squeeze(f1All(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableFMeasureStd = [dataTableFMeasureStd, data];

%Enron
dataLoc = [dataPath 'enron/'];
load([dataLoc 'output_fixed.mat']);
dataTableAUCMean = [dataTableAUCMean, mean(mean(AUCAll,3),2)];
dataTableFMeasureMean = [dataTableFMeasureMean, mean(mean(f1All,3),2)];
data = [];
for i = 1:1:18
    resultVals = squeeze(AUCAll(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableAUCStd = [dataTableAUCStd, data];
data = [];
for i = 1:1:18
    resultVals = squeeze(f1All(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableFMeasureStd = [dataTableFMeasureStd, data];

%Scene
dataLoc = [dataPath 'scene/'];
load([dataLoc 'output_fixed.mat']);
dataTableAUCMean = [dataTableAUCMean, mean(mean(AUCAll,3),2)];
dataTableFMeasureMean = [dataTableFMeasureMean, mean(mean(f1All,3),2)];
data = [];
for i = 1:1:18
    resultVals = squeeze(AUCAll(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableAUCStd = [dataTableAUCStd, data];
data = [];
for i = 1:1:18
    resultVals = squeeze(f1All(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableFMeasureStd = [dataTableFMeasureStd, data];

%Yeast
dataLoc = [dataPath 'yeast/'];
load([dataLoc 'output_fixed.mat']);
dataTableAUCMean = [dataTableAUCMean, mean(mean(AUCAll,3),2)];
dataTableFMeasureMean = [dataTableFMeasureMean, mean(mean(f1All,3),2)];
data = [];
for i = 1:1:18
    resultVals = squeeze(AUCAll(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableAUCStd = [dataTableAUCStd, data];
data = [];
for i = 1:1:18
    resultVals = squeeze(f1All(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableFMeasureStd = [dataTableFMeasureStd, data];

%Corel-5k
dataLoc = [dataPath 'corel5k/'];
load([dataLoc 'output_fixed.mat']);
dataTableAUCMean = [dataTableAUCMean, mean(mean(AUCAll,3),2)];
dataTableFMeasureMean = [dataTableFMeasureMean, mean(mean(f1All,3),2)];
data = [];
for i = 1:1:18
    resultVals = squeeze(AUCAll(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableAUCStd = [dataTableAUCStd, data];
data = [];
for i = 1:1:18
    resultVals = squeeze(f1All(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableFMeasureStd = [dataTableFMeasureStd, data];

% %RCV1-Subset1
dataLoc = [dataPath 'rcvsubset1/'];
load([dataLoc 'output_fixed.mat']);
dataTableAUCMean = [dataTableAUCMean, mean(mean(AUCAll,3),2)];
dataTableFMeasureMean = [dataTableFMeasureMean, mean(mean(f1All,3),2)];
data = [];
for i = 1:1:18
    resultVals = squeeze(AUCAll(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableAUCStd = [dataTableAUCStd, data];
data = [];
for i = 1:1:18
    resultVals = squeeze(f1All(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableFMeasureStd = [dataTableFMeasureStd, data];

%RCV1-Subset2
dataLoc = [dataPath 'rcvsubset2/'];
load([dataLoc 'output_fixed.mat']);
dataTableAUCMean = [dataTableAUCMean, mean(mean(AUCAll,3),2)];
dataTableFMeasureMean = [dataTableFMeasureMean, mean(mean(f1All,3),2)];
data = [];
for i = 1:1:18
    resultVals = squeeze(AUCAll(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableAUCStd = [dataTableAUCStd, data];
data = [];
for i = 1:1:18
    resultVals = squeeze(f1All(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableFMeasureStd = [dataTableFMeasureStd, data];

%TMC2007
dataLoc = [dataPath 'tmc2007/'];
load([dataLoc 'output_fixed.mat']);
dataTableAUCMean = [dataTableAUCMean, mean(mean(AUCAll,3),2)];
dataTableFMeasureMean = [dataTableFMeasureMean, mean(mean(f1All,3),2)];
data = [];
for i = 1:1:18
    resultVals = squeeze(AUCAll(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableAUCStd = [dataTableAUCStd, data];
data = [];
for i = 1:1:18
    resultVals = squeeze(f1All(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableFMeasureStd = [dataTableFMeasureStd, data];

%Mediamill
dataLoc = [dataPath 'mediamill/'];
load([dataLoc 'output_fixed.mat']);
dataTableAUCMean = [dataTableAUCMean, mean(mean(AUCAll,3),2)];
dataTableFMeasureMean = [dataTableFMeasureMean, mean(mean(f1All,3),2)];
data = [];
for i = 1:1:18
    resultVals = squeeze(AUCAll(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableAUCStd = [dataTableAUCStd, data];
data = [];
for i = 1:1:18
    resultVals = squeeze(f1All(i,:,:))';
    resultVals = mean(resultVals,2);
    data = [data; std(resultVals)];
end
dataTableFMeasureStd = [dataTableFMeasureStd, data];

dataTableAUCMean(skip,:) = [];
dataTableFMeasureMean(skip,:) = [];
dataTableAUCStd(skip,:) = [];
dataTableFMeasureStd(skip,:) = [];

k = 18;
N = 11;
alpha = 0.05 ./ (k-1);

[p,tbl,stats] = friedman(-dataTableAUCMean');
compareRank = stats.meanranks(18);
compareData = dataTableAUCMean(18,:);
for i = 1:1:k
    rankVal = stats.meanranks(i);
    z = (compareRank - rankVal) ./ sqrt((k*(k+1)/(6*N)));
    p = normcdf(z);
    significant = (p <= alpha);
    meanRankAUC = [meanRankAUC; rankVal];
    p2 = signrank(compareData,dataTableAUCMean(i,:));
    significant2 = (p2 <= alpha);
    significantAUC = [significantAUC; significant significant2];
    %disp([methodNames{i} ' : ' num2str(p) ' ' num2str(p2) ' ' num2str(alpha)]);
end

[p,tbl,stats] = friedman(-dataTableFMeasureMean');
compareRank = stats.meanranks(18);
compareData = dataTableFMeasureMean(18,:);
for i = 1:1:k
    rankVal = stats.meanranks(i);
    z = (compareRank - rankVal) ./ sqrt((k*(k+1)/(6*N)));
    p = normcdf(z);
    significant = (p <= alpha);
    meanRankFMeasure = [meanRankFMeasure; rankVal];
    p2 = signrank(compareData,dataTableFMeasureMean(i,:));
    significant2 = (p2 <= alpha);
    significantFMeasure = [significantFMeasure; significant significant2];
    %disp([methodNames{i} ' : ' num2str(p) ' ' num2str(p2) ' ' num2str(alpha)]);
end

[~,dataTableAUCRank] = sort(dataTableAUCMean,1,'descend');
[~,dataTableFMeasureRank] = sort(dataTableFMeasureMean,1,'descend');

save('output/results.mat','methodNames','dataTableAUCMean','dataTableFMeasureMean','dataTableAUCStd','dataTableFMeasureStd','dataTableAUCRank','dataTableFMeasureRank','meanRankAUC','meanRankFMeasure','significantAUC','significantFMeasure');
