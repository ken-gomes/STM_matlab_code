function L = kloren(x, coef)
% returns the lorentzian function centered at x0 with full width half
% coef =[x0, w, a, y0]
% if desired, this can be scaled by a and offset vertically by y0
%
%
[nplot ncoef] = size (coef);
if ncoef<4, y0=repmat(0,nplot,1); else y0=coef(:,4); end;
if ncoef<3, a=repmat(1,nplot,1); else a=coef(:,3); end;
if ncoef<2, w=repmat(1,nplot,1); else w=coef(:,2); end;
x0=coef(:,1);
L=zeros(length(x),nplot);
for i=1:nplot
    L(:,i) = a(i)/pi * 0.5*w(i)./ ((x - x0(i)).^2 + (0.5 * w(i))^2) + y0(i);
end;
