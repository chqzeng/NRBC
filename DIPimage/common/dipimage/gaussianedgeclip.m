%GAUSSIANEDGECLIP   Clips/maps grey-values to produce a Gaussian edge
%
% SYNOPSIS:
%  image_out = gaussianedgeclip(image_in,sigma,truncation)
%
% DEFAULTS:
%  sigma =  1
%  truncation = 3
%
% DESCRIPTION:
%  The input is assumed to represent a running coordinate, as produced
%  by the xx(), yy() , rr() functions et cetera. This function clips
%  the coordinate values around zero to produce a Gaussian edge
%  using the following recipe:
%
%  image_out = 0.5+0.5*erf(image_in/(sqrt(2)*sigma))
%
%  Where abs(image_in) is larger than truncation*sigma, the above formula is
%  not computed, setting those points to 0 or 1. This avoids a lot of
%  computation. Set truncation to Inf to avoid this.
%
% EXAMPLE:
%  a = gaussianedgeclip(rr-40)

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel - 27-04-2002
%  9 July 2002  (CL): Made quicker by adding the TRUNCATION parameter.
%                     Also using automatic parameter parsing. Much cleaner?
% 28 July 2002 (MvG): Not amused by absolute truncation. Should be relative
%                     to sigma.

function out = gaussianedgeclip(varargin)

d = struct('menu','Point',...
           'display','Gaussian edge clip',...
           'inparams',struct('name',       {'image_in',   'sigma',            'truncation'},...
                             'description',{'Input image','Sigma of Gaussian','Truncation'},...
                             'type',       {'image',      'array',            'array'},...
                             'dim_check',  {0,            0,                  0},...
                             'range_check',{[],           'R+',               'R+'},...
                             'required',   {1,            0,                  0},...
                             'default',    {'a',          1,                  3}...
                            ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
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
   [in,sigma,truncation] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if isinf(truncation)
   out = 0.5+0.5*erf(in/(sqrt(2)*sigma));
else
   truncation=sigma*truncation;
   out = newim(in,'sfloat');
   I1 = in>truncation;
   I = in>=-truncation & ~I1;
   out(I) = 0.5+0.5*erf(in(I)*(1/(sqrt(2)*sigma)));
   out(I1) = 1;
end
