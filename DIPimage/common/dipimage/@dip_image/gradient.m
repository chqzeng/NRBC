%GRADIENT   Gradient vector of an image.
%   GRADIENT(A,SIGMA) returns the gradient vector of a real valued,
%   scalar image. SIGMA is the Gaussian smoothing. The returned type
%   is an N-by-1 tensor image, where N is the dimensionality of A.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, August 2000.
% Cris Luengo, 21 September 2000: SIGMA is now allowed to be any size vector.
% July 2007, call to gauss_derivative instead to low-level code directly (BR)
% 10 October 2007: Removed logic concerning SIGMA parameter, DERIVATIVE takes
%                  care of that. (CL)

function out = gradient(in,sigma)

if nargin < 2
   out = gradientvector(in);
else
   out = gradientvector(in,sigma);
end
