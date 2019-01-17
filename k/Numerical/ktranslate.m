function B=ktranslate(A,t)

% function t=ktranslate(A,t)
% Calculates the convolution of A and B using the fft theorem.
% if A is only input, it calculates kconv(A,A);
%
% For a brute force method use matlab function "conv2"

N=size(A);
B=zeros(N(1),N(2));
tx=t(1);
ty=t(2);
nx=N(1)-abs(tx);
ny=N(2)-abs(ty);
if tx<0,
    if ty<0,
        for i=1:nx,
            for j=1:ny;
                B(i,j)=A(i-tx,j-ty);
            end;
        end;
    else
        for i=1:nx,
            for j=1:ny;
                B(i,j+ty)=A(i-tx,j);
            end;
        end;
    end;
else
    if ty<0,
        for i=1:nx,
            for j=1:ny;
                B(i+tx,j)=A(i,j-ty);
            end;
        end;
    else
        for i=1:nx,
            for j=1:ny;
                B(i+tx,j+ty)=A(i,j);
            end;
        end;
    end;
end;