%ISOPHOTE_CURVATURE   Isophote curvature in grey value images
%
% SYNOPSIS:
%  out = isophote_curvature(in, sg)
%
%  sg:  sigma of the gradient derivative
%  out: image containing the principal curvatures (1/radius)
%       The object is considered white.
%       Positive/negative curvatures for elliptic/hyperbolic structures.
%
% DEFAULTS:
%  sg = 1
%
% EXAMPLE:
%  %Curvature of a 3D ball with curvature 0.066 (radius 15)
%  a = testobject(newim([50 50 50]),'ellipsoid',1,15,[1 1 1],0,0,2,0);
%  k = isophote_curvature(a,1);
%  dipshow(1,a,'lin');
%  dipshow(2,k{1},'percentile');
%  dipshow(3,k{2},'percentile');
%  diplink(1,[2 3]);
%  dipmapping(1,'slice',25);
%
% SEE ALSO:
%  curvature
%
% NOTE:
%  This algorithms works only on edges. For ridge-like sturctures use
%  'curvature'. Only implemented for 2 and 3D images
%
% LITERATURE:
%  P.W. Verbeek, A Class of Sampling-error Free Measures
%   in Oversampled Band-Limited Images,
%   Pattern Recognition Letters, 3:287-292, 1985.
% L.J. van Vliet, Grey-Scale Measurements in Multi-Dimensional Digitized Images
%   PhD. thesis, Delft University of Technology, 1993, chapter 5.


%
% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Dec 2002.
% Jan, 2003, edited help file
% Mar, 2003, small bug fix
% May, 2003, added example,literature
% April 2004, eigenvectors second output for 3D

function varargout = isophote_curvature(varargin)
d = struct('menu','Analysis',...
  'display','Isophote curvature',...
  'inparams',struct('name',       {'in',   'sg'},...
  'description',{'Input image','Sigma of Derivative'},...
   'type',       {'image','array'},...
   'dim_check',  {0,1},...
   'range_check',{[],'R+'},...
   'required',   {1,0},...
   'default',    {'a',1}...
  ),...
  'outparams',struct('name',{'out','out2'},...
   'description',{'Curvatures','Eigenvectors (3D)'},...
   'type',{'image','image'}...
   )...
 );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      varargout{1} =d;
      return
   end
end
try
   [in,sg] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
myeps = 10E-10;
N = ndims(in);

switch N
   case 2
      ix=dx(in,sg);
      iy=dy(in,sg);
      varargout{1}=-(dxx(in,sg)*iy^2-2*ix*iy*dxy(in,sg)+dyy(in,sg)*ix^2)/(ix^2+iy^2)^(3/2);

   case 3
      g=gradient(in,sg);
      mg = norm(g);
      r = sqrt(g{1}^2+g{2}^2);
      m = r < sqrt(myeps);
      cp = g{1}/r;
      sp = g{2}/r;
      ct = r/mg;
      st = g{3}/mg;
      cp(m) = 1;%gradient along z axis
      st(m) = 1;
      sp(m) = 0;
      ct(m) = 0;

      R = newimar(3,3);
      R{1,1} = cp*ct;
      R{1,2} = -sp;
      R{1,3} = -cp*st;
      R{2,1} = sp*ct;
      R{2,2} = cp;
      R{2,3} = -sp*st;
      R{3,1} = st;
      R{3,2} = newim(size(in));
      R{3,3} = ct;
      R = dip_image(R,'sfloat');
      H = dip_image(hessian(in,sg),'sfloat');
      H = R'*H*R;%change of basis,  Hessian aligned with g

      K=newimar(2,2);
      K{1,1}=H{2,2};
      K{1,2}=H{2,3};
      K{2,2}=H{3,3};
      K{2,1}=K{1,2};
      clear H
      [l,varargout{2}]=jacobi(K);
      varargout{1} = newimar(l{1},l{2});
      varargout{1} = -1.*varargout{1}./mg;

   otherwise
      error('Not implemented for higher than 3D.');
      %rotation of the hessian unclear etc.
end
