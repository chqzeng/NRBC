%GAUSSF_IIR   Recursive Gaussian filter
%  Infinite Impulse Response variant
%  (fast for large filtering kernels)
%
% SYNOPSIS:
%  image_out = gaussf_iir(image_in,sigma)
%
% DEFAULTS:
%  sigma = 10
%
% LITERATURE:
%  I.T. Young and L.J. van Vliet, Recursive implementation of the Gaussian filter
%   Signal Processing, 44(2):139-151, 1995.
%
% SEE ALSO:
%  dip_gaussiir for more options

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel, Sep 2002.
% July 2004, extended help file
% 8 November 2006: Calling GAUSS_DERIVATIVE now. (CL)
% 9 October 2007:  Merged into GAUSSF, moved this into alias directory. (CL)

function image_out = gaussf_iir(varargin)

if nargin==0
   if exist('private/Gauss.jpg','file')
      image_out = dip_image(imread('private/Gauss.jpg'));
      return
   end
end

d = struct('menu','Filters',...
           'display','Gaussian filter (IIR implementation)',...
           'inparams',struct('name',       {'image_in',   'sigma'},...
                             'description',{'Input image','Sigma of gaussian'},...
                             'type',       {'image',      'array'},...
                             'dim_check',  {0,            1},...
                             'range_check',{[],           'R+'},...
                             'required',   {1,            0},...
                             'default',    {'a',          10}...
                            ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      image_out = d;
      return
   end
end
try
   [image_in,sigma] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

image_out = gaussf(image_in,sigma,'iir');
