load('output/results.mat');

numMethods = length(methodNames);

columnOrdering = '| c || c | c || c | c || c | c || c | c |';
datasetHeader = '';
measurementHeader = 'Method Name';

%CAL500
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{CAL500}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];

%Emotions
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{Emotions}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];

%Medical
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{Medical}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];

%Enron
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c|}{Enron}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];

clc;

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
    printString = [methodNames{i}];
    for j = 1:1:4
        rankVal = find(dataTableFMeasureRank(:,j) == i);
        if rankVal == 1
            printString = [printString ' & ' sprintf('$\\textbf{%1.3f} \\pm \\textbf{%0.3f (%d)}$',dataTableFMeasureMean(i,j),dataTableFMeasureStd(i,j),rankVal)];
        else
            printString = [printString ' & ' sprintf('$%1.3f \\pm %0.3f (%d)$',dataTableFMeasureMean(i,j),dataTableFMeasureStd(i,j),rankVal)];
        end
        rankVal = find(dataTableAUCRank(:,j) == i);
        if rankVal == 1
            printString = [printString ' & ' sprintf('$\\textbf{%1.3f} \\pm \\textbf{%0.3f (%d)}$',dataTableAUCMean(i,j),dataTableAUCStd(i,j),rankVal)];
        else
            printString = [printString ' & ' sprintf('$%1.3f \\pm %0.3f (%d)$',dataTableAUCMean(i,j),dataTableAUCStd(i,j),rankVal)];
        end
    end
    disp([printString '\\']);
    disp('\hline');
end

datasetHeader = '';
measurementHeader = 'Method Name';

%Scene
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{Scene}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];

%Yeast
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{Yeast}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];

%Corel-5k
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{Corel5k}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];

% %RCV1-Subset1
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{RCV1: Subset1}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];

disp('\hline');
disp('\hline');
disp([datasetHeader '\\']);
disp('\hline');
disp([measurementHeader '\\']);
disp('\hline');
disp('\hline');

for i = 1:1:length(methodNames)
    printString = [methodNames{i}];
    for j = 5:1:8
        rankVal = find(dataTableFMeasureRank(:,j) == i);
        if rankVal == 1
            printString = [printString ' & ' sprintf('$\\textbf{%1.3f} \\pm \\textbf{%0.3f (%d)}$',dataTableFMeasureMean(i,j),dataTableFMeasureStd(i,j),rankVal)];
        else
            printString = [printString ' & ' sprintf('$%1.3f \\pm %0.3f (%d)$',dataTableFMeasureMean(i,j),dataTableFMeasureStd(i,j),rankVal)];
        end
        rankVal = find(dataTableAUCRank(:,j) == i);
        if rankVal == 1
            printString = [printString ' & ' sprintf('$\\textbf{%1.3f} \\pm \\textbf{%0.3f (%d)}$',dataTableAUCMean(i,j),dataTableAUCStd(i,j),rankVal)];
        else
            printString = [printString ' & ' sprintf('$%1.3f \\pm %0.3f (%d)$',dataTableAUCMean(i,j),dataTableAUCStd(i,j),rankVal)];
        end
    end
    disp([printString '\\']);
    disp('\hline');
end

datasetHeader = '';
measurementHeader = 'Method Name';

%RCV1-Subset2
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{RCV1: Subset2}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];

%TMC2007
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{TMC2007*}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];

