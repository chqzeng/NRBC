%TILE   Displays a 2D tensor image in one 2D image.
%  Tiles tensor component images along the first two image dimensions.
%
% SYNOPSIS:
%  out = tile(in, stretch)
%
% PARAMETERS:
%  stretch: should the individual images be stretched to [0,255] before tiling?
%
% DEFAULTS:
%  stretch = 0;
%
% EXAMPLE:
%  a=readim;
%  g=gradient(a);
%  G=g*g';
%  tile(G)
%
% SEE ALSO:
%   arrangeslices, detile

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, October 2005
% 9 April 2007:  Removed use of EVAL. (CL)
% 19 May 2009:   Slightly stricter input testing, not limited to 2D any more. (CL)

function out = tile(in,st)
if nargin == 1
   if ischar(in) & strcmp(in,'DIP_GetParamList')
      out = struct('menu','none');
      return
   end
end
if nargin <2
   st =0;
end

if ~isa(in,'dip_image_array')
   error('Input is not a dip_image_array.');
end
sz = imarsize(in);
if ~istensor(in)
   error('Input must be a 2D tensor image.');
end
if st
   %#function stretch
   in = iterate('stretch',in);
end

tmp = newimar(sz(1),1);
for ii=1:sz(1)
   tmp{ii} = cat(1,in{ii,:});
end
out = cat(2,tmp{:});
