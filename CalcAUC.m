function [ auc, aupr, gmauc ] = CalcAUC( train, test, sim, n )
%% 计算AUC，输入计算的相似度矩阵   
    weight_test = triu(test);
    test(find(test>0))=1;
    all_edge = train + test;
    all_edge(all_edge > 0) = 1;
    non = 1 - all_edge - eye(max(size(train,1),size(train,2)));
    test = triu(test);
    non = triu(non);
    % 分别取测试集和不存在边集合的上三角矩阵，用以取出他们对应的相似度分值
    test_num = nnz(test);
    non_num = nnz(non);
    test_rd = ceil( test_num * rand( 1, n));  
    % ceil是取大于等于的最小整数，n为抽样比较的次数
    non_rd = ceil( non_num * rand( 1, n));
    test_pre = sim .* test;
    non_pre = sim .* non;
    test_data =  test_pre( test == 1 )';  
    % 行向量，test 集合存在的边的预测值
    non_data =  non_pre( non == 1 )';   
    % 行向量，nonexist集合存在的边的预测值
    test_rd = test_data( test_rd );
    non_rd = non_data( non_rd );
    n1 = length( find(test_rd > non_rd) );  
    n2 = length( find(test_rd == non_rd));
    auc = ( n1 + 0.5*n2 ) / n;
       
    all_num = test_num*2;
    gt = zeros(all_num, 1);
    gt(1:test_num,:) = 1;
    if n > test_num
        non_rd =non_rd;
    else
        non_rd = ceil( non_num * rand(1, test_num));
        non_rd = non_data( non_rd );
    end
    pred = [test_data, non_rd(1:test_num)];    
    aupr = pr_curve(pred,gt);

    %Calculate GMAUC
    %reference paper: Evaluating link prediction accuracy on dynamic
    %networks with added and removed edges
    % STEP1: calculate auc_pre
    test_prev_adj = weight_test;
    test_prev_adj(find(test_prev_adj < 2)) = 0;
    test_prev_adj(find(test_prev_adj == 2)) = 1;  
    test_prev_num = length(find(test_prev_adj == 1));
    test_prev_rd = ceil( test_prev_num * rand( 1, n)); 
    non_rd = ceil( non_num * rand( 1, n));
    test_prev_pre = sim .* test_prev_adj;
    test_prev_data =  test_prev_pre(test_prev_adj == 1)';
    test_prev_rd = test_prev_data( test_prev_rd );
    non_rd = non_data( non_rd );
    n1 = length( find(test_prev_rd > non_rd) );  
    n2 = length( find(test_prev_rd == non_rd));
    auc_prev = ( n1 + 0.5*n2 ) / n;
    
    % STEP2: calculate aupr_new
    test_new_adj = weight_test;
    test_new_adj(find(test_new_adj >1)) = 0;
    test_new_adj(find(test_new_adj == 1)) = 1;
    test_new_num = length(find(test_new_adj == 1));
    all_num = test_new_num*2;
    gt = zeros(all_num, 1);
    gt(1:test_new_num,:) = 1;
    if n > test_new_num
        non_rd =non_rd;
    else
        non_rd = ceil( non_num * rand(1, test_new_num));
        non_rd = non_data( non_rd );
    end
    test_new_pre = sim .* test_new_adj;
    test_new_data =  test_new_pre( test_new_adj == 1 )';  
    pred = [test_new_data, non_rd(1:test_new_num)];   
    aupr_new = pr_curve(pred,gt);
    
    % STEP3: calculate gmauc
    p_p_n = test_new_num/(test_new_num + non_num);
    gmauc = sqrt((aupr_new-p_p_n)/(1-p_p_n)*2*(auc_prev-0.5));
    
    clear test_data non_data;
end
