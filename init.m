function model = init(X, Y, prior)
n = size(X,2);

k = max(unique(Y))+10*ceil(log(numel(Y)));
[label, ~] =  kmeanspp(X, k);

model.R = full(sparse(1:n,label,1,n,k,n));

model = maximize(X,model,prior);