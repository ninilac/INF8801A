function [ dst ] = poissonBlending( src, target, alpha )
%POISSONBLENDING Effectue un collage avec la mÃ©thode de Poisson
%   Remplit la zone de 'src' où 'alpha'=0 avec le laplacien de 'target'

    % Le problème de Poisson s'énonce par :
    % le laplacien de src est égal à  celui de target là  où alpha=0'
    % Pour résoudre ce problème, on utilise la méthode de Jacobi :
    % à  chaque itération, un pixel est égal à  la moyenne de ses voisins +
    % la valeur du laplacien cible
    
    % TODO Question 2 :
    iterations = 10000;
    treshold = 0.5;
    alpha = double(repmat(alpha,[1,1,3]));
    alpha = alpha./max(alpha(:));
    alpha(alpha>treshold) = 1;
    alpha(alpha<=treshold) = 0;
    dst = double(src);
    laplacian = imfilter(double(target), [0 -1 0; -1 4 -1; 0 -1 0]);
    [row, col, color] = size(dst);
    newdst = zeros(row, col, color);
    h = waitbar(0);
    for k = 1:iterations
%         Méthode trop longue, ne pas utiliser.
%         for i = 2:row-1
%             for j = 2:col-1
%                 newdst(i,j,:) = (laplacian(i,j,:) + dst(i+1,j,:) + dst(i-1,j,:) +dst(i,j+1,:) +dst(i,j-1,:))/4;
%             end
%         end
        newdst = (imfilter(dst,[0,1,0;1,0,1;0,1,0]) + laplacian)/4;
        dst = double(src) .* alpha + newdst .* (1-alpha);
        waitbar(k/iterations,h);
    end
    close(h);
    dst = uint8(dst);
end

