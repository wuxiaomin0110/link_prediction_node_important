function res = moving_average(data, step , N, num, format)
% step = 1: Random walk forecast
% step = num: Average forecast
stop = 100;
if strcmp(format, 'matrix')
    sim_sum = zeros(N, N);
    for i = num-step + 1:num
        sim_sum = sim_sum + data{i};
    end
    res = sim_sum./step;
elseif strcmp(format, 'vector')
    sim_sum = zeros(N,1);
    for i = num-step + 1:num
        sim_sum = sim_sum + data(:,i);
    end
    res = sim_sum./step;
elseif strcmp(format, 'weight_matrix')
    test_set = zeros(N*N ,num-1);
    for i=1:num-1
        matrix = data{i};
        vector = reshape(matrix, size(matrix,1)*size(matrix,2), 1);
        test_set(:,i) = vector;
    end
    matrix = data{num};
    vector = reshape(matrix, size(matrix,1)*size(matrix,2), 1);
    train_set = vector;
    train_set = center(train_set);
    test_set = normalize(test_set);
    
%     betas = (test_set'*test_set)\(test_set'*train_set);%least squares
   
%     lambda = 1e-6;
%     betas = (test_set'*test_set +lambda*eye(size(test_set,2)))\(test_set'*train_set);  %ridge
    betas = lasso(test_set, train_set,stop, false, false); 
    
    sim_sum = zeros(N, N);
    for i = 1:num-1
        sim_sum = sim_sum + betas(i)*data{i};
    end
        
    sim_sum = sim_sum + betas(num-1)*data{num};
    tmp = sum(betas) + betas(num-1);
    res = sim_sum./tmp;
end
