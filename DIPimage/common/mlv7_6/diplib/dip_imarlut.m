%dip_imarlut   lookup responses from an image array
%              useful to interpolate an image from a scale-space
%
% SYNOPSIS:
%    out = dip_imarlut(in, bins, vals, method)
%
% PARAMETERS:
%   in
%      Image contain argument to be looked up.
%   bins
%      Float array with fixed sampled arguments.
%   vals
%      Image array, each image corresponds to 1 bin, 
%      each pixel corresponds to a same pixel in input image.
%   method
%      Interpolation method: zoh, bspline or linear (default)
%
% DESCRIPTION:
%   the parameters bins and vals(ii,jj) together form a set of points
%   for which a function is specified at bins with the corresponding
%   function values vals(ii,jj). So if we know the function f at three
%   points: c1, c2 and c3 with function values f1, f2, and f3 respectively,
%   then we have bins=[c1,c2,c3] and val(ii,jj)={f1,f2,f3}.
%   The function then considers each pixel in the input image (in(ii,jj)) as a
%   coordinate c, looks up the closest point in bins and uses the user-defined
%   interpolation to compute the corresponding function value f. The value f
%   is then written to the output pixel out(ii,jj). Coordinate (ii,jj) runs
%   over the whole input image (in) & parameter image array (vals)
%
%   if bins is not specified, i.e. [], bins=[0 1 2 ... length(vals)-1];
%   the image array must be specified
%   out-of-bound lookup (outside [min(bins) max(bins)]) results in copy
%   boundary effect (i.e. either vals{0}(ii,jj) or vals{end}(ii,jj) is used)
%   the function also attemp to sort bins & synchronize image array vals with it
%
% EXAMPLE: interpolation across scale-space to filter noisy image (wiener2)
%  a = noise(readim,'gaussian',10)
%  ss = 1, st = 2,
%  r = structuretensor(a,ss,st,{'energy'})
%  sigma = st*exp(-r/median(r)/3)
%  b = newimar(a,gaussf(a,0.5),gaussf(a,1),gaussf(a,2));
%  c = dip_imarlut(sigma,[0 0.5 1 2],b,'linear')

% (C) Copyright 2003                    Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham, December 2003.

