clear all
close all
clc

dataname = strvcat('enron', 'hypertext_net','fb-forum', 'reality-call', 'wiki', 'fb-message');
datapath = '.\adj_files_new_test\';
numOfExperiment=10;
auc_n = 10000;

for ith_data = 1:6
    tempcont = strcat('���ڴ���� ', int2str(ith_data), '������...', dataname(ith_data,:));
    disp(tempcont);
    tic;
    load(strcat(datapath,dataname(ith_data,:),'-new-test.mat'));
    train_snaps_num = 9;
    union_train = get_matrix_union(train_sets, train_snaps_num);
    N = size(test_set, 1);
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    aucOfallPredictor = [];  
    auprOfallPredictor = [];% ���ڴ洢numOfExperiment��ʵ��Ľ������j�б�ʾ��j��
    TimeOfallPredictor = []; 
    gmaucOfallPredictor = []; 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %----- ��ʼʵ���ѭ��
    for ith_experiment = 1:numOfExperiment
        if mod(ith_experiment,1) == 0
            tempcont = strcat(int2str(ith_experiment),'%... ');
            disp(tempcont);
        end
        disp('________');
        disp(ith_experiment);
        ithAUCvector = [];
        ithAUPRvector = [];
        ithGMAUCvector = [];
        Predictors = [];    
        ithTime = [];                     % ���ڴ洢��ǰʵ��������Ԥ�����ľ���
        % Get the ranking scores for each train frame
        
        pr_scores = zeros(N,train_snaps_num);    
        disp('PR')
        tic
        for i = 1:train_snaps_num
            train_set = train_sets{i}; 
            pr_scores(:,i) = pageRank(train_set, 0.85, 1e-5);
        end
 
        pr_sim = cal_sim_matrix(pr_scores, train_snaps_num);
        for step=1
            pr_ma_pred = moving_average(pr_sim, step, N, train_snaps_num, 'weight_matrix');
            [tempauc, tempaupr, tempgmauc] = CalcAUC(union_train, test_set, pr_ma_pred, auc_n);toc
            ithAUCvector = [ithAUCvector tempauc];ithTime = [ithTime, toc];ithAUPRvector = [ithAUPRvector tempaupr];
            ithGMAUCvector = [ithGMAUCvector tempgmauc];
        end
        
        aucOfallPredictor = [aucOfallPredictor; ithAUCvector];
        TimeOfallPredictor = [TimeOfallPredictor; ithTime];
        auprOfallPredictor = [auprOfallPredictor; ithAUPRvector];
        gmaucOfallPredictor = [gmaucOfallPredictor; ithGMAUCvector];
        
    end
    avg_auc = mean(aucOfallPredictor,1); 
    avg_time = mean(TimeOfallPredictor,1);
    avg_aupr = mean(auprOfallPredictor, 1);
    avg_gmauc = mean(gmaucOfallPredictor,1);

    disp('auc:'); disp(avg_auc)
    disp('aupr:'); disp(avg_aupr)
    disp('gmauc:'); disp(avg_gmauc) 
end



