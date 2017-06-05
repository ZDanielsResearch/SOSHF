function weights = loss_optimize(features,labels,rho,alpha,numIterations,minLeaf,imbalance)

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

initial(initial == 2) = -1;

if sum(initial == 1) <= minLeaf || sum(initial == -1) <= minLeaf
    weights = zeros(numFeatures,1);
    return;
end

weights = lsqr(features,initial,1e-8,500);

for stage = 1:1:2
    
    bestWeights = weights;
    bestLoss = inf;
    
    sameCount = 0;
    previous = inf;
    
    m = zeros(size(weights));
    v = zeros(size(weights));
    
    learningRate = 0.01;
    batchSize = min(1000,numInstances);
    
    if isempty(rho)
        rho = min(log(1 + (numFeatures ./ numInstances)),0.4);
    end
    
    %prevLoss = 0;
    %prevGrad = [];
    
    if stage == 1
        gamma1 = 0;
    else
        gamma1 = rho .* abs(sloss_hellinger(weights,features,initial,alpha,0,false) ./ norm(weights,1));
    end
    
    numIterations2 = ceil(numIterations ./ ceil(numInstances ./ batchSize));
    
    t = 1;
    m = zeros(size(weights));
    v = zeros(size(weights));
    
    for i = 1:1:numIterations2
        
        order = randperm(numInstances);
                    
        for j = 1:batchSize:numInstances
            breakFlag = false;
            if numInstances - j < (0.5 .* batchSize)
                break
            end
            features2 = features(order(j:min(j + batchSize - 1,numInstances)),:);
            initial2 = initial(order(j:min(j + batchSize - 1,numInstances)),:);
            [loss,gradient] = sloss_hellinger(weights,features2,initial2,alpha,gamma1,true);
                        
            if norm(gradient) ~= 0
                beta1 = 0.9;
                beta2 = 0.999;
                eps = 1e-8;
                m = beta1 .* m + (1 - beta1) .* gradient;
                v = beta2 .* v + (1 - beta2) .* (gradient .^2);
                m = m ./ (1 - beta1.^t);
                v = v ./ (1 - beta2.^t);
                weights2 = weights - learningRate .* m ./ (sqrt(v) + eps);
                weights = weights2;
            else
                breakFlag = true;
                break;
            end
            
            t = t + 1;
            
            if alpha == 4
                if abs(loss - previous) <= 0.00001
                    sameCount = sameCount + 1;
                else
                    previous = loss;
                    sameCount = 0;
                end

                if sameCount >= 30
                    breakFlag = true;
                    break;
                end
                
                if mod(t,25) == 0
                    m = zeros(size(weights));
                    v = zeros(size(weights));
                    t = 1;
                end
                
            else
                if mod(t,10) == 0
                    alpha = min(alpha .* 1.5, 4);
                    m = zeros(size(weights));
                    v = zeros(size(weights));
                    t = 1;
                    previous = loss;
                    sameCount = 0;
                end
            end
            
            if alpha ~= 4
                %LOSS WITH ALPHA = 4
                loss = sloss_hellinger(weights,features2,initial2,4,gamma1,false);
            end
            
            if loss <= bestLoss
                bestLoss = loss;
                bestWeights = weights;
            end
            
            if breakFlag
                break;
            end
        end
    end
    
    weights = bestWeights;
    
end

weights = weights ./ norm(weights);

end

