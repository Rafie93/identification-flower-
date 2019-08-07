%Create By Rafi'e
%Magiseter Ilmu Komputer Budi Luhur 2018
clc; clear; close all; warning off all;
tic
filename = 'data_training.xls';
DataSet = dataset('xlsfile', filename);
X = double(DataSet(:,1:10));
Y = double(DataSet(:,11));

Mdl = fitcnb(X,Y,...
    'DistributionNames', {'kernel'  'kernel'  'kernel'  'kernel'  'kernel'  'kernel'  'kernel' 'kernel' 'kernel' 'kernel'},...
    'ClassNames',[1 2 3 4]);


Mdl.DistributionParameters;
Mdl.DistributionParameters{1,4}

isLabels = resubPredict(Mdl);
ConfusionMatrix = confusionmat(Y,isLabels)

%C1 = Mdl.predict(X);
%cMat1 = confusionmat(Y,C1)
conf=sum(isLabels==Y)/length(isLabels);
disp(['Akurasi = ',num2str(conf*100),'%'])

%save model naivebayes
NaiveBayesFlower = compact(Mdl);
save NaiveBayesFlower.mat NaiveBayesFlower
%End save

toc