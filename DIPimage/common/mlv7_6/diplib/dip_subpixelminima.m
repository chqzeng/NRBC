%dip_subpixelminima   Detect local minima with subpixel accuracy
%    [p,v] = dip_subpixelminima(in, mask, method)
%
%   in
%      Grayscale image.
%   mask
%      Binary mask.
%   method
%      One of: 'default', 'linear', 'parabolic', 'gaussian', 'bspline'
%              'parabolic_nonseparable', 'gaussian_nonseparable'.
%      Method used to locate the subpixel location of maxima. 
%   p
%      Output array of subpixel coordinates ( N_max x N_dim ).
%   v
%      Out array of interpolated values ( N_max x 1 ).

% Copyright 2004-2010, Tuan Q. Pham, Cris Luengo.
