% function [train, test] = parse_dynamic_net(net_path)
close all
clear all
clc
net_path = 'E:\dynamic_network_evolving_link_prediction\dynamic_networks\fb-forum\fb-forum.txt';
net_info = dlmread(net_path);

% method1: split the net into train and test by time
all_time = net_info(end, 3) - net_info(1,3);
train_sets = cell(1,9);
count = 1;
pre_line_num = 0;
N = 899;
start_time = net_info(1,3);
for i = 1:9
    end_time = net_info(pre_line_num+1, 3) + ceil(all_time * 0.1);
    temp = abs(end_time-net_info(:,3));
    [min_time, min_index] = min(temp);
    cur_line_num = min_index;
    train_set = net_info(pre_line_num + 1:cur_line_num, 1:2);
    train_set = transfer(train_set, N, 'train');
    train_sets{count} = train_set;
    count = count + 1;
    pre_line_num = cur_line_num;  
end
test_set = net_info(pre_line_num+1:end, 1:2);
test_set = transfer(test_set, N, 'test');

save_name = 'fb-forum.mat';
save(save_name, 'train_sets', 'test_set');
% 

% method2: split the net into train and test by data number
% data_len = size(net_info, 1);
% train_sets = cell(1,9);
% count = 1;
% pre_line_num = 0;
% N = 113;
% for rate = 0.1:0.1:0.9
%     train_len = ceil(data_len * rate);
%     cur_line_num = train_len;
%     train_set = net_info(pre_line_num + 1:cur_line_num, 1:2);
%     train_set = transfer(train_set, N);
%     train_sets{count} = train_set;
%     count = count + 1;
%     pre_line_num = cur_line_num;
% end
% test_set = net_info(pre_line_num + 1: end, 1:2);
% test_set = transfer(test_set, N);
% 
% save_name = 'hypertext_net.mat';
% save(save_name, 'train_sets', 'test_set');


