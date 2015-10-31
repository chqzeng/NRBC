%JACOBI   Symmetric eigenvalue analysis
%  Eigenvalues and vectors of a symmetric tensor image
%  computed by the Cyclic Jacobi method
%
% SYNOPSIS:
%  [lambda, ev] = jacobi(in)
%
%  in: a symmetric 2D tensor image, where the elements may
%      be images of any dimension
%  lambda: the sorted eigenvalues in a vector image,
%          out{1} the largest, out{n} the smallest
%  ev: matrix containing the eigenvectors
%      ev{:,1} is the first eigenvector
%
% NOTE: for 2D and 3D eigensystems use better dip_symmetriceigensystem2/3
%       as they provide analytical solutions (faster and more acurate)
%       Further the results of dip_symmetriceigensystem and this routine
%       for the eigenvectors can differ up to sign.
%       Orientation <-> Direction issues :-)
%
% SEE ALSO: orientation4d, structuretensor2d, structuretensor3d
%           dip_symmetriceigensystem2, dip_symmetriceigensystem3
%
% LITEATURE:
% G.H. Golub, C.F. Van Loan, Matrix Computations, 1996,
%    John Hopkins University Press
% H. Rutishauser, Lectures on Numerical Mathematics, 1990, Birkhaeuser
% M. van Ginkel, Image Analysis using Orientataion Space based on Steerable
%    Filters, PhD Thesis, TU Delft, 2002

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Nov 2002.
%  no way to make it @dip_image, as all operations must be
%  replaced by compute2 (which would bring us back to scil,
%  than better do it in C)
% 1 oct 2003 (CL): Bug fix n->N. Avoid sfloat->dfloat conversion.
% April 2004, small bug fix for unequal images size to matrix size
% August 2004, small bug when only returning one output
% 10 October 2007: Calling DERIVATIVE instead of DIP_GAUSS directly. (CL)
% 27 September 2010: Removed all EVAL calls, using IM2ARRAY and ARRAY2IM instead.
%                    Huge speed increase also due to rewritten JACOBI_ROT. (CL)

function [out,V] = jacobi(in)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
     out = struct('menu','none');
     return
end


sz = imarsize(in);

if ~isa(in,'dip_image_array')
   error('Input no image array.');
end
if length(sz)~=2
   error('Image array not 2D.');
end
if (sz(1)~=sz(2))
   error('Input matrix not symmetric.');
end
if nargout >2
   error('Too much output args.');
end
if strcmp('datatype(in)','dfloat')
   in = dip_image(in,'sfloat');
   fpritnf(' Converting to sfloat, keep it on the sane side of memory usage.');
end

n = sz(1); % matrix size

%fprintf(' Additional Memory needed: %4.1f MB\n',...
%      (4*n*n+2*n)*prod(size(in{1,1}))*4/2^20);
if nargout ==2
   V = eye(in);%initial rotation matrix
end
eps = 1E-20 * sum(norm(in));
ii = 0;
while offdiag(in)>eps
   ii = ii+1;
   %fprintf('ii: %d \n',ii)
   for p = 1:n-1
      for q = p+1:n
         %fprintf('p:%d, q:%d\n',p,q);
         [c,s] = symschur(in{p,q},in{q,q},in{p,p});
         J = jacobi_rot(c,s,n,p,q);
         in = J' * in * J;
         if nargout ==2
            V = V*J;%eigenvectors
         end
      end
   end
   if ii>20
      fprintf('current %f, thr %f\n',offdiag(in),eps);
      error('Eigenvalue analysis did not converge.\n');
   end
end

%eigenvalues are now computed, sort them
% use matlab sort on (n+1)D array
% code difficult to read due to nD implementation
% and therefore indexing becomes eval(string)

%fprintf(' Sorting eigenvalues.\n');

out = newimar(n,1);
for ii=1:n
   out{ii} = in{ii,ii};
end
out = array2im(out);
if nargout == 1 ;%sort increasing order
   out = sort(double(out),ndims(out));
else
   [out,ix] = sort(double(out),ndims(out));
end
out = dip_image(out,'sfloat');
out = im2array(out);
out = out{n:-1:1};

if nargout == 1
   return
end

