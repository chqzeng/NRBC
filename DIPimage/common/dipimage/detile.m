%DETILE   Splits an image in subimages.
%  Revertes the function TILE. Only defined for 2D and 3D inputs.
%
% SYNOPSIS:
%  out = detile(in, array)
%
% PARAMETERS:
%  out:   dip_image_array of size array
%  array: Number of subimages into which in is broken up per dimension.
%         array=N means Nx1 array. array=[N,M] means NxM array.
%
% DEFAULTS:
%  array = 2;
%
% EXAMPLE:
%  a=readim;
%  g=gradient(a);
%  G=g*g';
%  G1=tile(G)
%  detile(G1,[4 2])
%
% SEE ALSO:
%   tile, arrangeslices

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, June 2007
% 19 May 2009:   Modified so that  isequal(a,detile(tile(a),imarsize(a))). (CL)

function out = detile(in, ts)
if nargin == 1
   if ischar(in) & strcmp(in,'DIP_GetParamList')
      out = struct('menu','none');
      return
   end
end
if nargin<2
   ts=2;
end
if ~isa(in,'dip_image')
   in = dip_image(in);
end
if ~isscalar(in) | ndims(in)>3 | ndims(in)<2
   error('Input image must be a 2D or 3D scalar image.');
end
if length(ts)==1
    ts = [ts 1];
elseif prod(size(ts))~=2
   error('Array to detile the image must have two elements.');
end
sz = imsize(in);
sz = sz([2,1]);
if any(mod(sz,ts))
    error('The array must divide the image size.');
end
dd = sz./ts;

out = newimar(ts);
stx = 0;
for jj=1:ts(2)
    edx = stx+dd(2)-1;
    sty = 0;
    for ii=1:ts(1)
        edy = sty+dd(1)-1;
        %fprintf('%d:%d %d:%d\n',stx,edx,sty,edy);
        if ndims(in)==2
            out{ii,jj} = in(stx:edx,sty:edy);
        else
            out{ii,jj} = in(stx:edx,sty:edy,:);
        end
        sty = edy+1;
    end
    stx = edx+1;
end
