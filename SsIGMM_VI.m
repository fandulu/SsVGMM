function [label,label_merge,g, model, L] = SsIGMM_VI(X, Y, prior)
% Variational Bayesian inference for Gaussian mixture.
% Input: 
%   X: d x n data matrix
%   Y: 1 x n semi_label vector
%   m: k (1 x 1) or label (1 x n, 1<=label(i)<=k) or model structure
% Output:
%   label: 1 x n cluster label
%   model: trained model structure
%   L: variational lower bound
% Reference: Pattern Recognition and Machine Learning by Christopher M. Bishop (P.474)
% Modified by Fan Yang, base on Mo Chen's code.

fprintf('Variational Bayesian Gaussian mixture: running ... \n');

[d,n] = size(X);
if nargin < 3
    prior.alpha = 1;
    prior.kappa = 1;
    prior.m = mean(X,2);
    prior.v = d+1;
    prior.M = cov(X.')+eye(d)*eps;   % M = inv(W)
end

prior.logW = log(det(inv(prior.M)));

tol = 1e-8;
maxiter = 1000;
L = -inf(1,maxiter);

model = init(X,Y,prior);

semi_label = Y;
Label_ind = find(semi_label);

label = zeros(1,n);


if (sum(Label_ind)==0) % Unspervised learning
        for iter = 2:maxiter
        iter
        model = expect(X,model);
        model = maximize(X,model,prior);
        L(iter) = bound(X,model,prior)/n;
        if (abs(L(iter)-L(iter-1)) < tol*abs(L(iter))); break; end 
        end
else % Semi-supervised learning
    for iter = 2:maxiter
        iter
        model = expect_semi(X,model,semi_label,Label_ind);
        model = maximize(X,model,prior);
        L(iter) = bound(X,model,prior)/n;
        if (abs(L(iter)-L(iter-1)) < tol*abs(L(iter))); break; end
    end
end

L = L(2:iter);
label = zeros(1,n);
[~,label(:)] = max(model.R,[],2);% return maximum value of each row
[~,~,label(:)] = unique(label); % Remove the unsigned index

n_class = numel(unique(label));
label_merge = label;
n_semi_class = numel(unique(semi_label));
g = cell(1,n_semi_class+1); % The group of classes

if (sum(Label_ind)~=0)
    for i = 1:n_class
            l = unique(semi_label(label==i));
            if ( numel(unique(l))<=2) % Only contains 0 and one label
                l = max(l);
            else % Contains several labels 
                [~, b]=max(model.R(Label_ind,i)); % Find the max likelihood label among several labels
                l = semi_label(Label_ind(b));
            end
            label_merge(label==i)=l;
            if(l==0)
                g{n_semi_class+1} = [g{n_semi_class+1},i];
            else
                g{l}=[g{l},i];
            end
    end  
end    




