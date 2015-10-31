%dip_radialmean    statistics function.
%    out = dip_radialmean(in, mask, ps, binSize, innerRadius, center)
%
%   in
%      Image.
%   mask
%      Image. Can be [] for no mask.
%   ps
%      Boolean array.
%   binSize
%      Real number.
%   innerRadius
%      Boolean number (1 or 0).
%   center
%      Real array.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo,April 2001.

%   DATATYPES:
%binary, integer, float
%FUNCTION
%This function computes the radial projection of the mean of the pixel
%intensities of in.
%
%
%The radial projection is performed for the dimensions specified by ps. If the
%radial distance of a pixel to the center of the image is r, than the mean of
%the intensities of all pixels with n * binSize &lt;= r &lt; (n + 1) * binSize is
%stored at position n in the radial dimension of out. The radial dimension
%is the first dimension to be processed (as specified by ps). If innerRadius
%is set to DIP_TRUE, the maximum radius that is projected is equal to the
%the smallest dimension of the to be projected dimensions. Otherwise, the
%maximum radius is set equal to the diagonal length of the dimensions to be
%processed.
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input	
% 	dip_Image out	 	IMAGE *out	 	Output	
% 	dip_BooleanArray ps	 	int process	 	Dimensions to project	
% 	dip_float binSize	 	double binSize	 	Size of radial bins	
% 	dip_Boolean innerRadius	 	int innerRadius	 	Maximum radius	
%
%SEE ALSO
% RadialSum , RadialMaximum , RadialMinimum , Sum , Mean , Maximum , Minimum 
