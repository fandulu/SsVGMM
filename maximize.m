% Maximize likelihood
function model = maximize(X, model, prior)
alpha0 = prior.alpha;
kappa0 = prior.kappa;
m0 = prior.m;
v0 = prior.v;
M0 = prior.M;
R = model.R;

nk = sum(R,1); % PRML 10.51
alpha = alpha0+nk; % PRML 10.58
kappa = kappa0+nk; % 10.60
v = v0+nk; % 10.63
m = bsxfun(@plus,kappa0*m0,X*R);  % X is xk, R is Nk
m = bsxfun(@times,m,1./kappa); % 10.61

[~,k] = size(m);

logW = zeros(1,k);
r = sqrt(R');
for i = 1:k
    Xm = bsxfun(@minus,X,m(:,i));
    Xm = bsxfun(@times,Xm,r(i,:));
    m0m = m0-m(:,i);
    M = M0+Xm*Xm'+kappa0*(m0m*m0m');     % equivalent to 10.62
    logW(i) = log(det(inv(M)));
    U(:,:,i) = M;
     
end

model.alpha = alpha;
model.kappa = kappa;
model.m = m;
model.v = v;
model.U = U;
model.logW = logW;
