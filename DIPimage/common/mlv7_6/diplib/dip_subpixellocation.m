%dip_subpixellocation   Detect local maxima with subpixel accuracy
%    [p,v] = dip_subpixellocation(in, pos, method, polarity)
%
%   in
%      Grayscale image.
%   pos
%      Integer array with coordinates.
%   method
%      One of: 'default', 'linear', 'parabolic', 'gaussian', 'bspline'
%              'parabolic_nonseparable', 'gaussian_nonseparable'.
%      Method used to locate the subpixel location of maxima. 
%   polarity
%      One of: 'maximum', 'minimum'.
%   p
%      Float array with subpixel coordinates.
%   v
%      Interpolated value of IN at P.

% Copyright 2010, Cris Luengo.
