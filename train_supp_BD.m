function [train_samples] =  train_supp_BD(RD_hsi,im_2d,labels_supp,train_id )
% ��ÿѵ�����������򣨴��� wnd_sz��,ѡȡ����� K ����
% ������Щ��� Mean��Ȼ����ͶӰ�� Riemannian manifold
tol = 1e-3;
sz = size(RD_hsi);
d = sz(3);

train_samples = zeros(d, d,length(train_id ));
for i_tr =1:length(train_id)
    id = train_id(i_tr);
    idx_i1 = find(labels_supp == labels_supp(train_id(i_tr)));
    train_x = im_2d(:,id);
    X = im_2d(:,idx_i1);
    center_pixel = train_x/norm(train_x);
    tt_RD_DAT = X;
    norm_tmp = sqrt(sum(tt_RD_DAT.^2));
    norm_blocks_2d = tt_RD_DAT./repmat(norm_tmp,d,1);
    
    % ����center_pixel����ص� K ������
    cor = center_pixel'*norm_blocks_2d;
    [val,sort_id] = sort(cor,'descend');
    
    %     K = find(val > 0.998);
    %     if length(K) > N
    %         sli_id = sort_id(K);
    %     elseif size(X,2)>10
    %         K = ceil(0.5*size(X,2));
    %         sli_id = sort_id(1:K);
    %     else
    %         K = size(X,2);
    %         sli_id = sort_id(1:K);
    %     end
    
    if size(X,2)> 50
        K =  floor(0.5*size(X,2));
        
    else
        K = floor(0.9*size(X,2));
        
    end
    sli_id = sort_id(1:K);
    
    %     K = find(val > 0.998);
    %     if length(K) > N
    %         sli_id = sort_id(K);
    %     elseif size(X,2)>10
    %         K = ceil(0.5*size(X,2));
    %         sli_id = sort_id(1:K);
    %     else
    %         K = size(X,2);
    %         sli_id = sort_id(1:K);
    %     end
    
    tmp_mat = norm_blocks_2d(:,sli_id);
    % tmp_mat = tt_RD_DAT(:,sli_id);
    % tmp_mean = mean(tmp_mat,2);
    % supp_fea = tmp_mean;
    
    % X = tmp_mean;
    X = tmp_mat;
    
    tmp_mat = tt_RD_DAT(:,sli_id);
    
    a = pdist(tmp_mat);
    D = squareform(a);
    A = D - bsxfun(@plus,mean(D),mean(D,2))+mean(D(:));
    A2 = A.^2;
    Cv = mean(mean(A2));
    Rv2 = A2./Cv;
    
    tmp = Rv2;
    train_samples(:,:,i_tr) = logm(tmp+tol*eye(size(tmp,1))*(trace(tmp)));
end
end
