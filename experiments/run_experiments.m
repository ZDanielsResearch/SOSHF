function [precisionAll,recallAll,f1All,AUCAll] = run_experiments(minLeaf,tradeoff,marginParam,maxIters,labelSampling,featureSampling,instanceSampling,usedWeightParam,normalizeFlag,runFlag,currentPath,dataFolder,xmlLocation,mulanPath,data,cvIndices,numSplits,numLabels,numFeatures,precisionAll,recallAll,f1All,AUCAll,numTreesCOCOA)

dbstop if error;

methodNames = {'SVM-Cost','SVM-Down','SVM-ADASYN','RF-50-Cost','RF-50-Down','RF-50-ADASYN','ML-KNN','IBLR','ECC','CLR','RAKEL','HOMER','COCOA','SF','SF-LR','SF-LRCS','SF-H','SOSHF'};

if isempty(precisionAll)
    precisionAll = zeros(18,numLabels,numSplits);
end
if isempty(recallAll)
    recallAll = zeros(18,numLabels,numSplits);
end
if isempty(f1All)
    f1All = zeros(18,numLabels,numSplits);
end
if isempty(AUCAll)
    AUCAll = zeros(18,numLabels,numSplits);
end

if runFlag ~= 2
    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);

        %None
        trainingData = data(cvIndices(:,i),:);
        trainingFeatures = trainingData(:,1:numFeatures);
        if normalizeFlag
            trainingMean = mean(trainingFeatures);
            trainingStd = std(trainingFeatures);
            trainingFeatures = bsxfun(@minus,trainingFeatures,trainingMean);
            trainingFeatures = bsxfun(@rdivide,trainingFeatures,trainingStd);
            trainingFeatures(isnan(trainingFeatures)) = 0;
            trainingFeatures(isinf(trainingFeatures)) = 0;
        end
        trainingLabels = trainingData(:,numFeatures+1:numFeatures+numLabels);

        testData = data(~cvIndices(:,i),:);
        testFeatures = testData(:,1:numFeatures);
        if normalizeFlag
            testFeatures = bsxfun(@minus,testFeatures,trainingMean);
            testFeatures = bsxfun(@rdivide,testFeatures,trainingStd);
            testFeatures(isnan(testFeatures)) = 0;
            testFeatures(isinf(testFeatures)) = 0;
        end
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);

        disp('Individual, None');

        precisionTempSVM = zeros(1,numLabels);
        recallTempSVM = zeros(1,numLabels);
        f1TempSVM = zeros(1,numLabels);
        AUCTempSVM = zeros(1,numLabels);

        for j = 1:1:numLabels
            disp(['Label #' num2str(j)]);

            %%SVM:1
            model = fitcsvm(trainingFeatures,trainingLabels(:,j),'Prior','Uniform');
            [predictions,scores] = predict(model,testFeatures);
            [precision,recall,f1] = get_statistics(testLabels(:,j),predictions);
            precisionTempSVM(j) = precision;
            recallTempSVM(j) = recall;
            f1TempSVM(j) = f1;
            [~,~,~,AUC] = perfcurve(testLabels(:,j),scores(:,2),1);
            AUCTempSVM(j) = AUC;
        end

        precisionAll(1,:,i) = precisionTempSVM;
        recallAll(1,:,i) = recallTempSVM;
        f1All(1,:,i) = f1TempSVM;
        AUCAll(1,:,i) = AUCTempSVM;
    end

    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);

        %Downsample
        trainingData = data(cvIndices(:,i),:);
        trainingFeatures = trainingData(:,1:numFeatures);
        if normalizeFlag
            trainingMean = mean(trainingFeatures);
            trainingStd = std(trainingFeatures);
            trainingFeatures = bsxfun(@minus,trainingFeatures,trainingMean);
            trainingFeatures = bsxfun(@rdivide,trainingFeatures,trainingStd);
            trainingFeatures(isnan(trainingFeatures)) = 0;
            trainingFeatures(isinf(trainingFeatures)) = 0;
        end
        trainingLabels = trainingData(:,numFeatures+1:numFeatures+numLabels);

        testData = data(~cvIndices(:,i),:);
        testFeatures = testData(:,1:numFeatures);
        if normalizeFlag
            testFeatures = bsxfun(@minus,testFeatures,trainingMean);
            testFeatures = bsxfun(@rdivide,testFeatures,trainingStd);
            testFeatures(isnan(testFeatures)) = 0;
            testFeatures(isinf(testFeatures)) = 0;
        end
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);

        disp('Individual, Downsample');

        precisionTempSVM = zeros(1,numLabels);
        recallTempSVM = zeros(1,numLabels);
        f1TempSVM = zeros(1,numLabels);
        AUCTempSVM = zeros(1,numLabels);

        for j = 1:1:numLabels
            disp(['Label #' num2str(j)]);
            trainingLabels2 = trainingLabels(:,j);
            positive = find(trainingLabels2);
            negative = find(~trainingLabels2);
            numPositive = length(positive);
            numNegative = length(negative);
            downSample = min(numPositive,numNegative);
            trainingIndices = [positive(1:downSample); negative(1:downSample)];
            trainingLabels2 = trainingLabels2(trainingIndices,:);
            trainingFeatures2 = trainingFeatures(trainingIndices,:);

            %%SVM:2
            model = fitcsvm(trainingFeatures2,trainingLabels2);
            [predictions,scores] = predict(model,testFeatures);
            [precision,recall,f1] = get_statistics(testLabels(:,j),predictions);
            precisionTempSVM(j) = precision;
            recallTempSVM(j) = recall;
            f1TempSVM(j) = f1;
            [~,~,~,AUC] = perfcurve(testLabels(:,j),scores(:,2),1);
            AUCTempSVM(j) = AUC;
        end

        precisionAll(2,:,i) = precisionTempSVM;
        recallAll(2,:,i) = recallTempSVM;
        f1All(2,:,i) = f1TempSVM;
        AUCAll(2,:,i) = AUCTempSVM;
    end

    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);

        %ADASYN (SMOTE Extension)
        trainingData = data(cvIndices(:,i),:);
        trainingFeatures = trainingData(:,1:numFeatures);
        if normalizeFlag
            trainingMean = mean(trainingFeatures);
            trainingStd = std(trainingFeatures);
            trainingFeatures = bsxfun(@minus,trainingFeatures,trainingMean);
            trainingFeatures = bsxfun(@rdivide,trainingFeatures,trainingStd);
            trainingFeatures(isnan(trainingFeatures)) = 0;
            trainingFeatures(isinf(trainingFeatures)) = 0;
        end
        trainingLabels = trainingData(:,numFeatures+1:numFeatures+numLabels);

        testData = data(~cvIndices(:,i),:);
        testFeatures = testData(:,1:numFeatures);
        if normalizeFlag
            testFeatures = bsxfun(@minus,testFeatures,trainingMean);
            testFeatures = bsxfun(@rdivide,testFeatures,trainingStd);
            testFeatures(isnan(testFeatures)) = 0;
            testFeatures(isinf(testFeatures)) = 0;
        end
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);

        disp('Individual, ADASYN');

        precisionTempSVM = zeros(1,numLabels);
        recallTempSVM = zeros(1,numLabels);
        f1TempSVM = zeros(1,numLabels);
        AUCTempSVM = zeros(1,numLabels);

        for j = 1:1:numLabels
            disp(['Label #' num2str(j)]);
            trainingLabels2 = trainingLabels(:,j);
            [trainingFeatures3, trainingLabels3] = ADASYN(trainingFeatures, trainingLabels2, [], [], [], false);
            trainingFeatures2 = [trainingFeatures; trainingFeatures3];
            trainingLabels2 = [trainingLabels2; trainingLabels3];

            %%SVM:3
            model = fitcsvm(trainingFeatures2,trainingLabels2);
            [predictions,scores] = predict(model,testFeatures);
            [precision,recall,f1] = get_statistics(testLabels(:,j),predictions);
            precisionTempSVM(j) = precision;
            recallTempSVM(j) = recall;
            f1TempSVM(j) = f1;
            [~,~,~,AUC] = perfcurve(testLabels(:,j),scores(:,2),1);
            AUCTempSVM(j) = AUC;

        end

        precisionAll(3,:,i) = precisionTempSVM;
        recallAll(3,:,i) = recallTempSVM;
        f1All(3,:,i) = f1TempSVM;
        AUCAll(3,:,i) = AUCTempSVM;
    end

    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);

        %None
        trainingData = data(cvIndices(:,i),:);
        trainingFeatures = trainingData(:,1:numFeatures);
        if normalizeFlag
            trainingMean = mean(trainingFeatures);
            trainingStd = std(trainingFeatures);
            trainingFeatures = bsxfun(@minus,trainingFeatures,trainingMean);
            trainingFeatures = bsxfun(@rdivide,trainingFeatures,trainingStd);
            trainingFeatures(isnan(trainingFeatures)) = 0;
            trainingFeatures(isinf(trainingFeatures)) = 0;
        end
        trainingLabels = trainingData(:,numFeatures+1:numFeatures+numLabels);

        testData = data(~cvIndices(:,i),:);
        testFeatures = testData(:,1:numFeatures);
        if normalizeFlag
            testFeatures = bsxfun(@minus,testFeatures,trainingMean);
            testFeatures = bsxfun(@rdivide,testFeatures,trainingStd);
            testFeatures(isnan(testFeatures)) = 0;
            testFeatures(isinf(testFeatures)) = 0;
        end
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);

        disp('Individual, None');

        precisionTempRF = zeros(1,numLabels);
        recallTempRF = zeros(1,numLabels);
        f1TempRF = zeros(1,numLabels);
        AUCTempRF = zeros(1,numLabels);

        for j = 1:1:numLabels
            disp(['Label #' num2str(j)]);

            %%RF:4
            model = TreeBagger(50,trainingFeatures,trainingLabels(:,j),'MinLeafSize',minLeaf,'InBagFraction',instanceSampling,'NumPredictorsToSample',max(1,round(featureSampling.*numFeatures)),'SplitCriterion','deviance','MergeLeaves','off','Prune','off','SampleWithReplacement','off','OOBPrediction','on');
            [predictions,scores] = predict(model,testFeatures);
            predictions = str2double(predictions);
            [~,oobScores] = oobPredict(model);
            thresh = 0;
            bestF = 0;
            for k = 0:0.05:1
                [~,~,f1] = get_statistics(trainingLabels(:,j),oobScores(:,2) >= k);
                if f1 >= bestF
                    thresh = k;
                    bestF = f1;
                end
            end


            [precision,recall,f1] = get_statistics(testLabels(:,j),scores(:,2) >= thresh);
            precisionTempRF(j) = precision;
            recallTempRF(j) = recall;
            f1TempRF(j) = f1;
            [~,~,~,AUC] = perfcurve(testLabels(:,j),scores(:,2),1);
            AUCTempRF(j) = AUC;
        end

        precisionAll(4,:,i) = precisionTempRF;
        recallAll(4,:,i) = recallTempRF;
        f1All(4,:,i) = f1TempRF;
        AUCAll(4,:,i) = AUCTempRF;
    end

    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);

        %Downsample
        trainingData = data(cvIndices(:,i),:);
        trainingFeatures = trainingData(:,1:numFeatures);
        if normalizeFlag
            trainingMean = mean(trainingFeatures);
            trainingStd = std(trainingFeatures);
            trainingFeatures = bsxfun(@minus,trainingFeatures,trainingMean);
            trainingFeatures = bsxfun(@rdivide,trainingFeatures,trainingStd);
            trainingFeatures(isnan(trainingFeatures)) = 0;
            trainingFeatures(isinf(trainingFeatures)) = 0;
        end
        trainingLabels = trainingData(:,numFeatures+1:numFeatures+numLabels);

        testData = data(~cvIndices(:,i),:);
        testFeatures = testData(:,1:numFeatures);
        if normalizeFlag
            testFeatures = bsxfun(@minus,testFeatures,trainingMean);
            testFeatures = bsxfun(@rdivide,testFeatures,trainingStd);
            testFeatures(isnan(testFeatures)) = 0;
            testFeatures(isinf(testFeatures)) = 0;
        end
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);

        disp('Individual, Downsample');

        precisionTempRF = zeros(1,numLabels);
        recallTempRF = zeros(1,numLabels);
        f1TempRF = zeros(1,numLabels);
        AUCTempRF = zeros(1,numLabels);

        for j = 1:1:numLabels
            disp(['Label #' num2str(j)]);
            trainingLabels2 = trainingLabels(:,j);
            positive = find(trainingLabels2);
            negative = find(~trainingLabels2);
            numPositive = length(positive);
            numNegative = length(negative);
            downSample = min(numPositive,numNegative);
            trainingIndices = [positive(1:downSample); negative(1:downSample)];
            trainingLabels2 = trainingLabels2(trainingIndices,:);
            trainingFeatures2 = trainingFeatures(trainingIndices,:);

            %%RF:5
            model = TreeBagger(50,trainingFeatures2,trainingLabels2,'MinLeafSize',minLeaf,'InBagFraction',instanceSampling,'NumPredictorsToSample',max(1,round(featureSampling.*numFeatures)),'SplitCriterion','deviance','MergeLeaves','off','Prune','off','SampleWithReplacement','off');
            [predictions,scores] = predict(model,testFeatures);
            predictions = str2double(predictions);
            [precision,recall,f1] = get_statistics(testLabels(:,j),predictions);
            precisionTempRF(j) = precision;
            recallTempRF(j) = recall;
            f1TempRF(j) = f1;
            [~,~,~,AUC] = perfcurve(testLabels(:,j),scores(:,2),1);
            AUCTempRF(j) = AUC;
        end

        precisionAll(5,:,i) = precisionTempRF;
        recallAll(5,:,i) = recallTempRF;
        f1All(5,:,i) = f1TempRF;
        AUCAll(5,:,i) = AUCTempRF;
    end

    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);

        %ADASYN (SMOTE Extension)
        trainingData = data(cvIndices(:,i),:);
        trainingFeatures = trainingData(:,1:numFeatures);
        if normalizeFlag
            trainingMean = mean(trainingFeatures);
            trainingStd = std(trainingFeatures);
            trainingFeatures = bsxfun(@minus,trainingFeatures,trainingMean);
            trainingFeatures = bsxfun(@rdivide,trainingFeatures,trainingStd);
            trainingFeatures(isnan(trainingFeatures)) = 0;
            trainingFeatures(isinf(trainingFeatures)) = 0;
        end
        trainingLabels = trainingData(:,numFeatures+1:numFeatures+numLabels);

        testData = data(~cvIndices(:,i),:);
        testFeatures = testData(:,1:numFeatures);
        if normalizeFlag
            testFeatures = bsxfun(@minus,testFeatures,trainingMean);
            testFeatures = bsxfun(@rdivide,testFeatures,trainingStd);
            testFeatures(isnan(testFeatures)) = 0;
            testFeatures(isinf(testFeatures)) = 0;
        end
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);
        disp('Individual, ADASYN');

        precisionTempRF = zeros(1,numLabels);
        recallTempRF = zeros(1,numLabels);
        f1TempRF = zeros(1,numLabels);
        AUCTempRF = zeros(1,numLabels);

        for j = 1:1:numLabels
            disp(['Label #' num2str(j)]);
            trainingLabels2 = trainingLabels(:,j);
            [trainingFeatures3 trainingLabels3] = ADASYN(trainingFeatures, trainingLabels2, [], [], [], false);
            trainingFeatures2 = [trainingFeatures; trainingFeatures3];
            trainingLabels2 = [trainingLabels2; trainingLabels3];

            %%RF:6
            model = TreeBagger(50,trainingFeatures2,trainingLabels2,'MinLeafSize',minLeaf,'InBagFraction',instanceSampling,'NumPredictorsToSample',max(1,round(featureSampling.*numFeatures)),'SplitCriterion','deviance','MergeLeaves','off','Prune','off','SampleWithReplacement','off');
            [predictions,scores] = predict(model,testFeatures);
            predictions = str2double(predictions);
            [precision,recall,f1] = get_statistics(testLabels(:,j),predictions);
            precisionTempRF(j) = precision;
            recallTempRF(j) = recall;
            f1TempRF(j) = f1;
            [~,~,~,AUC] = perfcurve(testLabels(:,j),scores(:,2),1);
            AUCTempRF(j) = AUC;
        end

        precisionAll(6,:,i) = precisionTempRF;
        recallAll(6,:,i) = recallTempRF;
        f1All(6,:,i) = f1TempRF;
        AUCAll(6,:,i) = AUCTempRF;

    end

    cd(mulanPath);
    programName = 'MLKNNModel';
    compileString = ['javac -cp mulan.jar:weka-3.7.10.jar ' programName '.java'];
    system(compileString);
    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);

        %ML-KNN:7
        disp('MLKNN');
        testData = data(~cvIndices(:,i),:);
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);

        method = 'mlknn';
        runString = ['java -cp mulan.jar:weka-3.7.10.jar:. ' programName ' -arff "' dataFolder 'training_' num2str(i) '.arff" -xml "' dataFolder xmlLocation '" -unlabeled "' dataFolder 'test_' num2str(i) '.arff" -output "' dataFolder method '_' num2str(i) '.txt" -scores "' dataFolder method '_' num2str(i) '_scores.txt"'];
        system(runString);
        predictions = importdata([dataFolder method '_' num2str(i) '.txt']);
        scores = importdata([dataFolder method '_' num2str(i) '_scores.txt']);

        precisionTemp = zeros(1,numLabels);
        recallTemp = zeros(1,numLabels);
        f1Temp = zeros(1,numLabels);
        AUCTemp = zeros(1,numLabels);

        for j = 1:1:numLabels
            [precision,recall,f1] = get_statistics(testLabels(:,j),predictions(:,j));
            precisionTemp(j) = precision;
            recallTemp(j) = recall;
            f1Temp(j) = f1;
            [~,~,~,AUC] = perfcurve(testLabels(:,j),scores(:,j),1);
            AUCTemp(j) = AUC;
        end

        precisionAll(7,:,i) = precisionTemp;
        recallAll(7,:,i) = recallTemp;
        f1All(7,:,i) = f1Temp;
        AUCAll(7,:,i) = AUCTemp;
    end
    cd(currentPath);

    cd(mulanPath);
    programName = 'IBLRModel';
    compileString = ['javac -cp cocoa.jar:mulan.jar:weka-3.7.10.jar ' programName '.java'];
    system(compileString);
    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);
        %IBLR: 8
        disp('IBLR');
        testData = data(~cvIndices(:,i),:);
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);

        method = 'iblr';
        runString = ['java -cp cocoa.jar:mulan.jar:weka-3.7.10.jar:. ' programName ' -arff "' dataFolder 'training_' num2str(i) '.arff" -xml "' dataFolder xmlLocation '" -unlabeled "' dataFolder 'test_' num2str(i) '.arff" -output "' dataFolder method '_' num2str(i) '.txt" -scores "' dataFolder method '_' num2str(i) '_scores.txt"'];
        system(runString);
        predictions = importdata([dataFolder method '_' num2str(i) '.txt']);
        scores = importdata([dataFolder method '_' num2str(i) '_scores.txt']);

        precisionTemp = zeros(1,numLabels);
        recallTemp = zeros(1,numLabels);
        f1Temp = zeros(1,numLabels);
        AUCTemp = zeros(1,numLabels);

        for j = 1:1:numLabels
            [precision,recall,f1] = get_statistics(testLabels(:,j),predictions(:,j));
            precisionTemp(j) = precision;
            recallTemp(j) = recall;
            f1Temp(j) = f1;
            [~,~,~,AUC] = perfcurve(testLabels(:,j),scores(:,j),1);
            AUCTemp(j) = AUC;
        end

        precisionAll(8,:,i) = precisionTemp;
        recallAll(8,:,i) = recallTemp;
        f1All(8,:,i) = f1Temp;
        AUCAll(8,:,i) = AUCTemp;
    end
    cd(currentPath);

    cd(mulanPath);
    programName = 'ECCModel';
    compileString = ['javac -cp mulan.jar:weka-3.7.10.jar ' programName '.java'];
    system(compileString);
    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);
        %ECC:9
        disp('ECC');
        testData = data(~cvIndices(:,i),:);
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);

        method = 'ecc';
        runString = ['java -cp mulan.jar:weka-3.7.10.jar:. ' programName ' -arff "' dataFolder 'training_' num2str(i) '.arff" -xml "' dataFolder xmlLocation '" -unlabeled "' dataFolder 'test_' num2str(i) '.arff" -output "' dataFolder method '_' num2str(i) '.txt" -scores "' dataFolder method '_' num2str(i) '_scores.txt"'];
        system(runString);
        predictions = importdata([dataFolder method '_' num2str(i) '.txt']);
        scores = importdata([dataFolder method '_' num2str(i) '_scores.txt']);

        precisionTemp = zeros(1,numLabels);
        recallTemp = zeros(1,numLabels);
        f1Temp = zeros(1,numLabels);
        AUCTemp = zeros(1,numLabels);

        for j = 1:1:numLabels
            [precision,recall,f1] = get_statistics(testLabels(:,j),predictions(:,j));
            precisionTemp(j) = precision;
            recallTemp(j) = recall;
            f1Temp(j) = f1;
            [~,~,~,AUC] = perfcurve(testLabels(:,j),scores(:,j),1);
            AUCTemp(j) = AUC;
        end

        precisionAll(9,:,i) = precisionTemp;
        recallAll(9,:,i) = recallTemp;
        f1All(9,:,i) = f1Temp;
        AUCAll(9,:,i) = AUCTemp;
    end
    cd(currentPath);

    cd(mulanPath);
    programName = 'CLRModel';
    compileString = ['javac -cp mulan.jar:weka-3.7.10.jar ' programName '.java'];
    system(compileString);
    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);
        %CLR:10
        disp('CLR');
        testData = data(~cvIndices(:,i),:);
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);

        method = 'clr';
        runString = ['java -cp mulan.jar:weka-3.7.10.jar:. ' programName ' -arff "' dataFolder 'training_' num2str(i) '.arff" -xml "' dataFolder xmlLocation '" -unlabeled "' dataFolder 'test_' num2str(i) '.arff" -output "' dataFolder method '_' num2str(i) '.txt" -scores "' dataFolder method '_' num2str(i) '_scores.txt"'];
        system(runString);
        predictions = importdata([dataFolder method '_' num2str(i) '.txt']);
        scores = importdata([dataFolder method '_' num2str(i) '_scores.txt']);

        precisionTemp = zeros(1,numLabels);
        recallTemp = zeros(1,numLabels);
        f1Temp = zeros(1,numLabels);
        AUCTemp = zeros(1,numLabels);

        for j = 1:1:numLabels
            [precision,recall,f1] = get_statistics(testLabels(:,j),predictions(:,j));
            precisionTemp(j) = precision;
            recallTemp(j) = recall;
            f1Temp(j) = f1;
            [~,~,~,AUC] = perfcurve(testLabels(:,j),scores(:,j),1);
            AUCTemp(j) = AUC;
        end

        precisionAll(10,:,i) = precisionTemp;
        recallAll(10,:,i) = recallTemp;
        f1All(10,:,i) = f1Temp;
        AUCAll(10,:,i) = AUCTemp;
    end
    cd(currentPath);

    cd(mulanPath);
    programName = 'RAKELModel';
    compileString = ['javac -cp mulan.jar:weka-3.7.10.jar ' programName '.java'];
    system(compileString);
    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);
        %RAKEL:11
        disp('RAKEL');
        testData = data(~cvIndices(:,i),:);
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);

        method = 'rakel';
        runString = ['java -cp mulan.jar:weka-3.7.10.jar:. ' programName ' -arff "' dataFolder 'training_' num2str(i) '.arff" -xml "' dataFolder xmlLocation '" -unlabeled "' dataFolder 'test_' num2str(i) '.arff" -output "' dataFolder method '_' num2str(i) '.txt" -scores "' dataFolder method '_' num2str(i) '_scores.txt"'];
        system(runString);
        predictions = importdata([dataFolder method '_' num2str(i) '.txt']);
        scores = importdata([dataFolder method '_' num2str(i) '_scores.txt']);

        precisionTemp = zeros(1,numLabels);
        recallTemp = zeros(1,numLabels);
        f1Temp = zeros(1,numLabels);
        AUCTemp = zeros(1,numLabels);

        for j = 1:1:numLabels
            [precision,recall,f1] = get_statistics(testLabels(:,j),predictions(:,j));
            precisionTemp(j) = precision;
            recallTemp(j) = recall;
            f1Temp(j) = f1;
            [~,~,~,AUC] = perfcurve(testLabels(:,j),scores(:,j),1);
            AUCTemp(j) = AUC;
        end

        precisionAll(11,:,i) = precisionTemp;
        recallAll(11,:,i) = recallTemp;
        f1All(11,:,i) = f1Temp;
        AUCAll(11,:,i) = AUCTemp;
    end
    cd(currentPath);


    cd(mulanPath);
    programName = 'HOMERModel';
    compileString = ['javac -cp cocoa.jar:mulan.jar:weka-3.7.10.jar ' programName '.java'];
    system(compileString);
    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);
        %HOMER: 12
        disp('HOMER');
        testData = data(~cvIndices(:,i),:);
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);

        method = 'homer';
        runString = ['java -cp cocoa.jar:mulan.jar:weka-3.7.10.jar:. ' programName ' -arff "' dataFolder 'training_' num2str(i) '.arff" -xml "' dataFolder xmlLocation '" -unlabeled "' dataFolder 'test_' num2str(i) '.arff" -output "' dataFolder method '_' num2str(i) '.txt" -scores "' dataFolder method '_' num2str(i) '_scores.txt"'];
        system(runString);
        predictions = importdata([dataFolder method '_' num2str(i) '.txt']);
        scores = importdata([dataFolder method '_' num2str(i) '_scores.txt']);

        precisionTemp = zeros(1,numLabels);
        recallTemp = zeros(1,numLabels);
        f1Temp = zeros(1,numLabels);
        AUCTemp = zeros(1,numLabels);

        for j = 1:1:numLabels
            [precision,recall,f1] = get_statistics(testLabels(:,j),predictions(:,j));
            precisionTemp(j) = precision;
            recallTemp(j) = recall;
            f1Temp(j) = f1;
            [~,~,~,AUC] = perfcurve(testLabels(:,j),scores(:,j),1);
            AUCTemp(j) = AUC;
        end

        precisionAll(12,:,i) = precisionTemp;
        recallAll(12,:,i) = recallTemp;
        f1All(12,:,i) = f1Temp;
        AUCAll(12,:,i) = AUCTemp;
    end
    cd(currentPath);

    cd(mulanPath);
    programName = 'COCOAModel';
    compileString = ['javac -cp cocoa.jar:mulan.jar:weka-3.7.10.jar ' programName '.java'];
    system(compileString);
    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);
        %COCOA:13
        disp('COCOA');
        testData = data(~cvIndices(:,i),:);
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);

        method = 'cocoa';
        runString = ['java -cp cocoa.jar:mulan.jar:weka-3.7.10.jar:. ' programName ' -arff "' dataFolder 'training_' num2str(i) '.arff" -xml "' dataFolder xmlLocation '" -unlabeled "' dataFolder 'test_' num2str(i) '.arff" -output "' dataFolder method '_' num2str(i) '.txt" -scores "' dataFolder method '_' num2str(i) '_scores.txt" -numTrees "' num2str(numTreesCOCOA) '"'];
        system(runString);
        predictions = importdata([dataFolder method '_' num2str(i) '.txt']);
        scores = importdata([dataFolder method '_' num2str(i) '_scores.txt']);

        precisionTemp = zeros(1,numLabels);
        recallTemp = zeros(1,numLabels);
        f1Temp = zeros(1,numLabels);
        AUCTemp = zeros(1,numLabels);

        for j = 1:1:numLabels
            [precision,recall,f1] = get_statistics(testLabels(:,j),predictions(:,j));
            precisionTemp(j) = precision;
            recallTemp(j) = recall;
            f1Temp(j) = f1;
            [~,~,~,AUC] = perfcurve(testLabels(:,j),scores(:,j),1);
            AUCTemp(j) = AUC;
        end

        precisionAll(13,:,i) = precisionTemp;
        recallAll(13,:,i) = recallTemp;
        f1All(13,:,i) = f1Temp;
        AUCAll(13,:,i) = AUCTemp;
    end
    cd(currentPath);
