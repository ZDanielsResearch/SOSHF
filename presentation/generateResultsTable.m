methodNames = {'BR:SVM-Cost','BR:SVM-Down','BR:SVM-ADASYN','BR:RF-10-Adjusted','BR:RF-10-Down','BR:RF-10-ADASYN','BR:RF-Adjusted','BR:RF-Down','BR:RF-ADASYN','BR:RF-100-Adjusted','BR:RF-100-Down','BR:RF-100-ADASYN','ML-KNN','IBLR','ECC','CLR','RAKEL','HOMER','COCOA','SF-10','SF','SF-100','SOSHF-10','SOSHF','SOSHF-100'};
numMethods = length(methodNames);

skip = [4,5,6,10,11,12,20,22,23,25];

% & \multicolumn{2}{|c||}{CAL500} & \multicolumn{2}{|c||}{Emotions} \\
%\hline

columnOrdering = '| c |';
datasetHeader = '';
measurementHeader = 'Method Name';

dataTable = [];%zeros(numMethods,8);

%CAL500
columnOrdering = [columnOrdering '| c | c'];
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{CAL500}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];
dataLoc = [dataPath 'CAL500/'];
expDataTable = getComparisonData(dataLoc);
dataTable = cat(3,dataTable,expDataTable);

%Emotions
columnOrdering = [columnOrdering '|| c | c'];
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{Emotions}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];
dataLoc = [dataPath 'emotions/'];
expDataTable = getComparisonData(dataLoc);
dataTable = cat(3,dataTable,expDataTable);

%Medical
columnOrdering = [columnOrdering '|| c | c'];
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{Medical}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];
dataLoc = [dataPath 'medical/'];
expDataTable = getComparisonData(dataLoc);
dataTable = cat(3,dataTable,expDataTable);

%Enron
columnOrdering = [columnOrdering '|| c | c'];
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c|}{Enron}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];
dataLoc = [dataPath 'enron/'];
expDataTable = getComparisonData(dataLoc);
dataTable = cat(3,dataTable,expDataTable);

meanRank = zeros(numMethods,2);
wlt = zeros(numMethods,3,2);

clc;

%disp('\begin{landscape}');
disp('\begin{table*}[h]');
disp('\centering');
disp('\begin{adjustbox}{width=\textwidth}')
disp(['\begin{tabular}{ ' columnOrdering '| }']);
disp('\hline');
disp([datasetHeader '\\']);
disp('\hline');
disp([measurementHeader '\\']);
disp('\hline');
disp('\hline');

for i = 1:1:length(methodNames)
    if ~ismember(i,skip)
        printString = [methodNames{i}];
        for j = 1:1:4%numExperiments
            dataForRank = dataTable(:,1,j);
            [~,rank] = sort(dataForRank,'descend');
            meanRank(i,1) = meanRank(i,1) + find(rank == i);
            if find(rank == i) == 1
                printString = [printString ' & ' sprintf('$\\textbf{%1.3f} \\pm \\textbf{%0.3f (%d)}',dataTable(i,1,j),dataTable(i,3,j),find(rank == i))];
            else
                printString = [printString ' & ' sprintf('$%1.3f \\pm %0.3f (%d)',dataTable(i,1,j),dataTable(i,3,j),find(rank == i))];
            end
            if dataTable(i,5,j) == 1
                printString = [printString ' \CIRCLE'];
                wlt(i,1,1) = wlt(i,1,1) + 1;
            elseif dataTable(i,5,j) == -1
                printString = [printString ' \Circle'];
                wlt(i,2,1) = wlt(i,2,1) + 1;
            else
                printString = [printString ' \LEFTcircle'];
                wlt(i,3,1) = wlt(i,3,1) + 1;
            end
            printString = [printString '$'];
            dataForRank = dataTable(:,2,j);
            [~,rank] = sort(dataForRank,'descend');
            meanRank(i,2) = meanRank(i,2) + find(rank == i);
            if find(rank == i) == 1
                printString = [printString ' & ' sprintf('$\\textbf{%1.3f} \\pm \\textbf{%0.3f (%d)}',dataTable(i,2,j),dataTable(i,4,j),find(rank == i))];
            else
                printString = [printString ' & ' sprintf('$%1.3f \\pm %0.3f (%d)',dataTable(i,2,j),dataTable(i,4,j),find(rank == i))];
            end
            if dataTable(i,6,j) == 1
                printString = [printString ' \CIRCLE'];
                wlt(i,1,2) = wlt(i,1,2) + 1;
            elseif dataTable(i,6,j) == -1
                printString = [printString ' \Circle'];
                wlt(i,2,2) = wlt(i,2,2) + 1;
            else
                printString = [printString ' \LEFTcircle'];
                wlt(i,3,2) = wlt(i,3,2) + 1;
            end
            printString = [printString '$'];
        end
        disp([printString '\\']);
        %meanRank = meanRank ./ numExperiments;
        %disp([printString sprintf(' & %1.3f & %1.3f \\\\',meanRank(i,1),meanRank(i,2))]);
        disp('\hline');
    end
