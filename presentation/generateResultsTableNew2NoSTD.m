setup;

load('output/results.mat');

methodNames = lower(methodNames);

numMethods = length(methodNames);

columnOrdering = '| l || c | c | c | c | c | c | c | c | c | c | c | r |';
datasetHeader = '';

%CAL500
datasetHeader = [datasetHeader ' & CAL'];

%Emotions
datasetHeader = [datasetHeader ' & Emot'];

%Medical
datasetHeader = [datasetHeader ' & Med'];

%Enron
datasetHeader = [datasetHeader ' & Enron'];

%Scene
datasetHeader = [datasetHeader ' & Scene'];

%Yeast
datasetHeader = [datasetHeader ' & Yeast'];

%Corel-5k
datasetHeader = [datasetHeader ' & Corel'];

%RCV1-Subset1
datasetHeader = [datasetHeader ' & RCV1'];

%RCV1-Subset2
datasetHeader = [datasetHeader ' & RCV2'];

%TMC2007
datasetHeader = [datasetHeader ' & TMC*'];

%Mediamill
datasetHeader = [datasetHeader ' & Media*'];

datasetHeader = [datasetHeader ' & Summary'];

clc;

disp('\begin{table*}[h]');
disp('\small');
disp('\centering');
disp(['\begin{tabular}{ ' columnOrdering '| }']);
disp('\hline');
disp([datasetHeader '\\']);
disp('\hline');
disp('\hline');

for i = 1:1:length(methodNames)
    printString = [methodNames{i}];
    for j = 1:1:11
        rankVal = find(dataTableFMeasureRank(:,j) == i);
        if rankVal == 1
            printString = [printString ' & ' sprintf('$\\textbf{%1.3f}$',dataTableFMeasureMean(i,j))];
        else
            printString = [printString ' & ' sprintf('$%1.3f$',dataTableFMeasureMean(i,j))];
        end
    end
    printString = [printString sprintf(' & $(%1.1f)',meanRankFMeasure(i))];
    if significantFMeasure(i,1)
        printString = [printString ' \CIRCLE'];
    else
        printString = [printString ' \Circle'];
    end
    if significantFMeasure(i,2)
        printString = [printString ' \blacktriangle$ \\'];
    else
        printString = [printString ' \vartriangle$ \\'];
    end
    disp(printString);
    disp('\hline');
end

disp('\end{tabular}');

disp('\caption{Macro-f-measure of classifiers on benchmark datasets. $\CIRCLE$ denotes SOSHF is statistically superior at $p = 0.05$ and $\Circle$ denotes no significant difference according to the Friedman test with the mean-ranks posthoc test with Bonferroni correction. $\blacktriangle$ denotes SOSHF is statistically superior at $p = 0.05$ and $\vartriangle$ denotes no significant difference according to the Friedman test with the Wilcoxon signed-rank posthoc test with Bonferroni correction. *COCOA run with ensemble size of 10 due to computational limitations}');
disp('\label{tab:results}');
disp('\end{table*}');

disp(' ')
disp('\begin{table*}[h]');
disp('\small');
disp('\centering');
disp(['\begin{tabular}{ ' columnOrdering '| }']);
disp('\hline');
disp([datasetHeader '\\']);
disp('\hline');
disp('\hline');

for i = 1:1:length(methodNames)
    printString = [methodNames{i}];
    for j = 1:1:11
        rankVal = find(dataTableAUCRank(:,j) == i);
        if rankVal == 1
            printString = [printString ' & ' sprintf('$\\textbf{%1.3f}$',dataTableAUCMean(i,j))];
        else
            printString = [printString ' & ' sprintf('$%1.3f$',dataTableAUCMean(i,j))];
        end
    end
    printString = [printString sprintf(' & $(%1.1f)',meanRankAUC(i))];
    if significantAUC(i,1)
        printString = [printString ' \CIRCLE'];
    else
        printString = [printString ' \Circle'];
    end
    if significantAUC(i,2)
        printString = [printString ' \blacktriangle$ \\'];
    else
        printString = [printString ' \vartriangle$ \\'];
    end
    disp(printString);
    disp('\hline');
end

disp('\end{tabular}');

disp('\caption{Macro-f-measure of classifiers on benchmark datasets. $\CIRCLE$ denotes SOSHF is statistically superior at $p = 0.05$ and $\Circle$ denotes no significant difference according to the Friedman test with the mean-ranks posthoc test with Bonferroni correction. $\blacktriangle$ denotes SOSHF is statistically superior at $p = 0.05$ and $\vartriangle$ denotes no significant difference according to the Friedman test with the Wilcoxon signed-rank posthoc test with Bonferroni correction. *COCOA run with ensemble size of 10 due to computational limitations}');
disp('\label{tab:results}');
disp('\end{table*}');