%//
%// MATLAB wrapper for Entropy Rate Superpixel Segmentation
%//
%// This software is used to demo the entropy rate superpixel
%// segmentation algorithm (ERS). The detailed of the algorithm can be
%// found in 
%//
%//      Ming-Yu Liu, Oncel Tuzel, Srikumar Ramalingam, Rama Chellappa,
%//      "Entropy Rate Superpixel Segmentation", CVPR2011.
%//
%// Copyright 2011, Ming-Yu Liu <mingyliu@umiacs.umd.edu>
%
 function labels=ERS_hsi1(img, nC)


% close all;clear all;clc
 grey_img = img;
 % figure(1),imshow(img);
 disp('Entropy Rate Superpixel Segmentation Demo');

%%
%//=======================================================================
%// Input
%//=======================================================================
%// These images are duplicated from the Berkeley segmentation dataset,
%// which can be access via the URL
%// http://www.eecs.berkeley.edu/Research/Projects/CS/vision/bsds/
%// We use them only for demonstration purposes.

%img = imread('C:\Users\apple\Desktop\indian_band1.tif');
%img = imread('242078.jpg');

%// Our implementation can take both color and grey scale images.
% grey_img = double(img);

 % grey_img = double(rgb2gray(img));

%%
%//=======================================================================
%// Superpixel segmentation
%//=======================================================================
%% // nC is the target number of superpixels.
% nC = round(size(grey_img,1)*size(grey_img,2)/20);
%// Call the mex function for superpixel segmentation\
%// !!! Note that the output label starts from 0 to nC-1.
%% 
t = cputime;

lambda_prime = 0.5;sigma = 5; 
conn8 = 1; % flag for using 8 connected grid graph (default setting).

[labels] = mex_ers(double(grey_img),nC);


%%
%//=======================================================================
%// Output
%//=======================================================================
[height width] = size(grey_img);
% 
% %// Compute the boundary map and superimpose it on the input image in the
% %// green channel.
% %// The seg2bmap function is directly duplicated from the Berkeley
% %// Segmentation dataset which can be accessed via
% %// http://www.eecs.berkeley.edu/Research/Projects/CS/vision/bsds/
 [bmap] = seg2bmap(labels,width,height);
 bmapOnImg = grey_img;
 idx = find(bmap>0);
 timg = grey_img;
 timg(idx) = 255;
 bmapOnImg(:,:,2) = timg;
 bmapOnImg(:,:,1) = grey_img;
 bmapOnImg(:,:,3) = grey_img;
% 
% %// Randomly color the superpixels
%  [out] = random_color( double(grey_img) ,labels,nC);
% 
% %// Compute the superpixel size histogram.
 siz = zeros(nC,1);
 for i=0:(nC-1)
     siz(i+1) = sum( labels(:)==i );
 end
 [his bins] = hist( siz, 20 );
 

 
