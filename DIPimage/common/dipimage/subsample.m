%SUBSAMPLE   Subsample an image
%
%
% SYNOPSIS:
%  image_out = subsample(image_in, subsample_factor)
%
% PARAMETERS:
%  subsample_factor = integer array containing the subsampling
%
% DEFAULT:
%  subsample_factor = 2

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2001.

function out = subsample(varargin)

d = struct('menu','Manipulation',...
           'display','Subsample',...
           'inparams',struct('name',       {'in',   'subs'},...
                             'description',{'Input image','Subsample factors'},...
                             'type',       {'image',      'array'},...
                             'dim_check',  {0,            1},...
                             'range_check',{[],           'N+'},...
                             'required',   {1,            0},...
                             'default',    {'a',          2}...
                            ),...
           'outparams',struct('name',{'out'},...
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
   [in,subs] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
out = dip_subsampling(in,subs);
