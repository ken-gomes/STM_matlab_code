function [image, data] =kfft(mtx,sz,lim)

%   [image data] =kfft(mtx)
%   Takes fft of matrix
%   Input: mtx = map to have fft taken
%   Output: image = matrix with fft of mtx, chopping middle point.
%                data = complex fft of mtx

mtx=mtx/mean2(mtx)-1;
if nargin==3, mtx(mtx<-lim)=0; mtx(mtx>lim)=0; end
if nargin<2, sz=max(size(mtx)); end
data=fftshift(fft2(mtx,sz,sz));
image=abs(data);

% this part removes the peak at center
sz=size(mtx); 
cnt1=floor(sz(1)/2)+1; 
cnt2=floor(sz(2)/2)+1;
b=image(cnt1-1:cnt1+1,cnt2-1:cnt2+1);
image(cnt1,cnt2)=median(b(:));
