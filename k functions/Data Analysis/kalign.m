function Z1 = kalign(Z0, vp0, vp1,rmax)
% creates the tform matrix that aligns Z1(ref) and Z2 (object). 
% To obtain aligned version of Z2 use comand:
% Z2t = imtransform(Z2, tform, 'XData', [1 n],'YData', [1 n]);


n=length(Z0);
N0 = length(vp0);
N1 = length(vp1);

% discard points that are further than rmax
if nargin>3,
    [Xpos, Xref] = meshgrid(vp0(:,1), vp1(:,1));
    [Ypos, Yref] = meshgrid(vp0(:,2), vp1(:,2));
    D = (Xpos-Xref).^2 + (Ypos-Yref).^2;
    vp0(min(D) > rmax^2,:) = [];
    vp1(min(D,[],2) > rmax^2,:) = [];
end


% match locations with vp template
[Xpos, Xref] = meshgrid(vp0(:,1), vp1(:,1));
[Ypos, Yref] = meshgrid(vp0(:,2), vp1(:,2));
D = (Xpos-Xref).^2 + (Ypos-Yref).^2;
if N0<N1,
    [~, b] = min(D);
    vp1 = vp1(b,:);
else
    [~, b] = min(D,[],2);
    vp0 = vp0(b,:);
end


tform = fitgeotrans(vp0, vp1, 'polynomial',3);
R = imref2d([n n],[1 n],[1 n]);
Z1 = imwarp(Z0, R, tform,'OutputView',R);

end
