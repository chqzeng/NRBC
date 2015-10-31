%IM2MAT   Converts a dip_image to a matlab array.
%
% SYNOPSIS:
%  A = IM2MAT(B,DATATYPE)
%
%  Coverts B into a matlab array of class DATATYPE. If DATATYPE
%  is left out, doesn't perform any conversion.
%
% EXAMPLES:
%  a = readim('flamingo');
%  b = im2mat(a);
%  c = mat2im(b,'rgb');   % c is identical to a.
%
%  a = readim('chromo3d');
%  a = gradientvector(a);
%  b = im2mat(a);
%  c = mat2im(b,4);       % c is identical to a.
%
% NOTE:
%  This function is identical to @dip_image/dip_array.
%
% SEE ALSO:
%  MAT2IM, DIP_IMAGE, DIP_IMAGE/DIP_ARRAY

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger & Cris Luengo, August 2008

function out = im2mat(varargin)

if nargin==1
   if ischar(varargin{1}) & strcmp(varargin{1},'DIP_GetParamList')
      out = struct('menu','none');
      return
   end
end
if nargin<1 | ~(isa(varargin{1},'dip_image') | isa(varargin{1},'dip_image_array'))
   error('Input image expected.');
end
try
   out = dip_array(varargin{:});
catch
   error(firsterr);
end
