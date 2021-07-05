
clc
close all
clear;clc;
tic;

load('Indian_pines_corrected.mat')
im1 = indian_pines_corrected;
[i_row, i_col, i_band] = size(im1);
load('Indian_pines_gt.mat')
im_gt = indian_pines_gt;
im_gt_1d = reshape(im_gt,1,i_row*i_col);
no_classes = 16;

train_number = ones(1,no_classes)*10;

ratio = 0.65;
Band = ceil(i_band * ratio);
[RD_hsi]  = fun_MyMNF(im1, Band); % MNF code written by author.

sz = size(RD_hsi);
tmp_2d = reshape(RD_hsi,sz(1)*sz(2),sz(3));
im_2d = tmp_2d';


% 生成训练和测试样本
[train_SL,test_SL,test_number]= GenerateSample(im_gt,train_number,no_classes);
train_id = train_SL(1,:);
train_label = train_SL(2,:);
test_id = test_SL(1,:);
test_label = test_SL(2,:);

% pca image
% pca代码采用的路径是 addpath('E:\Program Files\MATLAB\R2018b\toolbox\stats\stats\pca.m');
band_num = 10;
im2 = reshape(im1,i_row*i_col,i_band);
im22 = im2;
chengfen=pca(im2);
img_pca=im22*chengfen(:,1:band_num);
img_pca=reshape(img_pca,[i_row i_col band_num]);
img_pca2=zeros(i_row,i_col);
img_pca2=img_pca(:,:,1);
img=uint8(255*mat2gray(img_pca2));

edge_num = edgenum(img);

%% 生成superpixel，提取 superpixel 特征
supnum = ceil(0.12 * edge_num); 
labels_supp = ERS_hsi1(img,supnum);

% trainning superpixel for classifier
train_cov =  train_supp_BD(RD_hsi,im_2d,labels_supp,train_id);
TrainSet.X= train_cov;
TrainSet.y =  train_label;

% test block
label_result = zeros(size(im_gt_1d));
for i = 0:1:max(max(labels_supp))
    idx_i = find(labels_supp == i);
    X = im_2d(:,idx_i);
    test_id2 = test_id;
    
    % superpixel Mean
    [supp_test] =  BDsim_suppixel(X);
 %  %  KSR classifier
    param = mySetParams();
    param.kernel = 'Log-E Gauss.' ;
    param.Beta = 1e-5;
    param.SR_Lambda = 1e-6;
    [training_kernel] = LogE_Kernels(TrainSet,TrainSet,param);
    
    test_cov = supp_test;
    TestSet.X = test_cov;
    TestSet.y = im_gt_1d(idx_i);
    predict_label = superpixel_KSR(TrainSet,TestSet,training_kernel,param);
    label_result(idx_i) = predict_label;
end
[OA,Kappa,AA,CA] = calcError(test_SL(2,:)'-1,label_result(test_id2)'-1,[1:no_classes]);
OA


