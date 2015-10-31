%INV   Inverse of a tensor image
%   INV(A) returns the inverse of A in the sense that
%   INV(A)*A gives a tensor image that has images with
%   only 1 on the diagonal and images with 0 on the
%   off-diagonal (i.e. EYE(A)).
%
%   If the inverse does not exist for a pixel, the out
%   values at that pixel will be Inf (or sometimes NaN
%   with the 'direct' method).
%
% SYNOPSIS:
%  out = inv(in, option)
%
% PARAMETERS:
%  in:      square tensor image, i.e. a matrix of images
%  option:  'LU' per point processing (low memory requirement, accurate)
%           'direct' vectorized processing (fast, up to 4x4 tensor images)
%
% DEFAULTS:
%  option = 'LU'
%
% EXAMPLE:
%  a = newimar(3,3);
%  for ii=1:9;a{ii}=rand(128,128);end
%  b = inv(a);
%  c = a*b;      % c is eye

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, November 2000.
% Nov, 2002, added 4x4 inverse (BR)
% Dec, 2003, added Kees van Wijk code for per point inversion (BR, KvW) 
% July 2010, made 'LU' default option, it produces results more in line with MATLAB's INV.

function out = inv(a,opt)
if ~istensor(a)
   error('Image is not a tensor image.');
end
s = imarsize(a);
if length(s) ~= 2 | s(1)~=s(2)
   error('Tensor image must be square to invert.');
end

if nargin==1
   opt = 'LU';
end