%eigenvalues sorted, do the same for eigen vectors
% (thanks Mike)
%fprintf(' Sorting eigenvectors.\n');
sz2 = imsize(out);
ix = dip_image(ix);
szix = imsize(ix);
% make stride array
sz3 = zeros(1,n);
sz3(1) = sz2(2);
sz3(2) = 1;
for ii=3:n
   sz3(ii) = prod(sz2(1:ii-1));
end

nix = (ix-1)*prod(sz2(1:end-1));
clear ix

for ii=1:n % matrix size
   nix = nix + createramp(szix,ii,'corner')*sz3(ii);
end
nix = double(nix);

if nargin == 2
   pindx = [2,1,3:length(sz2)];
   sz4 = sz2(pindx);
   for kk=1:n % loop over x_kk components
      s = newimar(n,1);
      for ii=1:n % collect all x_kk components in one image for sorting
         s{ii} = V{kk,ii};
      end
      s = array2im(s);
      s = s(nix); % sort the eigenvectors as the eigenvalues
      s = dip_image(permute(reshape(s,sz4),pindx),'sfloat');
         % swap first 2 dims alot due to double <-> dip_image
      s = in2array(s);
      for ii=1:n % want decreasing ordering
         V{kk,n-ii+1} = s{ii};
      end
   end
end



%-------------end-main-function------------------------------------

function [c,s] = symschur(inpq, inqq, inpp)
t = newim(inpq);
c = t;
s = t;
tau =t;

% transform switches on <>0 to masks for images
m1 = (inpq==0);
c(m1) = 1;
%s(m1) = 0;

nm1 = ~m1;
tau(nm1) = (inqq(nm1)-inpp(nm1))/(2*inpq(nm1));
m2 = tau <0 & nm1;
nm2 = tau>=0 & nm1;

t(nm2) = 1/(tau(nm2) +sqrt(1+tau(nm2).^2));
t (m2) = -1/(-tau(m2) +sqrt(1+tau(m2).^2));

c(nm1) = 1/sqrt(1+t(nm1).^2);
s(nm1) = t(nm1)*c(nm1);


function out = jacobi_rot(c,s,n,p,q)
out = newimar(n,n);
out{:} = newim(c);
eins = newim(c)+1;
for ii=1:n
   out{ii,ii} = eins;
end
out{p,p} = c;
out{q,q} = c;
out{p,q} = s;
out{q,p} = -1*s;


function out = offdiag(in)
sz = size(in);
out =0;
for ii=1:sz(1)
   for jj=ii+1:sz(2)
      out = out + sum(in{ii,jj})^2;
   end
end
out = sqrt(out);



%-------------for-testing-------------------------------------
if 0
   a=readim;g=gradient(a);G=smooth(g*g',4);
   [l1,v1,l2,v2]=dip_symmetriceigensystem2(G{1,1},G{1,2},G{2,2},{'l1','v1','l2','v2'});
   [x,v]=jacobi(G);
   x{1}-l1
   abs(v{1,1})-abs(v1{1})

   a=readim('chromo3d');
   g=gradient(a);G=smooth(g*g',4);
   [l1,v1,l2,v2,l3,v3]=...
     dip_symmetriceigensystem3(G{1,1},G{1,2},G{1,3},G{2,2},G{2,3},G{3,3},...
      {'l1','v1','l2','v2','l3','v3'});
   [x,v]=jacobi(G);
   x{1}-l1
   abs(v{1,1})-abs(v1{1})

   a=readim('/data/gauss/users/rieger/4d_test')
   sg=[1 1 1 1];st=[4 4 3 1];
   G = newimar(4,4);
   o1 = zeros(1,4);
   o2 = o1;
   for ii = 1:4
      o1(ii) = 1;
      d1 = derivative(a, sg, o1);
      for jj = ii:4
         o2(jj) = 1;
         d2 = derivative(a, sg, o2);
         G{ii,jj}=subsample(gaussf(d1*d2,st),floor(st));
         o2(jj) = 0;
         if ii ~= jj
            G{jj,ii}=G{ii,jj};
         end
      end
      o1(ii) = 0;
   end
   clear d1 d2
   [x,v]=jacobi(G);
end
