%dip_sigma   Adaptive uniform smoothing filter.
%    out = dip_sigma(in, se, filterParam, shape, sigma, threshold, outputCount)
%
%   in
%      Image.
%   se
%      Image.
%   filterParam
%      Real array.
%   shape
%      Filter shape. String containing one of the following values:
%      'rectangular', 'elliptic', 'diamond', 'parabolic', 'user_defined'.
%   sigma
%      Real number.
%   threshold
%      Boolean number (1 or 0).
%   outputCount
%      Boolean number (1 or 0).

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo,February 2000.

%   DATA TYPES:
%integer, float
%FUNCTION
%The Sigma filter is an adaptive Uniform smoothing filter. The value of
%the pixel underinvestigation is replaced by the average of the pixelvalues in
%the filter region (as specified by filterSize, shape and se) which lie
%in the interval +/- 2 sigma from the value of the pixel that is filtered. If
%outputCount is DIP_TRUE, the output values represent the number of pixel over
%which the average has been calculated.
%When threshold is DIP_TRUE, the pixel
%intensities are being thresholded at +/- 2 sigma, when it is set to 
%DIP_FALSE, the intensities are weighted with the Gaussian difference with
%the intensity of the central pixel.
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input image	
% 	dip_Image out	 	IMAGE *out	 	Output image	
% 	dip_Image se	 	IMAGE *se	 	Structuring element	
% 	dip_BoundaryArray boundary	 	 	 	../Text/Boundary.html	
% 	dip_FloatArray filterSize	 	double fsX, fsY, fsZ	 	Filter sizes	
% 	dip_FilterShape shape	 	int shape	 	Filter shape	
% 	dip_float sigma	 	double sigma	 	Sigma	
% 	dip_Boolean outputCount	 	int outputCount	 	Output the Count	
%
%LITERATURE
%John-Sen Lee, Digital Image Smoothing and the Sigma Filter, Computer Vision, Graphics and Image Processing, 24, 255-269, 1983
%SEE ALSO
% BiasedSigma , GaussianSigma , Uniform 
