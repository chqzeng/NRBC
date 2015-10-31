%dip_gaussiansigma   Adaptive Gaussian smoothing filter.
%    out = dip_gaussiansigma(in, sigma, gaussSigma, threshold, outputCount)
%
%   in
%      Image.
%   sigma
%      Real number.
%   gaussSigma
%      Real array.
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
%The GaussianSigma filter is an adaptive Gauss-ian smoothing filter.
%The value of the pixel underinvestigation is replaced by the Gaussian-weighted
%average of the pixelvalues in the filter region which lie
%in the interval +/- 2 sigma from the value of the pixel that is filtered.
%The filter region is specified by gaussSigma and truncation.
%If
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
% 	dip_BoundaryArray boundary	 	 	 	../Text/Boundary.html	
% 	dip_float sigma	 	double sigma	 	Sigma	
% 	dip_FloatArray gaussSigma	 	double sX, sY, sZ	 	Sigma of Gaussian	
% 	dip_Boolean outputCount	 	int outputCount	 	Output the Count	
% 	dip_float truncation (-1.0)	 	 	 	Truncation of Gaussian	
%
%LITERATURE
%John-Sen Lee, Digital Image Smoothing and the Sigma Filter, Computer Vision, Graphics and Image Processing, 24, 255-269, 1983
%SEE ALSO
% Sigma , BiasedSigma , Gauss 
