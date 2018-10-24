classdef descZernike
    %DESCZERNIKE Descripteur de forme de Zernike
    %   Utilise les moments de Zernike :
    %   on convolue la forme avec chaque polynôme    
    
    properties (Constant = true) % variables statiques
        
        resolution = 256; % resolution en pixels des polynômes
        maxOrder = 10; % ordre maximal des polynômes
        % tableau contenant tous les polynômes de zernike
        polynoms = descZernike.getPolynoms();
        descSize = size(descZernike.polynoms,3); % nombre de valuers de moments
    end
    
    methods (Static = true)
        
        % retourne le polynôme de zernike d'ordres suivants :
        % n -> ordre radial
        % m -> order angulaire
        function polynom = getPolynom( m, n )

            w = descZernike.resolution;
            xvec = linspace(-1,1,w);
            xmat = repmat(xvec,[w,1]);
            ymat = repmat(xvec',[1,w]);
            rmat = sqrt(xmat.^2 + ymat.^2);
            thetamat = atan2(ymat,xmat);
            
            % TODO Question 2 :
            sumMax = (m-abs(n))/2;
            Rnm = 0;
            for k = 0:sumMax
               Rnm = Rnm + ((-1)^k)*(factorial(m-k)/(factorial(k)*(factorial(((m+abs(n))/2)-k))*(factorial(((m-abs(n))/2)-k))))*(rmat.^(m-2*k));
            end
            Znm = Rnm.*exp(1j*n*thetamat);
            Znm(find(rmat>1))=0;
            polynom = Znm;
            
        end
        
        % calcule tout un set de polynômes de Zernike
        function polynoms = getPolynoms()
           
            polynoms = descZernike.getPolynom(0,0);
            for m = 1:descZernike.maxOrder
                for n = m:-2:0
                   polynom = descZernike.getPolynom( m, n );
                   polynoms(:,:,end+1) = polynom;
                end
            end
        end
        
        % redimensionne et translate une forme sur le disque unitaire
        function dst = rescale(shape)
             
             shape = double(shape);
             
             h = size(shape,1);
             w = size(shape,2);
             
             % on calcule le centre de la forme
             yCoords = repmat(linspace(1,h,h)',[1 w]);
             xCoords = repmat(linspace(1,w,w),[h 1]);
             % barycentre
             yCenter = round(mean(mean(shape.*yCoords))/mean(mean(shape)));
             xCenter = round(mean(mean(shape.*xCoords))/mean(mean(shape)));
             
             % on calcule le rayon maximal de la forme
             xCoords = xCoords-xCenter; yCoords = yCoords-yCenter;
             rCoords = (xCoords.*xCoords + yCoords.*yCoords).^0.5;
             rValues = rCoords.*(shape./max(shape(:)));
             rMax = floor(max(rValues(:)));
             
             % on recentre et redimensionne la forme
             dst = shape( max(1,yCenter-rMax) : min(yCenter+rMax,h), ...
                 max(1,xCenter-rMax) : min(xCenter+rMax,w) );
             dst = imresize(dst,size(shape));
        end
    end
    
    properties
       values; % réponses aux polynômes de Zernike
    end
    
    methods
        
         % constructeur (à partir d'une image blanche sur noire)
         function dst = descZernike(shape)
             % TODO Question 2 :
             val=zeros(1,36);
             %Rescale avant multiplication: invariance aux translations et changement d'échelle
             resizedShape = dst.rescale(shape);
             for n=1:36
                val(n) = sum(sum(double(resizedShape).*double(descZernike.polynoms(:,:,n)),1),2);
             end
             % valeur absolue: invariance aux rotations
             dst.values = abs(val);
         end
         
        % distance entre deux descripteurs
        function d = distance(desc1, desc2)
            d = mean(abs(desc1.values - desc2.values));
        end
    end
end

