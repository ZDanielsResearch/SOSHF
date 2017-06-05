function weights = loss_optimize_o_lr_cs(features,labels,rho,alpha,numIterations,minLeaf,imbalance)

[numInstances,numFeatures] = size(features);
numLabels = size(labels,2);

labels2 = double(labels);

imbalance(:,sum(labels2) == 1) = [];
labels2(:,sum(labels2) == 1) = [];
imbalance(:,sum(labels2) == 0) = [];
labels2(:,sum(labels2) == 0) = [];
imbalance(:,sum(~labels2) == 1) = [];
labels2(:,sum(~labels2) == 1) = [];
imbalance(:,sum(~labels2) == 0) = [];

labels2(:,sum(~labels2) == 0) = [];

[numUniqueInstances,numRemainingLabels] = size(labels2);

if numInstances <= minLeaf || numUniqueInstances <= minLeaf || numRemainingLabels < 1
    weights = zeros(numFeatures,1);
    return;
end

beta = 0.5;

N = size(labels2,1);
encoderWeights = log(1 + (N ./ sum(labels2)));
encoderWeights = encoderWeights ./ max(encoderWeights);
encoderWeights = beta .* encoderWeights + (1-beta) .* imbalance;
labels2 = labels2 .* repmat(encoderWeights,[N,1]);
labels2(isnan(labels2)) = 0;

initial = kmeans(labels2,2,'distance','sqeuclidean','maxIter',1000);
initial(initial == 2) = 0;

if sum(initial == 1) <= minLeaf || sum(initial == 0) <= minLeaf
    weights = zeros(numFeatures,1);
    return;
end

weights = glmfit(features,initial,'binomial','link','logit','constant','off');

weights = weights ./ norm(weights);


end

