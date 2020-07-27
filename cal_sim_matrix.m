function sim_matrix = cal_sim_matrix(scores, train_snaps_num)
sim_matrix = cell(1, train_snaps_num);
for k = 1:train_snaps_num
    score = scores(:, k);
    matrix = zeros(length(score),length(score));
    for i = 1:length(score)
        for j = i+1:length(score)
             matrix(i,j) = (score(i)*score(j));
        end
    end
    matrix = matrix + matrix';
    matrix(isnan(matrix)) = 0;
    sim_matrix{k} = matrix;
end
