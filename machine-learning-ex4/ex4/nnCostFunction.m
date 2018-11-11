function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);

% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% 
% ==== �˴�Ϊ�˱����Լ���⣬���γ��еķ��Ž������޸ģ���Ӧ����  ===
% hiddens -> z2
% hiddens_sigmoid -> a2
[hiddens,hiddens_sigmoid,h_theta] = hTheta(X,Theta1,Theta2);

% ��yת��ʮ����Ԫ�ľ���
y_label = zeros(num_labels,m);

for i = 1:m
  y_label(y(i),i) = 1;
end

% ������������ۺ�����������,
% TODO : ��ƫ����Ԫ��ȥ��
Theta1_remove_a0 = Theta1(:,2:end);
Theta2_remove_a0 = Theta2(:,2:end);
regu_item = lambda * (Theta1_remove_a0(:)' * Theta1_remove_a0(:)) / (2 * m) + lambda * (Theta2_remove_a0(:)' * Theta2_remove_a0(:)) / (2 * m);

% ������ۺ���������Ϊÿһ��Ԥ��ֵ��ʵ�ʱ�ǩ����һһ��Ӧ�ģ����Խ���չ������Ϊ���������������
J = sum(- log(h_theta(:)) .* y_label(:) - log(1 - h_theta(:)) .* (1 - y_label(:))) / m + regu_item;

% ����в�
error_output_unroll = h_theta(:) - y_label(:);
error_output = reshape(error_output_unroll,num_labels,m);
error_hidden = Theta2(:,2:end)' * error_output .* sigmoidGradient(hiddens);

% ����delta
delta_theta2 = zeros(num_labels,hidden_layer_size + 1);
delta_theta1 = zeros(hidden_layer_size,input_layer_size + 1);

% % �����ݶ�
% for i =  1:size(error_output,1)
%   delta_theta2(i,:) =  delta_theta2(i,:) + sum(error_output(i,:) .* [ones(1,1);hiddens_sigmoid],2);  % ��Theta2�ĵ�i�����ݶȵ�delta��һ�е�Ȩֵ�����������ز���Ԫ������error_output(i,:)��5000�У���5000�����ܵ�delta����ͬ
%   Theta2_grad(i,:) = delta_theta2(i,:) / m + lambda * [0 Theta2(i,2:end)] / m;
% end
% 
% for i = i:size(error_hidden,1) - 1 % ��bp��Ȩֵ�ĵ�deltaʱ���Ҳ���Ԫ������������input��hidden��weightʱ��hidden������Ԫ��Ҫ��ƫ����Ԫ�Ĳв�errotȥ�������� -1
%   delta_theta1(i,:) = delta_theta1(i,:) + sum(error_hidden(i,:) .* Theta1(i,:)); 
%   Theta1_grad(i,:) = delta_theta1(i,:) / m + lambda * [0 Theta1(i,2:end)] / m;
% end

% �����ݶ�
delta_theta2 = error_output * [ones(1,m);hiddens_sigmoid]';
delta_theta1 = error_hidden * [ones(1,m);X']';

Theta2_grad = delta_theta2 / m + lambda * [zeros(num_labels,1) Theta2(:,2:end)] / m;
Theta1_grad = delta_theta1 / m + lambda * [zeros(hidden_layer_size,1) Theta1(:,2:end)] / m;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients

grad = [Theta1_grad(:) ; Theta2_grad(:)];

end
