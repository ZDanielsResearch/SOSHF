clc;

disp('\begin{table*}[h]');
disp('\centering');
%disp('\begin{adjustbox}{width=0.5\textwidth}')
disp('\begin{tabular}{ | c | c | c | c | c | c | c | c | c | c | }');
disp('\hline');
disp('Dataset & \textbar Instances\textbar  & \textbar Features\textbar  & \textbar Labels\textbar  & Feature Type & LD & PDL & Min IR & Max IR & Mean IR \\');
disp('\hline');
disp('\hline');

%CAL500
dataLoc = [dataPath 'CAL500/'];
printRowInfoCharacteristics(dataLoc,'CAL500');

%Emotions
dataLoc = [dataPath 'emotions/'];
printRowInfoCharacteristics(dataLoc,'Emotions');

%Medical
dataLoc = [dataPath 'medical/'];
printRowInfoCharacteristics(dataLoc,'Medical');

%Enron
dataLoc = [dataPath 'enron/'];
printRowInfoCharacteristics(dataLoc,'Enron');

%Scene
dataLoc = [dataPath 'scene/'];
printRowInfoCharacteristics(dataLoc,'Scene');

%Yeast
dataLoc = [dataPath 'yeast/'];
printRowInfoCharacteristics(dataLoc,'Yeast');

%Corel5k
dataLoc = [dataPath 'corel5k/'];
printRowInfoCharacteristics(dataLoc,'Corel5k');

%RCV1:Subset1
dataLoc = [dataPath 'rcvsubset1/'];
printRowInfoCharacteristics(dataLoc,'RCV1: Subset1');

%RCV1:Subset2
dataLoc = [dataPath 'rcvsubset2/'];
printRowInfoCharacteristics(dataLoc,'RCV1: Subset2');

%TMC2007
dataLoc = [dataPath 'tmc2007/'];
printRowInfoCharacteristics(dataLoc,'TMC2007');

%Mediamill
dataLoc = [dataPath 'mediamill/'];
printRowInfoCharacteristics(dataLoc,'Mediamill');

disp('\end{tabular}');
%disp('\end{adjustbox}');
disp('\caption{Characteristics of the datasets used in our experiments}');
disp('\label{tab:characteristics}');
disp('\end{table*}');