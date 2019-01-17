function [C, Bopt, history] = ksubtract(A,B)
% Aligns A and B and finds the subtraction of the maps

cost = @(params)kcost(A,B,params);
[params_opt,history] = kminimizer2(cost,[0,0,1,1,0,0]);

Bopt = kdistort(B,params_opt);
C = A-Bopt;

    function cost = kcost(A,B,params)
        Bf = kdistort(B,params);        
        AB = A.*Bf;
        AA = A.*A;
        cost = -sum(AB(:))/sum(AA(:));
    end

    function Bf = kdistort(Bi,params)
        x0 = params(1)*100;
        y0 = params(2)*100;
        x1 = params(3);
        y1 = params(4);
        
        xi = 0:size(Bi,1)-1;
        yi = 0:size(Bi,2)-1;
        
        xf = x0+x1*xi;
        yf = y0+y1*yi;
        
        [Xi,Yi] = meshgrid(xi,yi);
        [Xf,Yf] = meshgrid(xf,yf);
        Bf = interp2(Xi,Yi,Bi,Xf,Yf,'cubic',0);
    end

    function [xmin, history] = kminimizer2(fun, xmin)
        
        num_iters = 50;
        alpha = 0.001;
        history = zeros(num_iters+1, 1);
        delta = 0.001;
        nx = length(xmin);
        grad = zeros(1,nx);
        history(1)=fun(xmin);
        
        for iter = 1:num_iters
            for ix = 1:nx
                xp = xmin;
                xm = xmin;
                xp(ix)=xp(ix)+delta;
                xm(ix)=xm(ix)-delta;
                grad(ix)=(fun(xp)-fun(xm))/2/delta;
            end
            xmin = xmin - alpha*grad;
            history(iter+1)=fun(xmin);
        end
        
    end

end