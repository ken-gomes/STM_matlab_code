function [Psi, E, Vout, DOS, LDOS, bias, delta]= kHubb(nx,W,U,nf,nV)

% 
% 

%Parameters
if nargin<5, nV=10; end;
if nargin<4, nf=0.5; end;
if nargin<3, U=0; end;
if nargin<2, W=1; end;
n=nx^2;
Nf=round(n*nf);


% Building impurity potential from -W/2 to W/2;
if size(W)==1,
    V=W*(.5-rand(1,n));
else
    V=reshape(W,1,n);
end;

Vout=reshape(V,nx,nx);

% Building H0;

H0=zeros(n);

for k=1:n,
    
    % imputirity potential 
    H0(k,k)=V(k);
    
    % defining site in grid coordenates
    y0=1+floor((k-1)/nx);
    x0=k-nx*(y0-1);
    
    % Defining First neighbor hop
    x1=x0-1; y1=y0;
    if x1==0, x1=nx; end;
    k1=x1+nx*(y1-1);
    H0(k,k1)=1;
    
    x1=x0+1; y1=y0;
    if x1==nx+1, x1=1; end;
    k1=x1+nx*(y1-1);
    H0(k,k1)=1;    

    x1=x0; y1=y0-1;
    if y1==0, y1=nx; end;
    k1=x1+nx*(y1-1);
    H0(k,k1)=1; 
    
    x1=x0; y1=y0+1;
    if y1==nx+1, y1=1; end;
    k1=x1+nx*(y1-1);
    H0(k,k1)=1; 
    
end;

% Diagonalizing H0;

[phi, E0]=eig(H0);

% Shifting the chemical potential to zero
Ef=E0(Nf,Nf);
E0=E0-Ef*eye(n);
H0=H0-Ef*eye(n);

% Adding the interaction term
if U~=0,
    D=rand(1,n)*U;                 % start condition for D:
    conv=1;                        % term that will check for convergence
    while conv>0.001,
        Hubb=zeros(2*n);           % define H for boguliubov equation
        Hubb(1:n,1:n)=H0;
        Hubb(n+1:2*n,n+1:2*n)=-H0;
        for k=1:n,
            Hubb(n+k,k)=D(k);
            Hubb(k,n+k)=D(k);
        end;
        [vec, val]=eig(Hubb);       % find u and v
        u=vec(1:n,n+1:2*n);
        v=vec(n+1:2*n,n+1:2*n);
        D0=D;
        for k=1:n,
            D(k)=U*u(k,:)*v(k,:)';
        end;
        conv=norm(D-D0);
        display(conv);
    end;
end;

% Writing output

if U==0,
    E=zeros(1,n);
    Psi=cell(1,n);
    delta=zeros(nx);
    for k=1:n,
        E(k)=E0(k,k);
        Psi{k}=reshape(phi(:,k),nx,nx);
    end;
    [DOS, LDOS, bias]=kDOS(E,Psi,nV);
else
    Psi.n=cell(1,n);
    Psi.u=cell(1,n);
    Psi.v=cell(1,n);
    LDOS.n=cell(1,nV);
    LDOS.u=cell(1,nV);
    LDOS.v=cell(1,nV);
    for k=1:n,
        E.s(k)=val(k+n,k+n);
        E.n(k)=E0(k,k);
        Psi.n{k}=reshape(phi(:,k),nx,nx);
        Psi.u{k}=reshape(u(:,k),nx,nx);
        Psi.v{k}=reshape(v(:,k),nx,nx);
    end;
    delta=reshape(D,nx,nx);
    [DOS.n, LDOS.n, bias.n]=kDOS(E.n,Psi.n,nV);
    [DOS.s, LDOS.u, bias.s]=kDOS(E.s,Psi.u,nV);
    [DOS.s, LDOS.v, bias.s]=kDOS(E.s,Psi.v,nV);
end;

%%%% Function to generate the Density of States %%%%%%%

function [DOS, LDOS, V]=kDOS(E,Psi,nV)

nx=size(Psi{1},1);
[DOS, V]=hist(E,nV);
nE=1;
LDOS=cell(1,nV);
for i=1:nV,
    LDOS{i}=zeros(nx); 
    k=1;
    while k<=DOS(i),
    LDOS{i}=LDOS{i}+Psi{nE}.^2;
    nE=nE+1;
    k=k+1;
    end;
end;
