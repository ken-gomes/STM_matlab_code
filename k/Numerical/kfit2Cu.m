function [vpCu, theta0, RMSE] = kfit2Cu(vp,ntheta,a)

% Adjusts lattice coordinates vp to fit Cu lattice, optimizing the angle.
% The lattice needs to centered at (0,0) which is a Cu site by default.
% Rotations are taken around (0,0) with increments of 60deg/ntheta.

if nargin < 3, a=2.547; end % Cu lattice spacing
if nargin < 2, ntheta=301; end % number of angles to search

% Determine image size based on vp
L = sqrt(max(vp(:,1).^2+vp(:,2).^2));
Nx = ceil(L/a) + 2;
Ny= ceil(Nx/sqrt(3));
% copper sites
cu = [];
for nj = -Ny:Ny
    for ni = -Nx:Nx
        v1 = [a*ni a*nj*sqrt(3)];
        v2 = v1 + a*[cos(pi/3) sin(pi/3)];
        cu = [cu; v1; v2];
    end
end

% do fitting for various angles to find minimum

theta = linspace(0, pi/3, ntheta); 
RMSE = zeros(ntheta, 1);
minErr = 10^10;
for nt = 1:ntheta,
    t = theta(nt); % for this value of theta
    M = [cos(t) -sin(t); sin(t) cos(t)]; % rotation matrix
    vp_rotated = (M*vp')'; % apply rotation to plan
    
    % calculate distance from co_plan to cu sites
    [X1, X2] = meshgrid(vp_rotated(:,1), cu(:,1));
    [Y1, Y2] = meshgrid(vp_rotated(:,2), cu(:,2));
    D = sqrt((X1 - X2).^2 + (Y1-Y2).^2);
    
    % calculate closest co site
    [allerror, cusites] = min(D);
    RMSE (nt) = norm(allerror);
    if RMSE(nt) < minErr,
        minErr = RMSE (nt);
        vpCu = cu(cusites,:);
        theta0 = t;
        vp_rotfinal = vp_rotated;
    end;
end;

% plot for various theta
figure;
plot(theta/pi*180, RMSE);
xlabel('\theta (degrees)');
xlim([0 60]);
ylabel('MSE');
title('Angular Error Dependence');

% plot result
figure;
title({['RMSE = ' num2str(minErr)];['angle = ' num2str(theta0/pi*180) ' degrees']});
% title(sprintf('RMSE = %1.2f', RMSEmin));
line(cu(:,1), cu(:,2),'linestyle','none','marker','.','color','k');
line(vp_rotfinal(:,1), vp_rotfinal(:,2),'linestyle','none','marker','x','color','r');
line(vpCu(:,1), vpCu(:,2),'linestyle','none','marker','o','color','b');
axis image

end