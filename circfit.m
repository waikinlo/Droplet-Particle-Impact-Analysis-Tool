function [xc, yc, R] = circfit(x,y,r)
% CIRCFIT: Fit a circle to a set of points
% Usage: [xc, yc, R] = circfit(x,y)
%        [xc, yc, R] = circfit(x,y,r)
%        [xc, yc, R] = circfit(xy)
%        [xc, yc, R] = circfit(xy,r)
%  x,y are column vectors containing the coordinates of the points
%  xy = [x y]
%  r is the radius of the circle (optional)
%  xc, yc are the coordinates of the center of the circle
%  R is the radius of the circle
%
% Author: Peter Bone (peterbone@ieee.org)
% Adapted from code by: Nikolai Chernov (nchernov@tulane.edu)
% Reference: http://www.spaceroots.org/documents/circle/circle-fitting.pdf

% Check the input arguments
if nargin == 1
    if size(x,2) == 2
        y = x(:,2);
        x = x(:,1);
    else
        error('Invalid input arguments');
    end
elseif nargin == 2
    if size(x,2) ~= 1 || size(y,2) ~= 1 || length(x) ~= length(y)
        error('Invalid input arguments');
    end
elseif nargin == 3
    if size(x,2) ~= 1 || size(y,2) ~= 1 || length(x) ~= length(y) || r <= 0
        error('Invalid input arguments');
    end
else
    error('Invalid input arguments');
end

% If r is not specified, use the average distance from the points to the centroid
if nargin == 2
    r = sqrt(mean((x-mean(x)).^2 + (y-mean(y)).^2));
end

% Fit the circle
xy = [x y];
a = xy(1,:);
b = xy(2,:);
c = xy(3,:);
ma = (b(2)-a(2))/(b(1)-a(1));
mb = (c(2)-b(2))/(c(1)-b(1));
xc = (ma*mb*(a(2)-c(2))+mb*(a(1)+b(1))-ma*(b(1)+c(1)))/(2*(mb-ma));
yc = -(1/ma)*(xc-(a(1)+b(1))/2)+(a(2)+b(2))/2;
R = r;

% If r is specified, adjust the center to lie on the circle
if nargin == 3
    d = sqrt((x-xc).^2 + (y-yc).^2);
    xc = xc + (r-mean(d))*(xc-mean(x))/mean(d);
    yc = yc + (r-mean(d))*(yc-mean(y))/mean(d);
end
end