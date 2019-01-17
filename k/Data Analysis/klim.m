function data=klim(mtx, limlow, limhigh, lowval, highval)

% Saturates matrix within certain limits. 
% Input: mtx = map
%          limlow =  new low limit 
%          limhigh =  new high limit (optional: if you just add one paramenter
%           it could be either high or low limit)
% Output: data = result matrix.

if nargin<3,
    datamean=mean(mtx(:));
    if datamean<limlow,
        limhigh=limlow;
        limlow=min(mtx(:));
    else
        limhigh=max(mtx(:));
    end;
end;

data=mtx; 
if nargin<4,
    data(data<limlow)=limlow; 
    data(data>limhigh)=limhigh;
else
    data(data<limlow)=lowval; 
    data(data>limhigh)=highval;
end;