end

columnOrdering = '| c |';
datasetHeader = '';
measurementHeader = 'Method Name';

%Scene
columnOrdering = [columnOrdering '| c | c'];
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{Scene}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];
dataLoc = [dataPath 'scene/'];
expDataTable = getComparisonData(dataLoc);
dataTable = cat(3,dataTable,expDataTable);

%Yeast
columnOrdering = [columnOrdering '|| c | c'];
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{Yeast}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];
dataLoc = [dataPath 'yeast/'];
expDataTable = getComparisonData(dataLoc);
dataTable = cat(3,dataTable,expDataTable);

%Corel-5k
columnOrdering = [columnOrdering '|| c | c'];
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{Corel5k}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];
dataLoc = [dataPath 'corel5k/'];
expDataTable = getComparisonData(dataLoc);
dataTable = cat(3,dataTable,expDataTable);

% %RCV1-Subset1
columnOrdering = [columnOrdering '|| c | c'];
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{RCV1: Subset1}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];
dataLoc = [dataPath 'rcvsubset1/'];
expDataTable = getComparisonData(dataLoc);
dataTable = cat(3,dataTable,expDataTable);

disp('\hline');
disp('\hline');
disp([datasetHeader '\\']);
disp('\hline');
disp([measurementHeader '\\']);
disp('\hline');
disp('\hline');

for i = 1:1:length(methodNames)
    if ~ismember(i,skip)
        printString = [methodNames{i}];
        for j = 5:1:8
            dataForRank = dataTable(:,1,j);
            [~,rank] = sort(dataForRank,'descend');
            meanRank(i,1) = meanRank(i,1) + find(rank == i);
            if find(rank == i) == 1
                printString = [printString ' & ' sprintf('$\\textbf{%1.3f} \\pm \\textbf{%0.3f (%d)}',dataTable(i,1,j),dataTable(i,3,j),find(rank == i))];
            else
                printString = [printString ' & ' sprintf('$%1.3f \\pm %0.3f (%d)',dataTable(i,1,j),dataTable(i,3,j),find(rank == i))];
            end
            if dataTable(i,5,j) == 1
                printString = [printString ' \CIRCLE'];
                wlt(i,1,1) = wlt(i,1,1) + 1;
            elseif dataTable(i,5,j) == -1
                printString = [printString ' \Circle'];
                wlt(i,2,1) = wlt(i,2,1) + 1;
            else
                printString = [printString ' \LEFTcircle'];
                wlt(i,3,1) = wlt(i,3,1) + 1;
            end
            printString = [printString '$'];
            dataForRank = dataTable(:,2,j);
            [~,rank] = sort(dataForRank,'descend');
            meanRank(i,2) = meanRank(i,2) + find(rank == i);
            if find(rank == i) == 1
                printString = [printString ' & ' sprintf('$\\textbf{%1.3f} \\pm \\textbf{%0.3f (%d)}',dataTable(i,2,j),dataTable(i,4,j),find(rank == i))];
            else
                printString = [printString ' & ' sprintf('$%1.3f \\pm %0.3f (%d)',dataTable(i,2,j),dataTable(i,4,j),find(rank == i))];
            end
            if dataTable(i,6,j) == 1
                printString = [printString ' \CIRCLE'];
                wlt(i,1,2) = wlt(i,1,2) + 1;
            elseif dataTable(i,6,j) == -1
                printString = [printString ' \Circle'];
                wlt(i,2,2) = wlt(i,2,2) + 1;
            else
                printString = [printString ' \LEFTcircle'];
                wlt(i,3,2) = wlt(i,3,2) + 1;
            end
            printString = [printString '$'];
        end
        disp([printString '\\']);
        %meanRank = meanRank ./ numExperiments;
        %disp([printString sprintf(' & %1.3f & %1.3f \\\\',meanRank(i,1),meanRank(i,2))]);
        disp('\hline');
    end
end

columnOrdering = '| c |';
datasetHeader = '';
measurementHeader = 'Method Name';

%RCV1-Subset2
columnOrdering = [columnOrdering '|| c | c'];
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{RCV1: Subset2}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];
dataLoc = [dataPath 'rcvsubset2/'];
expDataTable = getComparisonData(dataLoc);
dataTable = cat(3,dataTable,expDataTable);

