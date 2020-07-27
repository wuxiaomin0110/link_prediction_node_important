%%  ����˵��    20181215  version1@lotus

%   aupr =pr_curve��Ԥ�����,ԭʼ��׼��,colour)

%   ����PR���ߺ�PR���������aupr

%   PR���ߣ�precison-recall curve��
function aupr =pr_curve(output,original)
    %% ����Ƿ��ѽ�������һ��
    output=output(:);
    original=original(:);
    %% ��Ԥ��������deci�������򣬱�׼��roc

    [threshold,ind] = sort(output,'descend');  %[��ֵ���±�]����Ԥ�������������
    roc_y = original(ind);    %����ֵԤ������Ӧ�ı�׼��
    %% ��x��recall�ĸ����㣬��y��precison�ĸ����㡣��PR���������aupr
    P=[1:length(roc_y)]';   %ʵ��������(TP+FP)��������Ԥ��Ϊ���ĸ�������Ϊ��ֵ���ǽ���������ֵ��Ӧ���±꼴��TP+FP��
    stack_x = cumsum(roc_y == 1)/sum(roc_y == 1); %x�᣺TPR=recall=TP/(TP+FN)=Ԥ��Ϊ��������/��������
    stack_y = cumsum(roc_y == 1)./P; %y�᣺precision=TP/(TP+FP)=Ԥ��Ϊ��������/����Ԥ��Ϊ��
    aupr=sum((stack_x(2:length(roc_y))-stack_x(1:length(roc_y)-1)).*stack_y(2:length(roc_y)));
%     aupr = trapz(stack_x(2:end),stack_y(2:end));
%     %PR���������\

    %% ��PR����

    % subplot(2,2,1);   %�ѻ�ͼ���ڷֳ����������Ŀ�����Ȼ����ÿ������ֱ���ͼ���ڵ�һ���ͼ
    %figure;
%     plot(stack_x,stack_y,colour);
%     xlabel('recall');
%     ylabel('precision');
end