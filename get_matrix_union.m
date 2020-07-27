function matrix = get_matrix_union(matrices, snaps_num)
N = size(matrices{1}, 1);
matrix = zeros(N,N);
for i = 1:snaps_num
    data = matrices{i};
    matrix = matrix + data;
end
matrix(matrix > 0) = 1;