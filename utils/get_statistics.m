function [precision,recall,f1] = get_statistics(testLabels,predictions)

precision = sum(testLabels .* predictions) ./ sum(predictions);
if sum(predictions) == 0
    precision = 1;
end

recall = sum(testLabels .* predictions) ./ sum(testLabels);
if sum(testLabels) == 0
    recall = 1;
end

f1 = mean(2 .* (precision .* recall) ./ (precision + recall));
if precision + recall == 0
    f1 = 0;
end

end