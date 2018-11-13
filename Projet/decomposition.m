clear all;
close all;

%% Load image

src = im2double(imread('dragon.jpg'));
srcSize = size(src(:,:,1));
R = src(:,:,1);
R = R(:);
V = src(:,:,2);
V = V(:);
B = src(:,:,3);
B = B(:);
[col, row]=size(R);
arrSize = col*row;
RVB = zeros(arrSize, 3);
RVB(:,1) = R;
RVB(:,2) = V;
RVB(:,3) = B;

%% get hull
hull = convhulln(RVB);
tri = delaunay(hull(:,1), hull(:,2));
figure;
scatter3(RVB(:,1),RVB(:,2),RVB(:,3));
figure;
trimesh(hull, RVB(:,1),RVB(:,2),RVB(:,3));

