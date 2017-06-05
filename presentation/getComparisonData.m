function dataTable = getComparisonData(dataLoc)
load([dataLoc 'output.mat']);
dataTable = zeros(25,6);

for i = 1:1:25
    resultVals = squeeze(f1All(i,:,:))';
    resultVals = mean(resultVals,2);
    dataTable(i,1) = mean(resultVals);
    dataTable(i,3) = std(resultVals);
    
    comparisonValues = squeeze(f1All(24,:,:))';
    comparisonValues = mean(comparisonValues,2);
    %[~,p] = ttest2(resultVals(:),comparisonValues(:),'Vartype','unequal');
    p = signrank(resultVals(:),comparisonValues(:));
    if p <= 0.05
        if mean(comparisonValues) > mean(resultVals)
            dataTable(i,5) = 1;
        elseif mean(comparisonValues) < mean(resultVals)
            dataTable(i,5) = -1;
        end
    end
    
    resultVals = squeeze(AUCAll(i,:,:))';
    resultVals = mean(resultVals,2);
    dataTable(i,2) = mean(resultVals);
    dataTable(i,4) = std(resultVals);
    
    comparisonValues = squeeze(AUCAll(24,:,:))';
    comparisonValues = mean(comparisonValues,2);
    %[~,p] = ttest2(resultVals(:),comparisonValues(:),'Vartype','unequal');
    p = signrank(resultVals(:),comparisonValues(:));
    if p <= 0.05
        if mean(comparisonValues) > mean(resultVals)
            dataTable(i,6) = 1;
        elseif mean(comparisonValues) < mean(resultVals)
            dataTable(i,6) = -1;
        end
    end
    
end

end