%TMC2007
columnOrdering = [columnOrdering '|| c | c'];
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{TMC2007}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];
dataLoc = [dataPath 'tmc2007/'];
expDataTable = getComparisonData(dataLoc);
dataTable = cat(3,dataTable,expDataTable);

%Mediamill
columnOrdering = [columnOrdering '|| c | c'];
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{Mediamill}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];
dataLoc = [dataPath 'mediamill/'];
expDataTable = getComparisonData(dataLoc);
dataTable = cat(3,dataTable,expDataTable);

columnOrdering = [columnOrdering '|| c | c'];
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c|}{Wins/Losses/Ties (Mean Rank)}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];

disp('\hline');
disp('\hline');
disp([datasetHeader '\\']);
disp('\hline');
disp([measurementHeader '\\']);
disp('\hline');
disp('\hline');

for i = 1:1:length(methodNames)
    if ~ismember(i,skip)
        printString = [methodNames{i}];
        for j = 9:1:11
            dataForRank = dataTable(:,1,j);
            [~,rank] = sort(dataForRank,'descend');
            meanRank(i,1) = meanRank(i,1) + find(rank == i);
            if find(rank == i) == 1
                printString = [printString ' & ' sprintf('$\\textbf{%1.3f} \\pm \\textbf{%0.3f (%d)}',dataTable(i,1,j),dataTable(i,3,j),find(rank == i))];
            else
                printString = [printString ' & ' sprintf('$%1.3f \\pm %0.3f (%d)',dataTable(i,1,j),dataTable(i,3,j),find(rank == i))];
            end
            if dataTable(i,5,j) == 1
                printString = [printString ' \CIRCLE'];
                wlt(i,1,1) = wlt(i,1,1) + 1;
            elseif dataTable(i,5,j) == -1
                printString = [printString ' \Circle'];
                wlt(i,2,1) = wlt(i,2,1) + 1;
            else
                printString = [printString ' \LEFTcircle'];
                wlt(i,3,1) = wlt(i,3,1) + 1;
            end
            printString = [printString '$'];
            dataForRank = dataTable(:,2,j);
            [~,rank] = sort(dataForRank,'descend');
            meanRank(i,2) = meanRank(i,2) + find(rank == i);
            if find(rank == i) == 1
                printString = [printString ' & ' sprintf('$\\textbf{%1.3f} \\pm \\textbf{%0.3f (%d)}',dataTable(i,2,j),dataTable(i,4,j),find(rank == i))];
            else
                printString = [printString ' & ' sprintf('$%1.3f \\pm %0.3f (%d)',dataTable(i,2,j),dataTable(i,4,j),find(rank == i))];
            end
            if dataTable(i,6,j) == 1
                printString = [printString ' \CIRCLE'];
                wlt(i,1,2) = wlt(i,1,2) + 1;
            elseif dataTable(i,6,j) == -1
                printString = [printString ' \Circle'];
                wlt(i,2,2) = wlt(i,2,2) + 1;
            else
                printString = [printString ' \LEFTcircle'];
                wlt(i,3,2) = wlt(i,3,2) + 1;
            end
            printString = [printString '$'];
        end
        
        numExperiments = 8;
        disp([printString sprintf(' & %d/%d/%d (%1.3f) & %d/%d/%d (%1.3f) \\\\',wlt(i,1,1),wlt(i,2,1),wlt(i,3,1),meanRank(i,1)./ numExperiments,wlt(i,1,2),wlt(i,2,2),wlt(i,3,2),meanRank(i,2)./ numExperiments)]);
        disp('\hline');
    end
end

disp('\end{tabular}');
disp('\end{adjustbox}');

disp('\caption{Characteristics of the datasets used in our experiments}');
disp('\label{tab:results}');
disp('\end{table*}');
%disp('\end{landscape}');

SOSHFfMeas = reshape(dataTable(24,1,:),[11,1]);
COCOAfMeas = reshape(dataTable(19,1,:),[11,1]);
SOSHFAUC = reshape(dataTable(24,2,:),[11,1]);
COCOAAUC = reshape(dataTable(19,2,:),[11,1]);

relDifffMeas = (SOSHFfMeas - COCOAfMeas) ./ COCOAfMeas;
relDiffAUC = (SOSHFAUC - COCOAAUC) ./ COCOAAUC;

min(relDifffMeas)
max(relDifffMeas)

min(relDiffAUC)
max(relDiffAUC)

mean(relDifffMeas)
mean(relDiffAUC)