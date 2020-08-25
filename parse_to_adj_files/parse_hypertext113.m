% function [train, test] = parse_dynamic_net(net_path)
close all
clear all
clc
net_path = 'E:\dynamic_network_evolving_link_prediction\dynamic_networks\ia-contacts_hypertext2009\ia-contacts_hypertext2009.txt';
net_info = dlmread(net_path);

% method1: split the net into train and test by time
% all_time = net_info(end, 3);
% train_sets = cell(1,9);
% count = 1;
% pre_line_num = 0;
% N = 113;
% for rate = 0.1:0.1:0.9
%     train_time = ceil(all_time * rate);
%     while mod(train_time,20) ~= 0
%         train_time = train_time + 1;
%     end
%     line_num = find(net_info(:,3) == train_time);
%     cur_line_num = max(line_num);
%     train_set = net_info(pre_line_num + 1:cur_line_num, 1:2);
% %     train_set = transfer(train_set, N);
%     train_sets{count} = train_set;
%     count = count + 1;
%     pre_line_num = cur_line_num;
% end
% test_set = net_info(pre_line_num+1:end, 1:2);
% test_set = transfer(test_set, N);

% save_name = 'hypertext_net.mat';
% save(save_name, 'train_sets', 'test_set');
% 

% method2: split the net into train and test by data number
data_len = size(net_info, 1);
train_sets = cell(1,9);
count = 1;
pre_line_num = 0;
N = 113;
for rate = 0.1:0.1:0.9
    train_len = ceil(data_len * rate);
    cur_line_num = train_len;
    train_set = net_info(pre_line_num + 1:cur_line_num, 1:2);
    train_set = transfer(train_set, N, 'train');
    train_sets{count} = train_set;
    count = count + 1;
    pre_line_num = cur_line_num;
end
test_set = net_info(pre_line_num + 1: end, 1:2);
test_set = transfer(test_set, N, 'test');


save_name = 'hypertext_net.mat';
save(save_name, 'train_sets', 'test_set');


