%PAIRCORRELATION   Computes the pair correlation of the phases in a labeled image
%
% SYNOPSIS:
%  image_out = paircorrelation(image_in, image_mask, probes, length, estimator, ...
%              covariance, normalisation)
%
% PARAMETERS:
%  image_in:   defines the phases on which the pair correlation function is computed.
%              image_in can be a binary or labeled image.
%  image_mask: mask image to select the regions in image_in that are used to compute the
%              correlation function.
%  probes:     the number of random pair's that are generated to compute the correlation
%              function.
%  length:     the maximum length (in pixels) of the correlation function.
%  estimator:  type of correlation estimator used: 'random' or 'grid'
%  covariance: whether or not to compute the covariance function (else its correlation).
%  normalisation: type of normalisation to be used on the correlation function
%
% DEFAULTS:
%  image_mask = []
%  probes = 1000000
%  length = 100
%  estimator = 'random'
%  covariance = 'no'
%  normalisation = 'none'

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Geert van Kempen, Unilever Research Vlaardingen, June 2001.

function image_out = paircorrelation(varargin)

d = struct('menu','Statistics',...
           'display','Pair correlation',...
           'inparams',struct('name',       {'image_in',   'image_mask','probes',          'length',            'estimator',            'covariance',        'normalisation'},...
                             'description',{'Input image','Mask image','Number of probes','Correlation length','Correlation estimator','Compute covariance','Correlation normalisation'},...
                             'type',       {'image',      'image',     'array',           'array',             'option',               'boolean',           'option'},...
                             'dim_check',  {0,            0,           0,                 0,                   0,                      0,                   0},...
                             'range_check',{[],           [],          'N+',              'N+',                {'random','grid'},      [],                  {'none','volume_fraction','volume_fraction^2'}},...
                             'required',   {1,            0,           0,                 0,                   0,                      0,                   0},...
                             'default',    {'a',          '',          1000000,           100,                 'random',               0,                   'none'}...
                              ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output distribution'},...
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
   [image_in,image_mask, probes, length, estimator, covariance, normalisation] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

image_out = dip_paircorrelation(image_in, image_mask, probes, length, estimator, covariance, normalisation);
