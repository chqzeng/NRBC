%SLICE_EX   Extracts one slice from an n-D image
%
% SYNOPSIS:
%  out = slice_ex(in, plane, dim)
%
% PARAMETERS:
%  plane:  0..size(in,dim)-1   % slice number
%  dim:    0..ndims(in)-1      % dimension along which to slice
%          -ndims(in)..-1      % negative dimension counts from the end
%
% DEFAULTS:
%  dim = -1 (last dimension)
%
% EXAMPLE:
%  slice_ex(readim('chromo3d'),3)
%  slice_ex(readim('chromo3d'),0,0)
%  slice_ex(readim,3,1)
%
%  SEE ALSO:
%   slice_in, slice_op, im2array, array2im, iterate.

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, September 2004
% 16 September 2004: Extended use of negative dimensions (CL)
% February 2005:     Added support for color images (BR)
% 9 April 2007:      Rewrote to use SUBSREF instead of EVAL. (CL)
% 7 October 2010:    Renamed EX_SLICE to SLICE_EX. Simplified. Not calling
%                    SQUEEZE, but removing only dimension DIM. (CL)

function out = slice_ex(varargin)

d = struct('menu','Manipulation',...
           'display','Extract slice',...
           'inparams',struct('name',       {'in',         'plane',       'dim'},...
                             'description',{'Input image','Slice number','Slicing dimension'},...
                             'type',       {'image',      'array',       'array'},...
                             'dim_check',  {0,            0,             0},...
                             'range_check',{[],           'N',           'Z'},...
                             'required',   {1,            1,             0},...
                             'default',    {'a',          0,             -1}...
                            ),...
           'outparams',struct('name',       {'out'},...
                              'description',{'Output image'},...
                              'type',       {'image'}...
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
   [in,plane,dim] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

N = ndims(in{1});
if dim<0
   dim = N+dim;
end
dim = dim+1;
if dim<1 | dim>N
   error('Dimension out of bounds.');
end
if plane>=imsize(in,dim)
   error('Plane out of bounds.');
end

s = repmat({':'},1,N);
s{dim} = plane;
out = in(s{:});
s = imsize(out);
s(dim) = [];
%#function reshape
out = iterate('reshape',out,s);
