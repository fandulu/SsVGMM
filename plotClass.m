function plotClass(X, label)
% Plot 2d/3d samples of different classes with different colors.
% Developed from Mo Chen' code
[d,n] = size(X);
if nargin == 1
    label = ones(n,1);
end
assert(n == length(label));

color = 'brgmcyk';
m = length(color);
c = max(label);

figure(gcf);
clf;
hold on;
switch d
    case 2
        view(2);
        for i = 1:c
            idc = label==i;
            scatter(X(1,idc),X(2,idc),36,color(mod(i-1,m)+1));
        end
    case 3
        view(3);
        for i = 1:c
            idc = label==i;
            scatter3(X(1,idc),X(2,idc),X(3,idc),36,color(mod(i-1,m)+1));
        end
    otherwise
        error('ERROR: only support data of 2D or 3D.');
end
axis equal
grid on
hold off