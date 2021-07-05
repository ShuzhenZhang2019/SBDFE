function [supp_fea] =  BDsim_suppixel(X)
% 计算superpixel 的 Brownian descriptor

tol = 1e-3;
d = size(X,1);
% X = im_2d(:,idx_i);
tt_RD_DAT = X;
norm_tmp = sqrt(sum(tt_RD_DAT.^2));
norm_blocks_2d = tt_RD_DAT./repmat(norm_tmp,d,1);

% 求超像素的平均值，找与平均值最相关的 K 个像素
% center_pixel = mean(X,2);
center_pixel = mean(norm_blocks_2d,2);
cor = center_pixel'*norm_blocks_2d;
[val,sort_id] = sort(cor,'descend');
%  K = find(val > 0.998);
% if length(K) > N   
%     sli_id = sort_id(K);
%  elseif size(X,2)>10 
%     K = ceil(0.5*size(X,2));
%     sli_id = sort_id(1:K);
%  else
%     K = size(X,2);
%     sli_id = sort_id(1:K);
%  end

if size(X,2)> 50
    K =  floor(0.5*size(X,2));
    
else
    K = floor(0.9*size(X,2));
    
end
sli_id = sort_id(1:K);

tmp_mat = tt_RD_DAT(:,sli_id);

a = pdist(tmp_mat);
D = squareform(a);
A = D - bsxfun(@plus,mean(D),mean(D,2))+mean(D(:));
A2 = A.^2;
Cv = mean(mean(A2));
 Rv2 = A2./Cv;            
            
tmp = Rv2;
supp_fea = logm(tmp+tol*eye(size(tmp,1))*(trace(tmp)));         

end
