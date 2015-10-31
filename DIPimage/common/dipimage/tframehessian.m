%TFRAMEHESSIAN   Second derivatives driven by structure tensor
%  out = Tangent' * Hessian * Tangent;
%  2D: out{1} in gradient direction
%      out{2} in contour  direction
%  3D: out{i} in direction of i-th eigenvector of GST,
%      meaning dependent on local signal dimensionality
%
% SYNOPSIS:
%  out = tframehessian(image_in, sg, st, sh)
%
% PARAMETERS:
%  out = image array
%  sg  = sigma of derivative
%  st  = sigma of tensor
%  sh  = sigma of hessian
%
% DEFAULTS:
%  sg = 1
%  st = 3
%  sh = 1
%
% SEE ALSO:  Dgg, Dcc

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Feb 2002
% 10 October 2007: Calling LAPLACE_MIN_DGG instead of DIP_LAPLACEMINDGG.

function out = tframehessian(varargin)

d = struct('menu','Adaptive Filters',...
   'display','Structure-tensor driven 2nd derivatives',...
   'inparams',struct('name',       {'in','sg','st','sh'},...
   'description',{'Input image','Sigma of derivative','Sigma of tensor','Sigma of Hessian'},...
   'type',     {'image','array','array','array'},...
   'dim_check',  {[1,3],1,1,1},...
   'range_check',{{'scalar','real'},'R+','R+','R+'},...
   'required', {1,0,0,0},...
   'default',  {'a',1,3,1}...
   ),...
   'outparams',struct('name',{'out'},...
        'description',{'Output'},...
        'type',{'image'}...
        )...
 );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = d;
      return
   end
end
try
   [in,sg,st,sh] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ndims(in)==1
   out = dxx(in,sg);
elseif ndims(in)==2
   %only meaningful for 1D structures, daeh!
   ori = structuretensor(in,sg,st,{'orientation'});
   h = hessian(in,sh);
   t = newimar(cos(ori),sin(ori));
   out =newimar(2);
   out{1} = t' * h * t;
   t = newimar(-sin(ori),cos(ori));
   out{2} = t' * h * t;
elseif ndims(in)==3
   [t1c,p1c,pc,tc,ppc,ttc] = structuretensor3d(in,sg,st,{'phi1','theta1','phi2','theta2','phi3','theta3'});
   t1=newimar(sin(t1c)*cos(p1c), sin(t1c)*sin(p1c), cos(t1c));
   t2=newimar(sin(tc)*cos(pc),   sin(tc)*sin(pc),   cos(tc));
   t3=newimar(sin(ttc)*cos(ppc), sin(ttc)*sin(ppc), cos(ttc));
   clear pc tc ppc ttc t1c p1c
   h = hessian(in,sh);
   out = newimar(3);
   out{1} = t1' * h * t1;
   out{2} = t2' * h * t2;
   out{3} = t3' * h * t3;
   
   %for intrinsic 2D structures (surfaces)
   %1: second derivative in gradient direction
   %2: second derivative in first tangent direction
   %3: second derivative in seond tangent direction
else
   warning(['Image dimensionality >= 4, we''re switching to the standard implementation '...
            'Laplacian - Dgg. This might be problematic as Dgg vanishes at ridges valleys.']);
   %process = ones(size(sg));
   %out = dip_laplacemindgg(in,process,sg,'firgauss');
   out = laplace_min_dgg(in,sg);
end
