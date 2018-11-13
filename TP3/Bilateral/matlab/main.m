% Fonction principale du TP sur le filtre bilatï¿½ral

clc
clear all
close all

%% Denoising
% Il s'agit d'une simple application du filtre bilatï¿½ral.

noise = rgb2hsv(imread('../data/taj-rgb-noise.jpg'));
figure;
imshow(noise(:,:,3)); title('Image originale (bruitï¿½e)');


% TODO Question 1 :
%filtered = medfilt2(noise(:,:,3), [ 5 5 ], 'symmetric');
[width, height] = size(noise(:,:,3));
sigma_spatial = min( width, height ) / 64; % la division par 64 semble donner le résultat le plus beau.
sigma_range = 1; %sigma_range = (intensité_max-intensité_min)/nombre
filtered = bilateralFilter(noise(:,:,3), [], 0, 1, sigma_spatial, sigma_range/8);
figure;
imshow(filtered); title('Image filtrï¿½e');

%% Tone mapping
% Il s'agit de compresser la plage d'intensitï¿½es d'une image en prï¿½servant
% les dï¿½tails. Pour cela, on diminue les contrastes globaux en conservant
% les contrastes locaux.

% lecture de l'image hdr (ï¿½ partir de 3 expositions diffï¿½rentes)
srcFolder = '../data/hdr/memorial/'; ext = '.png';
src = double(imread([srcFolder 'low' ext])) + double(imread([srcFolder 'mid' ext])) + double(imread([srcFolder 'high' ext]));

% normalisation
src = src - min(src(:));
src = src./max(src(:));
figure; imshow(src); title('RÃ©duction uniforme linÃ©aire')

% Filtrage avec filtres Gaussien et bilatÃ©ral (Question 2)
srchsv = rgb2hsv(src);
gaussian = imgaussfilt(srchsv(:,:,3), 20);
vgauss = srchsv(:,:,3) - gaussian;
vgauss = vgauss - min(vgauss(:));
vgauss = vgauss./max(vgauss(:));
srchsv(:,:,3) = vgauss;
gaussian_rgb = hsv2rgb(srchsv);
figure; imshow(gaussian_rgb); title('résultat avec gaussienne');

% avec bilatéral
srchsv = rgb2hsv(src);
[width, height] = size(srchsv(:,:,3));
sigma_spatial = min( width, height ) / 4; % la division par 64 semble donner le résultat le plus beau.
sigma_range = 1; %sigma_range = (intensité_max-intensité_min)/nombre
filtered = bilateralFilter(srchsv(:,:,3), [], 0, 1, sigma_spatial, sigma_range/8);
vbilateral = srchsv(:,:,3) - filtered;
vbilateral = vbilateral - min(vbilateral(:));
vbilateral = vbilateral./max(vbilateral(:));
srchsv(:,:,3) = vbilateral;
gaussian_rgb = hsv2rgb(srchsv);
figure; imshow(gaussian_rgb); title('résultat avec filtre bilateral');

