function imap=kinterp(map,n1,m1)

%   imap=kinterp(map,n1,m1)
%   generates a intepolated version of map of x1 and y1 size
%   n1 can also define the number of times you are interping
%   if m1=n1, you dont need to enter m1.

if nargin<2, n1=2; end;
if nargin<3, m1=n1; end;

if nargin<3 && n1<5, 
    imap=interp2(map,n1,'spline');
else
    [n0 m0]=size(map);
    y=1:(n0-1)/(n1-1):n0;
    x=1:(m0-1)/(m1-1):m0;
    imap=interp2(map,x',y,'spline');
end;
