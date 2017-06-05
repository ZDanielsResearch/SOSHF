function tree = construct_tree_o(features,labels,minLeaf,rho,alpha,numIterations,labelSampling,featureSampling,instanceSampling,usedWeightParam)

if isempty(labelSampling)
    labelSampling = 1;
end

if isempty(featureSampling)
    featureSampling = 1;
end

if isempty(instanceSampling)
    instanceSampling = 1;
end

if isempty(usedWeightParam)
    usedWeightParam = 5;
end

featuresOld = features;
[numInstances,numFeatures] = size(features);
oobIndices = ones(numInstances,1);
numInstancesSampled = max(1,round(instanceSampling.*numInstances));
selectedInstances = randperm(numInstances);
selectedInstances = selectedInstances(1:numInstancesSampled);
features = features(selectedInstances,:);
labels = labels(selectedInstances,:);

labelsOld = labels;
[~,numLabels] = size(labels);

numFeaturesSampled = max(1,round(featureSampling .* numFeatures));
selectedFeatures = randperm(numFeatures);
selectedFeatures = selectedFeatures(1:numFeaturesSampled);
features = features(:,selectedFeatures);
tree.selectedFeatures = selectedFeatures;

[numInstances,numFeatures] = size(features);
predictions = zeros(numInstances*10,numLabels);
tree.predWeights = ones(numLabels,1);
tree.numLabels = numLabels;

numLabelsSampled = max(1,round(labelSampling.*numLabels));
selectedLabels = randperm(numLabels);
selectedLabels = selectedLabels(1:numLabelsSampled);
labels = labels(:,selectedLabels);
%imbalance = max(sum(labels),sum(~labels)) ./ min(sum(labels),sum(~labels));
%imbalance = imbalance ./ max(imbalance);

imbalance = log(1 + (numInstances ./ sum(labels)));

currentNode = ones(numInstances,1);
maxNode = 2;
features = [features, ones(numInstances,1)];
weights = zeros(numInstances*10,numFeatures+1);
nextNode = zeros(numInstances*10,2);

while sum(currentNode > 0) ~= 0
    nodeIDs = unique(currentNode);
    for i = 1:1:length(nodeIDs)
        if nodeIDs(i) <= 0
            continue;
        end
        percentComplete = 1 - (sum(currentNode > 0) ./ numInstances);
        disp(['Percent Complete: ' num2str(percentComplete)]);
        indices = find(currentNode == nodeIDs(i));
                
%         selectedFeatures = randperm(numFeatures);
%         selectedFeatures = [selectedFeatures(1:numFeaturesSampled) numFeatures+1];
        
%         featuresNode = features(indices,:);
%         featuresNode2 = features(indices,selectedFeatures);
%         labelsNode = labels(indices,:);
%         weightsNode2 = loss_optimize(featuresNode2,labelsNode,rho,alpha,numIterations,minLeaf,imbalance);
%         weightsNode = zeros(numFeatures,1);
%         weightsNode(selectedFeatures) = weightsNode2;
        
        featuresNode = features(indices,:);
        featuresNode2 = featuresNode;
        labelsNode = labels(indices,:);
        weightsNode = loss_optimize_o(featuresNode2,labelsNode,rho,alpha,numIterations,minLeaf,imbalance);

        assignments = featuresNode*weightsNode;
        assignments = assignments > 0;
        [sum(assignments) sum(~assignments)]
        vals = [sum(labelsNode(assignments,:),1); sum(labelsNode(~assignments,:),1)];
        splitTestVals = max(vals) ./ min(vals)
        
        probabilities = sum(labelsNode) ./ size(labelsNode,1);
        entropies = -probabilities.*log2(probabilities) - (1-probabilities).*log2(1-probabilities);
        entropies(isnan(entropies)) = 0;
        entropies
        mean(entropies)
        
        if ((sum(assignments) < minLeaf) || (sum(~assignments) < minLeaf)) || sum(assignments) == 0 || sum(~assignments) == 0
%             if mean(entropies) >= 0.8
%                 [~,scores] = pca(featuresNode);
%                 figure;
%                 [a,b,c] = unique(labelsNode,'rows');
%                 scatter(scores(:,1),scores(:,2),50,c,'*');
%                 keyboard;
%             end
            currentLabels = labelsOld(currentNode == nodeIDs(i),:);
            currentNode(indices(assignments)) = 0;
            nextNode(nodeIDs(i),1) = -maxNode;
            currentNode(indices(~assignments)) = 0;
            nextNode(nodeIDs(i),2) = -maxNode;
            predictions(maxNode,:) = sum(currentLabels,1) ./ size(currentLabels,1);
            maxNode = maxNode + 1;
        elseif (sum(assignments) < minLeaf)
            currentLabels = labelsOld(currentNode == nodeIDs(i),:);
            currentNode(indices(assignments)) = 0;
            nextNode(nodeIDs(i),1) = -maxNode;
            predictions(maxNode,:) = sum(currentLabels,1) ./ size(currentLabels,1);
            maxNode = maxNode + 1;
            currentNode(indices(~assignments)) = maxNode;
            nextNode(nodeIDs(i),2) = maxNode;
            maxNode = maxNode + 1;
        elseif (sum(~assignments) < minLeaf)
            currentLabels = labelsOld(currentNode == nodeIDs(i),:);
            currentNode(indices(~assignments)) = 0;
            nextNode(nodeIDs(i),2) = -maxNode;
            predictions(maxNode,:) = sum(currentLabels,1) ./ size(currentLabels,1);
            maxNode = maxNode + 1;
            currentNode(indices(assignments)) = maxNode;
            nextNode(nodeIDs(i),1) = maxNode;
            maxNode = maxNode + 1;
        else
            currentNode(indices(assignments)) = maxNode;
            nextNode(nodeIDs(i),1) = maxNode;
            maxNode = maxNode + 1;
            currentNode(indices(~assignments)) = maxNode;
            nextNode(nodeIDs(i),2) = maxNode;
            maxNode = maxNode + 1;
        end
                
        weights(nodeIDs(i),:) = weightsNode;
    end
end

predictions(isnan(predictions)) = 0;

weights(maxNode:numInstances*10,:) = [];
nextNode(maxNode:numInstances*10,:) = [];
predictions(maxNode:numInstances*10,:) = [];

tree.weights = weights;
tree.nextNode = nextNode;
tree.predictions = predictions;
tree.predWeights(selectedLabels) = usedWeightParam;

oobPredictions = predict_tree(tree,featuresOld);
oobPredictions(selectedInstances,:) = 0;
oobIndices(selectedInstances) = 0;

tree.oobPredictions = oobPredictions;
tree.oobIndices = double(oobIndices);

%keyboard;

end

