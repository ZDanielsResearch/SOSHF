function [index,thresh] = loss_optimize_sf(features,labels,minLeaf)

[numInstances,numFeatures] = size(features);
numLabels = size(labels,2);

labels2 = double(labels);

labels2(:,sum(labels2) == 1) = [];
labels2(:,sum(labels2) == 0) = [];
labels2(:,sum(~labels2) == 1) = [];
labels2(:,sum(~labels2) == 0) = [];

[numUniqueInstances,numRemainingLabels] = size(labels2);

if numInstances <= minLeaf || numUniqueInstances <= minLeaf || numRemainingLabels < 1
    index = 1;
    thresh = 0;
    return;
end

initial = kmeans(labels2,2);
initial(initial == 2) = 0;

if sum(initial == 1) <= minLeaf || sum(initial == 0) <= minLeaf
    index = 1;
    thresh = 0;
    return;
end

bestIndex = 1;
bestThresh = 0;
bestVal = 0;

for i = 1:1:numFeatures
    featureVals = unique(features(:,i));
    numFeatureVals = length(featureVals);
    for j = 2:1:numFeatureVals
        thresh = (featureVals(j-1) + featureVals(j))./2;
        val = hd(double(features(:,i) >= thresh),initial);
        if val >= bestVal
            bestIndex = i;
            bestThresh = thresh;
            bestVal = val;
        end
    end
end

index = bestIndex;
thresh = bestThresh;

end

