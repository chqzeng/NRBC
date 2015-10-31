%CURVATURE_THIRION   Isophote curvature in grey value images
%
% SYNOPSIS:
%  out = curvature_thirion(in, sg)
%
%  sg:  sigma of the gradient derivative
%  out: image containing the principal curvatures (1/radius)
%       The object is considered white.
%       Positive/negative curvatures for elliptic/hyperbolic structures.
%
% DEFAULTS:
%  sg = 1
%
% SEE ALSO:
%  curvature, isophote_curvature
%
% NOTE:
%  This algorithms works only on edges. For ridge-like sturctures use
%  'curvature'. Only implemented for 3D images
%
% LITERATURE:
%  J.P. Thirion and A. Gourdon,
%  Computing the differential characteristics of isointensity surfaces,
%  Computer Vision and Image Understanding, 61(2):190-202, 1995.


function out=curvature_thirion(in,sg);
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if nargin == 1
   sg =1;
end
if ndims(in)~=3
   error('Only implemented for 3D images.');
end

wa = warning;
warning('off')
fx = dx(in,sg);
fy = dy(in,sg);
fz = dz(in,sg);
fxx = dxx(in,sg);
fyy = dyy(in,sg);
fzz = dzz(in,sg);
fxy = dxy(in,sg);
fxz = dxz(in,sg);
fyz = dyz(in,sg);

h = (fx^2+fy^2+fz^2);
K = (fx^2*(fyy*fzz-fyz^2) + 2*fy*fz*(fxz*fxy-fxx*fyz)...
   + fy^2*(fxx*fzz-fxz^2) + 2*fx*fz*(fyz*fxy-fyy*fxz)...
   + fz^2*(fxx*fyy-fxy^2) + 2*fx*fy*(fxz*fyz-fzz*fxy))...
   *(1/h^2);
H = (fx^2*(fyy+fzz) - 2*fy*fz*fyz + fy^2*(fxx+fzz)...
   - 2*fx*fz*fxz + fz^2*(fxx+fyy)- 2*fx*fy*fxy)...
   *0.5*(1/h^(3/2));
out = newimar(2);
tmp = real(sqrt(H^2-K));
out{1} = H + tmp;
out{2} = H - tmp;
warning(wa);
