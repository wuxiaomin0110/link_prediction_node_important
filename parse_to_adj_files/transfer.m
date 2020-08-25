function A = transfer(data, N, set)
L = length(data);
A = zeros(N,N);
if strcmp(set, 'train')
    for i = 1:L
%         A(data(i,1),data(i,2)) = A(data(i,1),data(i,2)) + 1;
%         A(data(i,2),data(i,1)) = A(data(i,2),data(i,1)) + 1;
        A(data(i,1),data(i,2)) = 1;
        A(data(i,2),data(i,1)) = 1;
    end
else
    for i = 1:L
        A(data(i,1),data(i,2)) = 1;
        A(data(i,2),data(i,1)) = 1;
    end
end

for i = 1:N
    A(i,i) = 0;
end
