function C=kconv(A,B)

% function C=kconv(A,B)
% Calculates the convolution of A and B using the fft theorem.
% if A is only input, it calculates kconv(A,A);
%
% For a brute force method use matlab function "conv2"

if nargin<2
    B=A;
end

C=fftshift(ifft2(conj(fft2(A)).*fft2(B)));

% removing peak at center
n=size(C,2);
cnt=floor(n/2)+1; 
C(cnt,cnt)=mean2(C(cnt-1:cnt+1,cnt-1:cnt+1));


