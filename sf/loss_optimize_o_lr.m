function weights = loss_optimize_o_lr(features,labels,rho,alpha,numIterations,minLeaf,imbalance)

[numInstances,numFeatures] = size(features);
numLabels = size(labels,2);

labels2 = double(labels);

labels2(:,sum(labels2) == 1) = [];
labels2(:,sum(labels2) == 0) = [];
labels2(:,sum(~labels2) == 1) = [];
labels2(:,sum(~labels2) == 0) = [];

[numUniqueInstances,numRemainingLabels] = size(labels2);

if numInstances <= minLeaf || numUniqueInstances <= minLeaf || numRemainingLabels < 1
    weights = zeros(numFeatures,1);
    return;
end

initial = kmeans(labels2,2,'distance','sqeuclidean','maxIter',1000);
initial(initial == 2) = 0;

if sum(initial == 1) <= minLeaf || sum(initial == 0) <= minLeaf
    weights = zeros(numFeatures,1);
    return;
end

weights = glmfit(features,initial,'binomial','link','logit','constant','off');

weights = weights ./ norm(weights);

end

