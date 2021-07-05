% close all;clear all;clc
% img = imread('PCA_PaviaU2.tif');
img = imread('PCA.tif');
% img = imread('PCA_Wa_yuan.tif');
% img = imread('PCA_Sa.tif');

% BW = edge(img,'sobel',0.1); 
% BW = edge(img,'sobel'); 
% BW = edge(img,'log'); 
BW = edge(img,'canny',0.4); 
% [BW,thr] = edge(img,'sobel');
% [BW,thr]= edge(img,'log'); 
% [BW,thr] = edge(img,'canny'); 
% figure(1),imshow(img,[]);
figure(1),imshow(BW,[]);

index = find(BW~=0);
edgenum = length(index)
% [m,n] = size(img);
% ratio = length(index)/(m*n)
%       

% for i = 0:length(im_gt_1d)
%     idx_t1 = find(labels == i);
%     idx_t2 = find(im_gt_1d(idx_t1) ~= 0); 
%     idx_i = idx_t1(idx_t2);
%  if length(idx_i) ~=0 
%     total_i = length(idx_t1);
%     temp = BW(idx_t1);
%     ind_edg = find(temp~=0);
%     len = length(ind_edg);
%     Rat_i = len/total_i;
%     Rat = [Rat Rat_i];
%  else
%      Rat = [Rat 0];
%  end
% end