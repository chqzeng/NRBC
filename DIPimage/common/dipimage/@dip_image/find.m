%FIND   Find indices of nonzero elements.
%   I = FIND(B) returns the indices of the image B that are
%   non-zero.
%
%   [I,V] = FIND(B) also returns a 1-D image containing the
%   nonzero pixels in B.  Note that find(B) and find(B~=0) will
%   produce the same I, but the latter will produce a V with all
%   1's.
%
%   FIND(B,K) finds at most the first K nonzero indices.
%   FIND(B,K,'first') is the same. FIND(B,K,'last') finds at most
%   the K last indices. This syntax is only valid on versions of
%   MATLAB in which the built-in FIND supports these options.
%
%   See also DIP_IMAGE/FINDCOORD, DIP_IMAGE/SUB2IND, DIP_IMAGE/IND2SUB.

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000.
% 28 Septermber 2010: Extended to allow the parameters K and 'first'/'last'.

function [varargout] = find(in,k,m)
if ~isa(in,'dip_image'), error('First argument must be a scalar image.'); end
if nargin==1
   try
      I = find(in.data);
      I = I(:);
      varargout{1} = I-1;
      if nargout > 1
         varargout{2} = dip_image(in.data(I),in.dip_type);
      end
   catch
      error(di_firsterr)
   end
else
   if nargin<3
      m = 'first';
   end
   try
      I = find(in.data,k,m);
      I = I(:);
      varargout{1} = I-1;
      if nargout > 1
         varargout{2} = dip_image(in.data(I),in.dip_type);
      end
   catch
      error(di_firsterr)
   end
end
