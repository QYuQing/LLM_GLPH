function similarities_N = neighborhood_Com(similar_m, kk)
mm = size(similar_m,1);

row_topk = maxk(similar_m, kk, 2);
row_th   = row_topk(:, kk);

col_topk = maxk(similar_m, kk, 1);
col_th   = col_topk(kk, :);

in_row_topk = (similar_m >= row_th);
in_col_topk = (similar_m >= col_th);

similarities_N = 0.5 * ones(mm);
both  =  in_row_topk &  in_col_topk;
none  = ~in_row_topk & ~in_col_topk;
similarities_N(both) = 1;
similarities_N(none) = 0;

similarities_N = (similarities_N + similarities_N.')/2;

% similarities_N(1:mm+1:end) = 1;
end