%Mediamill
datasetHeader = [datasetHeader ' & \multicolumn{2}{|c||}{Mediamill*}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];

datasetHeader = [datasetHeader ' & \multicolumn{2}{|c|}{(Mean Rank) Significance}'];
measurementHeader = [measurementHeader ' & Macro-FMeasure & Macro-AUC'];

disp('\hline');
disp('\hline');
disp([datasetHeader '\\']);
disp('\hline');
disp([measurementHeader '\\']);
disp('\hline');
disp('\hline');

for i = 1:1:length(methodNames)
    printString = [methodNames{i}];
    for j = 9:1:11
        rankVal = find(dataTableFMeasureRank(:,j) == i);
        if rankVal == 1
            printString = [printString ' & ' sprintf('$\\textbf{%1.3f} \\pm \\textbf{%0.3f (%d)}$',dataTableFMeasureMean(i,j),dataTableFMeasureStd(i,j),rankVal)];
        else
            printString = [printString ' & ' sprintf('$%1.3f \\pm %0.3f (%d)$',dataTableFMeasureMean(i,j),dataTableFMeasureStd(i,j),rankVal)];
        end
        rankVal = find(dataTableAUCRank(:,j) == i);
        if rankVal == 1
            printString = [printString ' & ' sprintf('$\\textbf{%1.3f} \\pm \\textbf{%0.3f (%d)}$',dataTableAUCMean(i,j),dataTableAUCStd(i,j),rankVal)];
        else
            printString = [printString ' & ' sprintf('$%1.3f \\pm %0.3f (%d)$',dataTableAUCMean(i,j),dataTableAUCStd(i,j),rankVal)];
        end
    end
    printString = [printString sprintf(' & \\multicolumn{1}{r|}{$(%1.3f)$',meanRankFMeasure(i))];
    fMeasureSignificantString = '$';
    if significantFMeasure(i,1)
        fMeasureSignificantString = [fMeasureSignificantString ' \CIRCLE'];
    else
        fMeasureSignificantString = [fMeasureSignificantString ' \Circle'];
    end
    if significantFMeasure(i,2)
        fMeasureSignificantString = [fMeasureSignificantString ' \blacktriangle$}'];
    else
        fMeasureSignificantString = [fMeasureSignificantString ' \vartriangle$}'];
    end
    printString = [printString fMeasureSignificantString];
    printString = [printString sprintf(' & \\multicolumn{1}{r|}{$(%1.3f)$',meanRankAUC(i))];
    AUCSignificantString = '$';
    if significantAUC(i,1)
        AUCSignificantString = [AUCSignificantString ' \CIRCLE'];
    else
        AUCSignificantString = [AUCSignificantString ' \Circle'];
    end
    if significantAUC(i,2)
        AUCSignificantString = [AUCSignificantString ' \blacktriangle$}'];
    else
        AUCSignificantString = [AUCSignificantString ' \vartriangle$}'];
    end
    printString = [printString AUCSignificantString '\\'];
    
    disp(printString);
    disp('\hline');
end

disp('\end{tabular}');
disp('\end{adjustbox}');

disp('\caption{Macro-f-measure and macro-AUROC of classifiers on benchmark datasets. $\CIRCLE$ denotes SOSHF is statistically superior at $p = 0.05$ and $\Circle$ denotes no significant difference according to the Friedman test with the mean-ranks posthoc test with Bonferroni correction. $\blacktriangle$ denotes SOSHF is statistically superior at $p = 0.05$ and $\vartriangle$ denotes no significant difference according to the Friedman test with the Wilcoxon signed-rank posthoc test with Bonferroni correction. *COCOA run with ensemble size of 10 due to computational limitations}');
disp('\label{tab:results}');
disp('\end{table*}');
%disp('\end{landscape}');

% SOSHFfMeas = reshape(dataTable(24,1,:),[11,1]);
% COCOAfMeas = reshape(dataTable(19,1,:),[11,1]);
% SOSHFAUC = reshape(dataTable(24,2,:),[11,1]);
% COCOAAUC = reshape(dataTable(19,2,:),[11,1]);
%
% relDifffMeas = (SOSHFfMeas - COCOAfMeas) ./ COCOAfMeas;
% relDiffAUC = (SOSHFAUC - COCOAAUC) ./ COCOAAUC;
%
% min(relDifffMeas)
% max(relDifffMeas)
%
% min(relDiffAUC)
% max(relDiffAUC)
%
% mean(relDifffMeas)
% mean(relDiffAUC)