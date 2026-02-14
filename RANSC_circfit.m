function [p, r] = RANSC_circfit(x,y)


% RANSCA parameters
% Number of iterations
a=[x,y];
iter = 0;
% Check the size of the circle data
[m,n] = size(a);
% Error threshold
berr = 0.02;
% Fitting parameters
bfit = [];
% Number of inliers. This was previously set manually, but is determined automatically here
% Set the number of inliers to N/3 (i.e., 0.333 × N), where N is the total number of points
t = floor(m/1.1);
% Begin the iterative loop
while iter<100
    % Select three distinct points (without replacement)
    % Circle fitting requires at least three points, whereas line fitting requires at least two points
    % Let ran denote the index vector
    ran = randperm(m,3)';
    % Let b denote the points selected by the indices
    b = a(ran,:);
 
    % Compute the circle center and radius from the three selected points
    [r1,p1] = ThreePoint2Circle(b(1,1:2), b(2,1:2), b(3,1:2));
    % Select all other points excluding the three chosen points
    c = setdiff(a,b,"rows");
    % Compute the distance (dis) from each point to the circle center
    dis = sqrt(sum((c(:,1:2)-p1).^2,2));
    % Compute the error between dis and the fitted circle
    res = dis - r1;
    % Select points with errors below the threshold and classify them as inliers
    d = c(res<berr,:);
    len = length(d(:,1));
 
    % Check whether the number of inliers meets the criterion
    if len > t
        % If the criterion is satisfied, refit the circle using multiple points; here, the circle center is estimated using the mean
        p = mean(d);
        r = mean(sqrt(sum((d(:,1:2)-p(:,1:2)).^2,2)));
        % Compute the error of the multi-point fitted circle and compare it with the error from the circle fitted to the randomly selected points
        err = sqrt(sum((p-p1).^2))+sqrt((r-r1)^2);
        % If the error meets the stopping criterion, terminate the loop
        % Otherwise, continue iterating
        if err < berr
            bfit = [p,r];
            berr = err;
            break
        else
            iter = iter+1;
            continue
        end
    else
        iter = iter+1;
    end
    
end
 
end
function [R,P0] = ThreePoint2Circle(P1, P2, P3)
%% Estimate the circle center and radius; three points are sufficient to determine the center and radius
    x1 = P1(1);    x2 = P2(1);    x3 = P3(1);
    y1 = P1(2);    y2 = P2(2);    y3 = P3(2);
    z1 = x2^2 + y2^2 - x1^2 - y1^2;
    z2 = x3^2 + y3^2 - x1^2 - y1^2;
    z3 = x3^2 + y3^2 - x2^2 - y2^2;
    A = [(x2-x1), (y2-y1); (x3-x1), (y3-y1); (x3-x2), (y3-y2)];
    B = 0.5*[z1;  z2;  z3];
    P0 = (A'*A)\A'*B;
    R1 = sqrt( (P0(1) - P1(1))^2 + (P0(2) - P1(2))^2 );
    R2 = sqrt( (P0(1) - P2(1))^2 + (P0(2) - P2(2))^2 );
    R3 = sqrt( (P0(1) - P3(1))^2 + (P0(2) - P3(2))^2 );
    R = (R1 + R2 + R3)/3;
    P0 = P0';
end