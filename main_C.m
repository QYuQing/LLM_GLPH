clear;
% Paths are relative to this script, independent of the current directory.
code_dir = fileparts(mfilename('fullpath'));
addpath(code_dir);
dataname = 'C';
data_dir = fullfile(code_dir, 'data', dataname);
load(fullfile(data_dir, [dataname 'dataset.mat']), 'y');
load(fullfile(data_dir, [dataname '_embeddings.mat']), ...
    'drug_embeddings', 'disease_embeddings');

drug_min = min(drug_embeddings, [], 1);
drug_max = max(drug_embeddings, [], 1);
drug_range = drug_max - drug_min;
drug_range(drug_range == 0) = 1;
drug_embeddings_01 = (drug_embeddings - drug_min) ./ drug_range;
dis_min = min(disease_embeddings, [], 1);
dis_max = max(disease_embeddings, [], 1);
dis_range = dis_max - dis_min;
dis_range(dis_range == 0) = 1;
disease_embeddings_01 = (disease_embeddings - dis_min) ./ dis_range;


nfolds = 10; nruns=10;

gamma = 0.5;
K1 = kernel_gip(drug_embeddings_01, 1, gamma);
gamma = 0.5;
K2 = kernel_gip(disease_embeddings_01, 1, gamma);

[n,m] = size(y);

run_fold_aupr = []; run_fold_auc = [];
seed = 2024;
for run=1:nruns 
    seed = seed + 1;
    cv_type = 'CV2'; %'CVD','CVP'
    [crossval_idx] = fun_cross_idx(n, m, nfolds, seed, cv_type);
    fold_aupr=[];fold_auc=[];
    for fold=1:nfolds
        
        %% split
        test_idx  = find(crossval_idx==fold);
        y_train = y;
        y_train(test_idx) = 0;
        
        %% WKNKN
        y_train = wknkn(y_train,K1,K2,20,0.7);
        lambda1 = 0.0625;
        lambda2 = 0.0625;
        p_nearest_neighbor = 20;
        [pre] = LapRLP(K1,K2,y_train, lambda1,lambda2,p_nearest_neighbor);
        %% evaluate predictions
        y_true = y(test_idx);
        y_pre = pre(test_idx);
        [~,~,~,aupr] = perfcurve(y_true,y_pre,1, 'xCrit', 'reca', 'yCrit', 'prec');
        [~,~,~,auc,~,~,~] = perfcurve(y_true,y_pre,1);
        fold_aupr=[fold_aupr;aupr];
        fold_auc=[fold_auc;auc];
        fprintf('Finish nfold: %d AUPR: %f AUC: %f \n', fold, aupr,auc)
    end
    mean_aupr = mean(fold_aupr); mean_auc = mean(fold_auc);
    fprintf('Finish AUPR: %f +/- %f AUC: %f +/- %f \n',  mean_aupr,std(fold_aupr),mean_auc,std(fold_auc))
    run_fold_aupr = [run_fold_aupr,mean_aupr];
    run_fold_auc = [run_fold_auc,mean_auc];
end
fprintf('Finish RUN AUPR: %f +/- %f AUC: %f +/- %f \n',  mean(run_fold_aupr),std(run_fold_aupr),mean(run_fold_auc),std(run_fold_auc))
