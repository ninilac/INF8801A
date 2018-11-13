% Fonction principale du TP sur le filtre bilat�ral

clc
clear all
close all

%% Denoising
% Il s'agit d'une simple application du filtre bilat�ral.

noise = rgb2hsv(imread('../data/taj-rgb-noise.jpg'));
figure;
imshow(noise(:,:,3)); title('Image originale (bruit�e)');


% TODO Question 1 :
%filtered = medfilt2(noise(:,:,3), [ 5 5 ], 'symmetric');
[width, height] = size(noise(:,:,3));
sigma_spatial = min( width, height ) / 64; % la division par 64 semble donner le r�sultat le plus beau.
sigma_range = 1; %sigma_range = (intensit�_max-intensit�_min)/nombre
filtered = bilateralFilter(noise(:,:,3), [], 0, 1, sigma_spatial, sigma_range/8);
figure;
imshow(filtered); title('Image filtr�e');

%% Tone mapping
% Il s'agit de compresser la plage d'intensit�es d'une image en pr�servant
% les d�tails. Pour cela, on diminue les contrastes globaux en conservant
% les contrastes locaux.

% lecture de l'image hdr (� partir de 3 expositions diff�rentes)
srcFolder = '../data/hdr/memorial/'; ext = '.png';
src = double(imread([srcFolder 'low' ext])) + double(imread([srcFolder 'mid' ext])) + double(imread([srcFolder 'high' ext]));

% normalisation
src = src - min(src(:));
src = src./max(src(:));
figure; imshow(src); title('Réduction uniforme linéaire')

% Filtrage avec filtres Gaussien et bilatéral (Question 2)
srchsv = rgb2hsv(src);
gaussian = imgaussfilt(srchsv(:,:,3), 20);
vgauss = srchsv(:,:,3) - gaussian;
vgauss = vgauss - min(vgauss(:));
vgauss = vgauss./max(vgauss(:));
srchsv(:,:,3) = vgauss;
gaussian_rgb = hsv2rgb(srchsv);
figure; imshow(gaussian_rgb); title('r�sultat avec gaussienne');

% avec bilat�ral
srchsv = rgb2hsv(src);
[width, height] = size(srchsv(:,:,3));
sigma_spatial = min( width, height ) / 4; % la division par 64 semble donner le r�sultat le plus beau.
sigma_range = 1; %sigma_range = (intensit�_max-intensit�_min)/nombre
filtered = bilateralFilter(srchsv(:,:,3), [], 0, 1, sigma_spatial, sigma_range/8);
vbilateral = srchsv(:,:,3) - filtered;
vbilateral = vbilateral - min(vbilateral(:));
vbilateral = vbilateral./max(vbilateral(:));
srchsv(:,:,3) = vbilateral;
gaussian_rgb = hsv2rgb(srchsv);
figure; imshow(gaussian_rgb); title('r�sultat avec filtre bilateral');