end

if runFlag ~= 2
    %SF-50:14
    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);
        
        trainingData = data(cvIndices(:,i),:);
        trainingFeatures = trainingData(:,1:numFeatures);
        if normalizeFlag
            trainingMean = mean(trainingFeatures);
            trainingStd = std(trainingFeatures);
            trainingFeatures = bsxfun(@minus,trainingFeatures,trainingMean);
            trainingFeatures = bsxfun(@rdivide,trainingFeatures,trainingStd);
            trainingFeatures(isnan(trainingFeatures)) = 0;
            trainingFeatures(isinf(trainingFeatures)) = 0;
        end
        trainingLabels = trainingData(:,numFeatures+1:numFeatures+numLabels);
        
        testData = data(~cvIndices(:,i),:);
        testFeatures = testData(:,1:numFeatures);
        if normalizeFlag
            testFeatures = bsxfun(@minus,testFeatures,trainingMean);
            testFeatures = bsxfun(@rdivide,testFeatures,trainingStd);
            testFeatures(isnan(testFeatures)) = 0;
            testFeatures(isinf(testFeatures)) = 0;
        end
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);
        
        [precisionTemp,recallTemp,f1Temp,AUCTemp] = construct_and_test_forest_sf(trainingFeatures,trainingLabels,testFeatures,testLabels,50,minLeaf,labelSampling,featureSampling,instanceSampling,usedWeightParam);
        
        precisionAll(14,:,i) = precisionTemp;
        recallAll(14,:,i) = recallTemp;
        f1All(14,:,i) = f1Temp;
        AUCAll(14,:,i) = AUCTemp;
    end
    
    %SF-50-Oblique-LogisticRegression:15
    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);
        
        trainingData = data(cvIndices(:,i),:);
        trainingFeatures = trainingData(:,1:numFeatures);
        if normalizeFlag
            trainingMean = mean(trainingFeatures);
            trainingStd = std(trainingFeatures);
            trainingFeatures = bsxfun(@minus,trainingFeatures,trainingMean);
            trainingFeatures = bsxfun(@rdivide,trainingFeatures,trainingStd);
            trainingFeatures(isnan(trainingFeatures)) = 0;
            trainingFeatures(isinf(trainingFeatures)) = 0;
        end
        trainingLabels = trainingData(:,numFeatures+1:numFeatures+numLabels);
        
        testData = data(~cvIndices(:,i),:);
        testFeatures = testData(:,1:numFeatures);
        if normalizeFlag
            testFeatures = bsxfun(@minus,testFeatures,trainingMean);
            testFeatures = bsxfun(@rdivide,testFeatures,trainingStd);
            testFeatures(isnan(testFeatures)) = 0;
            testFeatures(isinf(testFeatures)) = 0;
        end
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);
        
        [precisionTemp,recallTemp,f1Temp,AUCTemp] = construct_and_test_forest_o_lr(trainingFeatures,trainingLabels,testFeatures,testLabels,50,minLeaf,tradeoff,marginParam,maxIters,labelSampling,featureSampling,instanceSampling,usedWeightParam);
        
        precisionAll(15,:,i) = precisionTemp;
        recallAll(15,:,i) = recallTemp;
        f1All(15,:,i) = f1Temp;
        AUCAll(15,:,i) = AUCTemp;
    end
    
    %SF-50-Oblique-LogisticRegression-CostSensitive:16
    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);
        
        trainingData = data(cvIndices(:,i),:);
        trainingFeatures = trainingData(:,1:numFeatures);
        if normalizeFlag
            trainingMean = mean(trainingFeatures);
            trainingStd = std(trainingFeatures);
            trainingFeatures = bsxfun(@minus,trainingFeatures,trainingMean);
            trainingFeatures = bsxfun(@rdivide,trainingFeatures,trainingStd);
            trainingFeatures(isnan(trainingFeatures)) = 0;
            trainingFeatures(isinf(trainingFeatures)) = 0;
        end
        trainingLabels = trainingData(:,numFeatures+1:numFeatures+numLabels);
        
        testData = data(~cvIndices(:,i),:);
        testFeatures = testData(:,1:numFeatures);
        if normalizeFlag
            testFeatures = bsxfun(@minus,testFeatures,trainingMean);
            testFeatures = bsxfun(@rdivide,testFeatures,trainingStd);
            testFeatures(isnan(testFeatures)) = 0;
            testFeatures(isinf(testFeatures)) = 0;
        end
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);
        
        [precisionTemp,recallTemp,f1Temp,AUCTemp] = construct_and_test_forest_o_lr_cs(trainingFeatures,trainingLabels,testFeatures,testLabels,50,minLeaf,tradeoff,marginParam,maxIters,labelSampling,featureSampling,instanceSampling,usedWeightParam);
        
        precisionAll(16,:,i) = precisionTemp;
        recallAll(16,:,i) = recallTemp;
        f1All(16,:,i) = f1Temp;
        AUCAll(16,:,i) = AUCTemp;
    end
    
    %SF-50-Oblique-Hellinger:17
    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);
        
        trainingData = data(cvIndices(:,i),:);
        trainingFeatures = trainingData(:,1:numFeatures);
        if normalizeFlag
            trainingMean = mean(trainingFeatures);
            trainingStd = std(trainingFeatures);
            trainingFeatures = bsxfun(@minus,trainingFeatures,trainingMean);
            trainingFeatures = bsxfun(@rdivide,trainingFeatures,trainingStd);
            trainingFeatures(isnan(trainingFeatures)) = 0;
            trainingFeatures(isinf(trainingFeatures)) = 0;
        end
        trainingLabels = trainingData(:,numFeatures+1:numFeatures+numLabels);
        
        testData = data(~cvIndices(:,i),:);
        testFeatures = testData(:,1:numFeatures);
        if normalizeFlag
            testFeatures = bsxfun(@minus,testFeatures,trainingMean);
            testFeatures = bsxfun(@rdivide,testFeatures,trainingStd);
            testFeatures(isnan(testFeatures)) = 0;
            testFeatures(isinf(testFeatures)) = 0;
        end
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);
        
        [precisionTemp,recallTemp,f1Temp,AUCTemp] = construct_and_test_forest_o(trainingFeatures,trainingLabels,testFeatures,testLabels,50,minLeaf,tradeoff,marginParam,maxIters,labelSampling,featureSampling,instanceSampling,usedWeightParam);
        
        precisionAll(17,:,i) = precisionTemp;
        recallAll(17,:,i) = recallTemp;
        f1All(17,:,i) = f1Temp;
        AUCAll(17,:,i) = AUCTemp;
    end
