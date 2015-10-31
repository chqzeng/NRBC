%CHORDLENGTH   Computes the chord lengths of the phases in a labeled image
%
% SYNOPSIS:
%  image_out = chordlength(image_in, image_mask, probes, length, estimator)
%
% PARAMETERS:
%  image_in:   defines the phases on which the chord lengths are computed.
%              image_in can be a binary or labeled image.
%  image_mask: mask image to select the regions in image_in that are used
%              to compute the chord lengths.
%  probes:     the number of random pair's that are generated
%  length:     the maximum chord length (in pixels).
%  estimator:  type of correlation estimator used: 'random' or 'grid'
%
% DEFAULTS:
%  image_mask = []
%  probes = 1000000
%  length = 100
%  estimator = 'random'

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Geert van Kempen, Unilever Research Vlaardingen, June 2001.

function image_out = chordlength(varargin)

d = struct('menu','Statistics',...
           'display','Chord length',...
           'inparams',struct('name',       {'image_in',   'image_mask','probes',          'length',            'estimator'},...
                             'description',{'Input image','Mask image','Number of probes','Correlation length','Correlation estimator'},...
                             'type',       {'image',      'image',      'array',              'array',         'option'},...
                             'dim_check',  {0,            0,             0,                    0,              0},...
                             'range_check',{[],           [],          'N+',                 'N+',           {'random','grid'}},...
                             'required',   {1,            0,             0,                    0,              0},...
                             'default',    {'a',          '',            1000000,              100,            'random'}...
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
   [image_in,image_mask, probes, length, estimator] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

image_out = dip_chordlength(image_in,image_mask,probes,length,estimator);
