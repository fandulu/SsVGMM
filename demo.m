%% Variational Bayesian for Semi-supervised Gaussian Mixture Model
%% This code is develeped from Mo Chen's Variational Bayesian Gaussian Mixture Model, only for research purposes.
close all; clear;
load test.mat % Unlabel is represented by '0', while other categaries are intergers start from '1'. 
%% VB fitting
[label, label_merge,g,model, L] = SsIGMM_VI(training_data,training_label);
%% The indexs and parameters of each class
% The components index of each class, reference to the original labels. 
class_ind = g(~cellfun('isempty',g));
% The paramters respect to previous index
[mu_new,sigma_new]=get_mix_para(model);

figure(1)
plotClass(training_data,ture_label+1);
title('Ture Class')

figure(2)
plotClass(training_data,training_label+1);
title('Traning Data')

figure(3)
plotClass(training_data,label_merge+1);
title('SsVGMM prediction')

figure(4);
plot(L);
title('Lower bound')
