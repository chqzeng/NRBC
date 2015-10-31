%BBOX   Bounding box of an n-D binary image
%
% SYNOPSIS:
%  [out,outb,outg] = bbox(mask, in)
%  mask: binary mask image
%  in: optional, other image to crop to the new size
%
%  out:  the mask image cut to the bounding box
%  outb: the bounding box coordinates
%  outg: the optional image croped to the bounding box
%
% EXAMPLE:
%  [a,b,c]=bbox(readim>210,readim)

%
% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, October 2004
% 9 April 2007, Rewrote to use SUBSREF instead of EVAL. (CL)

function [out,outb,outg] = bbox(in,ingrey)

if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList') % Avoid being in menu
   out = struct('menu','none');
   return
end
if ~islogical(in)
   error('Input must be binary.');
end
if nargin>=2
   if ~isequal(size(in),size(ingrey))
      error('Images not the same size.');
   end
end
if nargout>=3 & nargin<2
   error('2nd input image needed to compute 3rd output value.')
end
N = ndims(in);
msr = measure(dip_image(in,'sint32'),[],{'Minimum','Maximum'});

outb = zeros(N,2);
s = substruct('()',{});
for ii = 1:N
   outb(ii,:) = [msr.Minimum(ii),msr.Maximum(ii)];
   s.subs{ii} = msr.Minimum(ii):msr.Maximum(ii);
end
out = subsref(in,s);
if nargout>=3
   outg = subsref(ingrey,s);
end
