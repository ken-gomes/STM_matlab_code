function [dataout, filtermap]=kfftfilter(data, Rin, Rout)

%   [filtered_data,filtered_fft]=kfftfilter(data, Rin, Rout)
%   generates a filtered version from the fft of data;
%   in: data = image ; Rin = high pass radius; Rout = low pass radius
%   if all you need is a high pass, you don't need to input Rout
%   if all you need is a low pass input 0 for Rin.

[nx, ny]=size(data);
if nargin<3, Rout=nx^2+ny^2; end;

fft_data=fftshift(fft2(data));

[kx,ky]=meshgrid(-floor(nx/2):round(nx/2)-1,-floor(ny/2):round(ny/2)-1);
filter = (sqrt(kx.^2 + ky.^2) < Rin) | (sqrt(kx.^2 + ky.^2) > Rout);
fft_data(filter)=0;
dataout=ifft2(ifftshift(fft_data));

if nargout > 1,
    filtermap=abs(fft_data);
    filtermap(filter)=0;
end;
