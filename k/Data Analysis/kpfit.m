function [data,delta]=kpfit(x,y,n)

% Produces a poly fit to the data
% Input: y = vector with plot to be fitted
%        x = x axis where the data happens
%        n = degree of polyfit
% Output: data = result polfit data

if nargin<3
    n=10;
end;
warning off
[p,S,mu] = polyfit(x,y,n);
[data,delta] = polyval(p,x,S,mu);
kpplot(x,data,y);
warning on
