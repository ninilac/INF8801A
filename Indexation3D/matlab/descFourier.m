classdef descFourier
    %DESCFOURIER Descripteur de forme de Fourier
    %   calcule le contour de la forme, et retourne
    %   sa transform�e de Fourier normalis�e
    
    properties (Constant = true)
        nbPoints = 128; % nombre de points du contour
        descSize = 16; % fr�quences du spectre � conserver
    end
    
    properties
       values; % spectre du contour (taille 'nbFreq') 
    end
    
    methods
         % constructeur (� partir d'une image blanche sur noire)
         function dst = descFourier(shape)
            % Vous pouvez utiliser les fonctions matlab :
            % bwtraceboundary, interp1, etc..
            [row, col] = find(shape,1);
            boundary = bwtraceboundary(shape, [row, col], 'N');
            boundaryC = boundary(:,1) + 1j*boundary(:,2);
            % resampling: invariance aux transformations affines
            boundaryC128 = interp1(boundaryC, 1:size(boundaryC)/descFourier.nbPoints:size(boundaryC));
            fd = fft(boundaryC128);
            %valeur absolue: invariance aux rotations
            fdir = abs(fd);
            %normalisation par la 2e valeur: invariance � l'�chelle
            fdirs = fdir/fdir(2);
            %ignorer la premi�re valuer: invariance � la translation
            fdirst = fdirs(2:length(fdirs));
            % TODO Question 1 :
            dst.values = fdirst(1:descFourier.descSize);
            
         end
         
         % distance entre deux descripteurs
        function d = distance(desc1, desc2)
           
            d = mean(abs(desc1.values - desc2.values));
        end
    end
    
end

