%BESSELJ   Bessel function of the first kind.
%   J = BESSELJ(NU,Z), where Z is an image, creates an image of the same
%   size as Z, with the NU'th order Bessel function of the pixel values
%   of Z. NU must be a scalar.
%
%   B = 2*BESSELJ(1,RR)/RR is the Fourier Transform of a correctly sampled
%   circle.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.
% February 2008: Adding pixel dimensions and units to dip_image. (BR)
% 24 June 2011:  New version of COMPUTE2. NU is always a scalar now. (CL)

function out = besselj(in1,in2)
if ~isnumeric(in1) | prod(size(in1))~=1
   error('NU must be scalar or an image.')
end
try
   out = compute2('besselj',in1,in2);
catch
   error(di_firsterr)
end
