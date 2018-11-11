% �˴�Ϊ�˱����Լ���⣬���γ��еķ��Ž������޸ģ���Ӧ����
% input -> a1
% hiddens -> z2
% hiddens_sigmoid -> a2
% output -> z3
% outpu_sigmoid -> a3 ���������

function [hiddens,hiddens_sigmoid,h_theta] = hTheta(X,Theta1,Theta2)
  m = size(X,1);  
  
  % ��ÿһ������ת�ó����򣬶�Ӧ�������ͼ�񣬱���˼��
  input = [ones(m,1) X];
  hiddens = Theta1 * input';
  hiddens_sigmoid = sigmoid(hiddens);
  
  output = Theta2 * [ones(1,m);hiddens_sigmoid];
  output_sigmoid = sigmoid(output);
  h_theta = output_sigmoid;
end