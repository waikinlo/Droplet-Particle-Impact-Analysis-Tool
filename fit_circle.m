function [a,b,c] =  fit_circle(x,y)
% function fit_circle.m
% -------------------------------------------------------------------------
% circle fitting
% The circle is parameterized by the implicit equation:x^2+y^2+ax+by+c=0
% Define the objective function to be minimized as
% sum((x_i)^2+(y_i)^2+a(x_i)+b(y_i)+c),where i is an integer from 1 to n
% Compute the derivatives and rewrite the resulting equations in the linear form AX=B，where X=[a;b;c]
% Inputs:
%       Let x denote the x-coordinates of the points, stored as a (1000,1) column vector
%       Let y denote the y-coordinates of the points
% Output:
%       Let a,b,c denote the parameters in the circle equation.

% Construct A
A1_1 = sum(x.^2);
A1_2 = sum(x.*y);
A1_3 = sum(x);
A2_1 = A1_2;
A2_2 = sum(y.^2);
A2_3 = sum(y);
A3_1 = A1_3;
A3_2 = A2_3;
A3_3 = size(x,1);
A=[A1_1,A1_2,A1_3;
  A2_1,A2_2,A2_3;
  A3_1,A3_2,A3_3];

% Construct B
B1 = -sum(x.^3+(y.^2).*x);
B2 = -sum(y.^3+(x.^2).*y);
B3 = -sum(x.^2+y.^2);
B = [B1;B2;B3];

% Compute the result
X = A\B;
a=X(1);
b=X(2);
c=X(3);

end
