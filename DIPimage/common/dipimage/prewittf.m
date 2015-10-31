%PREWITTF   Prewitt derivative filter
%
% SYNOPSIS:
%  image_out = prewittf(image_in,direction)
%
% PARAMETERS:
%  direcion: Dimension to take the derivative along.
%
% DEFAULTS:
%  direction = 1
%
% SEE ALSO:
%  sobelf, derivative, dx, dy, etc.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherland
%
% Cris Luengo, October 2008.

function out = prewittf(varargin)

d = struct('menu','Differential Filters',...
           'display','Prewitt filter',...
           'inparams',struct('name',       {'in',         'direction'},...
                             'description',{'Input image','Derivative dimension'},...
                             'type',       {'image',      'array'},...
                             'dim_check',  {0,            0},...
                             'range_check',{[],           'N'},...
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
   [in,dim] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

out = in;
for ii=1:(ndims(in))
   if ii==dim
      out = dip_convolve1d(out,[1,0,-1]/2,ii-1,[]);
   else
      out = dip_convolve1d(out,[1,1,1]/3,ii-1,[]);
   end
end
