function printRowInfoCharacteristics(dataLoc,name)

load([dataLoc 'data.mat']);
labels = data(:,numFeatures+1:numFeatures + numLabels);
labelType = 'Numeric';
if sum(sum(data ~= 1 & data ~= 0)) == 0
    labelType = 'Nominal';
end
labelDensity = mean(sum(labels,2)) ./ numLabels;
uniqueCombos = unique(labels,'rows');
proportionDistinctLabelCombos = size(uniqueCombos,1) ./ numInstances;
imbalance = max(sum(labels),sum(~labels)) ./ min(sum(labels),sum(~labels));
minImbalance = min(imbalance);
maxImbalance = max(imbalance);
meanImbalance = mean(imbalance);
rowVal = sprintf('%s & %d & %d & %d & %s & %1.2f & %1.2f & %1.2f & %1.2f & %1.2f \\\\',name,numInstances,numFeatures,numLabels,labelType,labelDensity,proportionDistinctLabelCombos,minImbalance,maxImbalance,meanImbalance);
disp(rowVal);
disp('\hline');

end