function  [mu_new, sigma_new] = get_mix_para(model)

[C,ia,ic] = unique(model.m(1,:));
mu = model.m(:,ia);
sigma = model.U(:,:,ia);

% We should remove the unused components
n = size(mu);
n = n(end);
e=1e-2;
ind = [];
for i = 1:n-1
    for j = i+1:n
        if mode(abs(mu(:,i)-mu(:,j)))<e
            ind = [ind,i,j];
        end
    end
end

ind = unique(ind);

mu_new = mu;
sigma_new = sigma;
mu_new(:,ind) = [];
sigma_new(:,:,ind) = [];
            
