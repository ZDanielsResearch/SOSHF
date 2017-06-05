clear all;
close all;
clc;

mainDir = [pwd '/'];

parsePath = [mainDir 'parse/'];
experimentsPath = [mainDir 'experiments/'];
utilsPath = [mainDir 'utils/'];
treePath = [mainDir 'tree/'];
presentationPath = [mainDir 'presentation/'];

miToolboxPath = '/home/zachary/Documents/Libraries/MIToolbox-2.1.2';

mulanPath = '/home/zachary/Documents/Libraries/mulan/';
SMOTEPath = '/home/zachary/Documents/Libraries/SMOTE/SMOTE';
mlknnPath = '/home/zachary/Documents/Libraries/multilabel/ML-kNN';
sfPath = [mainDir 'sf/'];
vlfeatPath = '/home/zachary/Documents/Libraries/vlfeat-0.9.20';

dataPath = '/media/zachary/DATADRIVE0/MLL/';

addpath(parsePath);
addpath(experimentsPath);
addpath(utilsPath);
addpath(treePath);
addpath(presentationPath);

addpath(miToolboxPath);

addpath(SMOTEPath);
addpath(mlknnPath);
addpath(mllbpPath);
addpath(mlnbPath);
addpath(sfPath);

%run([vlfeatPath '/toolbox/vl_setup']);

