%dip_imagelut   Lookup table
%
% SYNOPSIS:
%    out = dip_imagelut(in, func_arg, func_val)
%
% PARAMETERS:
%   in
%      Image.
%   func_arg
%      One-dimensional image.
%   func_val
%      One-dimensional image.
%
% DESCRIPTION:
%   the parameters func_arg and func_val together form a set of points
%   for which a function is specified (func_arg) and the corresponding
%   function values (func_val). So if we know the function f at three
%   points: c1, c2 and c3 with function values f1, f2, and f3 respectively,
%   then we have func_arg=[c1,c2,c3] and func_val=[f1,f2,f3].
%   The function then considers each value in the input image as a
%   coordinate c, looks up the closest point in func_arg and using linear
%   interpolation computes the corresponding function value f. The value f
%   is then written to the output image.
%
%   if func_arg is not specified, i.e. [], the input image is consider
%   to contain direct indices into the func_val array, i.e.
%   out(x,y)=func_val(in(x,y));
%
%   if func_val is not specified, i.e. [], then the routines looks up
%   the closest match to c(x,y) in func_arg and returns the index to
%   that coordinate in the func_arg array.

% (C) Copyright 2003                    Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel, April 2003.

