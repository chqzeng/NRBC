%FILLHOLES   Fill holes in a binary image
%
% SYNOPSIS:
%  out = fillholes(image,connectivity)
%
% DEFAULTS:
%  connectivity = 1

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2004
% 11 March 2009: Not using the default values when calling BPROPAGATION. (CL)
% 13 September 2010: Added connectivity parameter. (CL)

function out = fillholes(varargin)
d = struct('menu','Binary Filters',...
           'display','Fill holes',...
           'inparams',struct('name',       {'image_in',   'connectivity'},...
                             'description',{'Input image','Connectivity'},...
                             'type',       {'image',      'array'},...
                             'dim_check',  {0,            0},...
                             'range_check',{'bin',        [1 3]},...
                             'required',   {1,            0},...
                             'default',    {'a',          1}...
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
   [in,connectivity] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
out = ~bpropagation(newim(in,'bin'),~in,0,connectivity,1);
