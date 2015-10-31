%GAUSSIANLINECLIP   Clips/maps grey-values to produce a Gaussian line
%
% SYNOPSIS:
%  image_out = gaussianlineclip(image_in,sigma,normalisetoone,truncation)
%
% DEFAULTS:
%  sigma =  1
%  normalisetoone = 0
%  truncation = 3
%
% DESCRIPTION:
%  The input is assumed to represent a running coordinate, as produced
%  by the xx(), yy() , rr() functions et cetera. This function clips
%  the coordinate values around zero to produce a Gaussian line
%  using the following recipe:
%
%  image_out = (1/(sqrt(2*pi)*sigma))*exp(-0.5*image_in^2/sigma^2)
%
%  Where abs(image_in) is larger than truncation*sigma, the above formula is
%  not computed, setting those points to 0. This avoids a lot of
%  computation. Set truncation to Inf to avoid this.
%
%  By default the peak value of the line is 1/(sqrt(2*pi)*sigma). The peak
%  value is set to one if the parameter 'normalisetoone' is set to one.
%
% EXAMPLE:
%  a = gaussianlineclip(rr-40)

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel - 27-04-2002
%  2 July 2002  (CL): Avoiding one division of the image by a scalar.
%  9 July 2002  (CL): Made even quicker by adding the TRUNCATION parameter.
%                     Also using automatic parameter parsing. Much cleaner?
% 28 July 2002 (MvG): Not amused by absolute truncation. Should be relative
%                     to sigma.
% 25 August 2002 (MvG): Added "normalise to one" option.

function out = gaussianlineclip(varargin)

d = struct('menu','Point',...
           'display','Gaussian line clip',...
           'inparams',struct('name',       {'image_in',   'sigma',            'normalisation',   'truncation'},...
                             'description',{'Input image','Sigma of Gaussian','Normalise to one','Truncation'},...
                             'type',       {'image',      'array',            'boolean',         'array'},...
                             'dim_check',  {0,            0,                  0,                 0},...
                             'range_check',{[],           'R+',               [],                'R+'},...
                             'required',   {1,            0,                  0,                 0},...
                             'default',    {'a',          1,                  0,                 3}...
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
   [in,sigma,normtoone,truncation] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if (normtoone)
   norm = 1;
else
   norm = (1/(sqrt(2*pi)*sigma));
end

if isinf(truncation)
   out = norm*exp(in^2*(-0.5/sigma^2));
else
   out = newim(in,'sfloat');
   I = abs(in)<=(sigma*truncation);
   out(I) = norm*exp(in(I)^2*(-0.5/sigma^2));
end
