%GAUSSF_ADAP_BANANA Adaptive Gaussian filtering in banana like neighborhood
%
% SYNOPSIS:
%  out = gaussf_adap_banana(in, orien_im, curv_im, sigmas, order)
%
% PARAMETERS:
%  orien_im = ImageArray containing the orientation images
%     2D: angle of the orientation
%  curv_im  = Curvature image of in
%  sigmas   = Array containing the sigmas of the derivatives
%     For intrinsic 1D structures, the first value is along the contour,
%     the second perpendicular to it.
%     For intrinsic 2D structures, the first two are in the plane, whereas
%     the other is perpendicular to them.
%     A sigma 0 no convolution is done is this direction.
%  order   = Derivative order
%
% DEFAULTS:
%  order = 0
%
% EXAMPLE:
%  a = readim;
%  p = structuretensor(a,1,3,{'orientation'});
%  c = curvature(a,'line',1,3);
%  d = gaussf_adap_banana(a,p,c,[2 0],0)
%
% LITERATURE:
%  P. Bakker, Image structure analysis for seismic interpretation,
%   PhD Thesis, TU Delft, The Netherlands, 2001
%  L. Haglund, Adaptive Mulitdimensional Filtering,
%   PhD Thesis, Link"oping University, Sweden, 1992
%  W.T. Freeman, Steerable Filters and Local Analysis of Image Structure,
%   PhD Thesis, MIT, USA, 1992
%
% SEE ALSO: gaussf_adap_banana, percf_adap, percf_adap_banana

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2002

function out = gaussf_adap_banana(varargin)

d = struct('menu','Adaptive Filters',...
   'display','Adaptive-banana Gaussian filtering',...
   'inparams',struct('name',{'in','param','curv','sigma','order'},...
   'description',{'Input image','Orientation image','Curvaure image','Sigmas of derivative','Derivatives order'},...
   'type',     {'image','image','image','array','array'},...
   'dim_check',  {0,0,0,1,1},...
   'range_check',{[],[],[],'R+','R+'},...
   'required', {1,1,1,1,0},...
   'default',  {'a','p','c',[2 0],0}...
   ),...
   'outparams',struct('name',{'out'},...
        'description',{'Output'},...
        'type',{'image'}...
        )...
 );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = struct('menu','none');
      return
   end
end
try
   [in,param,curv,sigma,order] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ndims(in)~=2
   error('Only 2D images supported up to now.');
end

out = dip_adaptivebanana(in,dip_image(param,'sfloat'), ...
         dip_image(curv,'sfloat'),sigma,order,3,[0 0]);
