% function [train, test] = parse_dynamic_net(net_path)
close all
clear all
clc
net_path = 'E:\dynamic_network_evolving_link_prediction\dynamic_networks\ia-reality-call\ia-reality-call.txt';
net_info = dlmread(net_path);
all_node = [net_info(:,1); net_info(:,2)];
unique_node = unique(all_node);
new_node = zeros(1, length(unique_node));
for i = 1:length(unique_node)
    new_node(find(all_node == unique_node(i))) = i;
end
net_info(:,1) = new_node(1:length(all_node)/2);
net_info(:,2) = new_node(length(all_node)/2+1: end);

% method1: split the net into train and test by time
all_time = net_info(end, 3) - net_info(1,3);
train_sets = cell(1,9);
count = 1;
pre_line_num = 0;
N = 6809;
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



save_name = 'reality-call.mat';
save(save_name, 'train_sets', 'test_set', '-v7.3');
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


