function [h,x]=khist(mtx,n,lim)

% [h,x]=khist(mtx,n,lim)
% Generates a histogram out of mtx datapoints
% Input: mtx = gapmap
%        n = number of bins in histogram
%        lim = max bias value to count to...   
% Outpot: h = histogram;
%             x = x-data for histogram plot;
%             it also outputs a plot.

if nargin<=2,
    [h1,x]=hist(mtx,n);
else
    x=0:lim/(n-1):lim;
    h1=histc(mtx,x);
    x=x+lim/(2*(n-1));
    x=x';
end
h=mean(h1,2)*100/sum(mean(h1,2));
bar(x,h);
