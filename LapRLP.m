function [LapA] = LapRLP(K_D_11,K_D_22,y, lambda1,lambda2,p_nearest_neighbor)

[num_1,num_2] = size(y);

L_D_11 = sparse_L(K_D_11,p_nearest_neighbor);
L_D_22 = sparse_L(K_D_22,p_nearest_neighbor);



AA = (lambda1*L_D_11 + eye(num_1));
BB = lambda2*L_D_22;
CC = y;

%Solve Sylvester equation AX + XB = C for X
LapA = sylvester(AA,BB,CC);
end

function [L_D_11] = sparse_L(K,p_nearest_neighbor)

%1.Sparsification of the similarity matrices
%1.1
[num_1,~] = size(K);
N_1 = neighborhood_Com(K,p_nearest_neighbor);
S_1 = N_1.*K;
d_1 = sum(S_1);
D_1 = diag(d_1);
L_D_1 = D_1 - S_1;
%Laplacian Regularized
d_tmep_1=eye(num_1)/(D_1^(1/2));
L_D_11 = d_tmep_1*L_D_1*d_tmep_1;

end