end

if runFlag ~= 3
    parfor i = 1:1:numSplits
        disp(['Split #' num2str(i)]);
        
        %SOSHF:18
        trainingData = data(cvIndices(:,i),:);
        trainingFeatures = trainingData(:,1:numFeatures);
        if normalizeFlag
            trainingMean = mean(trainingFeatures);
            trainingStd = std(trainingFeatures);
            trainingFeatures = bsxfun(@minus,trainingFeatures,trainingMean);
            trainingFeatures = bsxfun(@rdivide,trainingFeatures,trainingStd);
            trainingFeatures(isnan(trainingFeatures)) = 0;
            trainingFeatures(isinf(trainingFeatures)) = 0;
        end
        trainingLabels = trainingData(:,numFeatures+1:numFeatures+numLabels);
        
        testData = data(~cvIndices(:,i),:);
        testFeatures = testData(:,1:numFeatures);
        if normalizeFlag
            testFeatures = bsxfun(@minus,testFeatures,trainingMean);
            testFeatures = bsxfun(@rdivide,testFeatures,trainingStd);
            testFeatures(isnan(testFeatures)) = 0;
            testFeatures(isinf(testFeatures)) = 0;
        end
        testLabels = testData(:,numFeatures+1:numFeatures+numLabels);
        
        [precisionTemp,recallTemp,f1Temp,AUCTemp] = construct_and_test_forest(trainingFeatures,trainingLabels,testFeatures,testLabels,50,minLeaf,tradeoff,marginParam,maxIters,labelSampling,featureSampling,instanceSampling,usedWeightParam);
        
        precisionAll(18,:,i) = precisionTemp;
        recallAll(18,:,i) = recallTemp;
        f1All(18,:,i) = f1Temp;
        AUCAll(18,:,i) = AUCTemp;
    end
end

clc;

disp('OHF: f-measure');
comparisonValues = squeeze(f1All(18,:,:))';
for i = 1:1:18
    testVals = squeeze(f1All(i,:,:))';
    disp(['Method ' num2str(i) ' : ' methodNames{i} ', Mean 1: ' num2str(mean(mean(comparisonValues))) ', Mean 2: ' num2str(mean(mean(testVals)))]);
    disp(' ');
end
disp(' ');

disp('OHF: AUC');
comparisonValues = squeeze(AUCAll(18,:,:))';
for i = 1:1:18
    testVals = squeeze(AUCAll(i,:,:))';
    disp(['Method ' num2str(i) ' : ' methodNames{i} ', Mean 1: ' num2str(mean(mean(comparisonValues))) ', Mean 2: ' num2str(mean(mean(testVals)))]);
    disp(' ');
end
disp(' ');

end