switch lower(opt)
   case 'direct'  
      wa = warning;
      warning('off');
      switch s(1)
         case 2
            out = dip_image('array',[2,2]);
            out(1,1) = a(2,2);
            out(1,2) = -a(1,2);
            out(2,1) = -a(2,1);
            out(2,2) = a(1,1);
            out = out./det(a);
         case 3
            out = dip_image('array',[3,3]);
            %Kramer Regel
            out(1,1) =   a(2,2).*a(3,3)-a(2,3).*a(3,2);
            out(1,2) = -(a(1,2).*a(3,3)-a(1,3).*a(3,2));
            out(1,3) =   a(1,2).*a(2,3)-a(1,3).*a(2,2);
            out(2,1) = -(a(2,1).*a(3,3)-a(2,3).*a(3,1));
            out(2,2) =   a(1,1).*a(3,3)-a(1,3).*a(3,1);
            out(2,3) = -(a(1,1).*a(2,3)-a(1,3).*a(2,1));
            out(3,1) = -(a(2,2).*a(3,1)-a(2,1).*a(3,2));
            out(3,2) = -(a(1,1).*a(3,2)-a(1,2).*a(3,1));
            out(3,3) =   a(1,1).*a(2,2)-a(1,2).*a(2,1);
            out = out./det(a);
         case 4
            out = dip_image('array',[4,4]);
            out(1,1) =   (a(2,2)*a(3,3)*a(4,4) - a(2,2)*a(3,4)*a(4,3) - ...
                          a(3,2)*a(2,3)*a(4,4) + a(3,2)*a(2,4)*a(4,3) + ...
                          a(4,2)*a(2,3)*a(3,4) - a(4,2)*a(2,4)*a(3,3));
            out(1,2) = - (a(1,2)*a(3,3)*a(4,4) - a(1,2)*a(3,4)*a(4,3) - ...
                          a(3,2)*a(1,3)*a(4,4) + a(3,2)*a(1,4)*a(4,3) + ...
                          a(4,2)*a(1,3)*a(3,4) - a(4,2)*a(1,4)*a(3,3));
            out(1,3) = -(-a(1,2)*a(2,3)*a(4,4) + a(1,2)*a(2,4)*a(4,3) + ...
                          a(2,2)*a(1,3)*a(4,4) - a(2,2)*a(1,4)*a(4,3) - ...
                          a(4,2)*a(1,3)*a(2,4) + a(4,2)*a(1,4)*a(2,3));
            out(1,4) = - (a(1,2)*a(2,3)*a(3,4) - a(1,2)*a(2,4)*a(3,3) - ...
                          a(2,2)*a(1,3)*a(3,4) + a(2,2)*a(1,4)*a(3,3) + ...
                          a(3,2)*a(1,3)*a(2,4) - a(3,2)*a(1,4)*a(2,3));
            out(2,1) = - (a(2,1)*a(3,3)*a(4,4) - a(2,1)*a(3,4)*a(4,3) - ...
                          a(3,1)*a(2,3)*a(4,4) + a(3,1)*a(2,4)*a(4,3) + ...
                          a(4,1)*a(2,3)*a(3,4) - a(4,1)*a(2,4)*a(3,3));
            out(2,2) =   (a(1,1)*a(3,3)*a(4,4) - a(1,1)*a(3,4)*a(4,3) - ...
                          a(3,1)*a(1,3)*a(4,4) + a(3,1)*a(1,4)*a(4,3) + ...
                          a(4,1)*a(1,3)*a(3,4) - a(4,1)*a(1,4)*a(3,3));
            out(2,3) = - (a(1,1)*a(2,3)*a(4,4) - a(1,1)*a(2,4)*a(4,3) - ...
                          a(2,1)*a(1,3)*a(4,4) + a(2,1)*a(1,4)*a(4,3) + ...
                          a(4,1)*a(1,3)*a(2,4) - a(4,1)*a(1,4)*a(2,3));
            out(2,4) = -(-a(1,1)*a(2,3)*a(3,4) + a(1,1)*a(2,4)*a(3,3) + ...
                          a(2,1)*a(1,3)*a(3,4) - a(2,1)*a(1,4)*a(3,3) - ...
                          a(3,1)*a(1,3)*a(2,4) + a(3,1)*a(1,4)*a(2,3));
            out(3,1) = -(-a(2,1)*a(3,2)*a(4,4) + a(2,1)*a(3,4)*a(4,2) + ...
                          a(3,1)*a(2,2)*a(4,4) - a(3,1)*a(2,4)*a(4,2) - ...
                          a(4,1)*a(2,2)*a(3,4) + a(4,1)*a(2,4)*a(3,2));
            out(3,2) = - (a(1,1)*a(3,2)*a(4,4) - a(1,1)*a(3,4)*a(4,2) - ...
                          a(3,1)*a(1,2)*a(4,4) + a(3,1)*a(1,4)*a(4,2) + ...
                          a(4,1)*a(1,2)*a(3,4) - a(4,1)*a(1,4)*a(3,2));
            out(3,3) =   (a(1,1)*a(2,2)*a(4,4) - a(1,1)*a(2,4)*a(4,2) - ...
                          a(2,1)*a(1,2)*a(4,4) + a(2,1)*a(1,4)*a(4,2) + ...
                          a(4,1)*a(1,2)*a(2,4) - a(4,1)*a(1,4)*a(2,2));
            out(3,4) = - (a(1,1)*a(2,2)*a(3,4) - a(1,1)*a(2,4)*a(3,2) - ...
                          a(2,1)*a(1,2)*a(3,4) + a(2,1)*a(1,4)*a(3,2) + ...
                          a(3,1)*a(1,2)*a(2,4) - a(3,1)*a(1,4)*a(2,2));
            out(4,1) = - (a(2,1)*a(3,2)*a(4,3) - a(2,1)*a(3,3)*a(4,2) - ...
                          a(3,1)*a(2,2)*a(4,3) + a(3,1)*a(2,3)*a(4,2) + ...
                          a(4,1)*a(2,2)*a(3,3) - a(4,1)*a(2,3)*a(3,2));
            out(4,2) = -(-a(1,1)*a(3,2)*a(4,3) + a(1,1)*a(3,3)*a(4,2) + ...
                          a(3,1)*a(1,2)*a(4,3) - a(3,1)*a(1,3)*a(4,2) - ...
                          a(4,1)*a(1,2)*a(3,3) + a(4,1)*a(1,3)*a(3,2));
            out(4,3) = - (a(1,1)*a(2,2)*a(4,3) - a(1,1)*a(2,3)*a(4,2) - ...
                          a(2,1)*a(1,2)*a(4,3) + a(2,1)*a(1,3)*a(4,2) + ...
                          a(4,1)*a(1,2)*a(2,3) - a(4,1)*a(1,3)*a(2,2));
            out(4,4) =   (a(1,1)*a(2,2)*a(3,3) - a(1,1)*a(2,3)*a(3,2) - ...
                          a(2,1)*a(1,2)*a(3,3) + a(2,1)*a(1,3)*a(3,2) + ...
                          a(3,1)*a(1,2)*a(2,3) - a(3,1)*a(1,3)*a(2,2));
            out = out./det(a);
         otherwise
            error('Direct method only supported for tensor images of size up to 4x4!');
      end
      warning(wa);
   case 'lu'
      out = dip_tensorimageinverse(a);
   otherwise
      error('Unkown option.')
end

