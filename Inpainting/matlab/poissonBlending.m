function [ dst ] = poissonBlending( src, target, alpha )
%POISSONBLENDING Effectue un collage avec la méthode de Poisson
%   Remplit la zone de 'src' o� 'alpha'=0 avec le laplacien de 'target'

    % Le probl�me de Poisson s'�nonce par :
    % le laplacien de src est �gal � celui de target l� o� alpha=0'
    % Pour r�soudre ce probl�me, on utilise la m�thode de Jacobi :
    % � chaque it�ration, un pixel est �gal � la moyenne de ses voisins +
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
%         M�thode trop longue, ne pas utiliser.
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

