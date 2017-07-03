% Done
function model = expect(X, model)
alpha = model.alpha; % Dirichlet
kappa = model.kappa;   % Gaussian
m = model.m;         % Gasusian
v = model.v;         % Whishart
U = model.U;         % Whishart 
logW = model.logW;
n = size(X,2);
[d,k] = size(m);

EQ = zeros(n,k);
for i = 1:k  
    x_m = bsxfun(@minus,X,m(:,i));
    Q = dot((x_m.'/U(:,:,i)).',x_m);
    EQ(:,i) = d/kappa(i)+v(i)*Q;    % 10.64
end
ElogLambda = sum(psi(0,0.5*bsxfun(@minus,v+1,(1:d)')),1)+d*log(2)+logW; % 10.65
Elogpi = psi(0,alpha)-psi(0,sum(alpha)); % 10.66
logRho = -0.5*bsxfun(@minus,EQ,ElogLambda-d*log(2*pi)); % 10.46
logRho = bsxfun(@plus,logRho,Elogpi);   % 10.46

% Different labled data should not be assigned into the same cluster
R =  exp(logRho);

R=R./repmat(sum(R,2),1,size(R,2)); % 10.49
model.logR = log(R);
model.R = R;
