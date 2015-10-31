%dip_generalisedkuwahara   Generalised Kuwahara filter.
%    out = dip_generalisedkuwahara(in, selection, se, filterParam, shape, minimum)
%
%   in
%      Image.
%   selection
%      Image.
%   se
%      Image.
%   filterParam
%      Real array.
%   shape
%      Filter shape. String containing one of the following values:
%      'rectangular', 'elliptic', 'diamond', 'parabolic', 'user_defined'.
%   minimum
%      Boolean number (1 or 0).

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo,February 2000.

%   DATATYPES:
%binary, integer, float
%FUNCTION
%This function is a generalisation of the Kuwahara filter is the
%sense that is does use the variance criterion to select the smoothed value, but
%instead accepts an image with the selection values. The algorithm finds
%for every pixel the minimum of maximum (as specified with minimum) value
%of selection with the filter window (its size specified by filterSize).
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input	
% 	dip_Image selection	 	IMAGE *selection	 	Selection	
% 	dip_Image out	 	IMAGE *out	 	Output	
% 	dip_Image se	 	IMAGE *se	 	Structuring element	
% 	dip_BoundaryArray boundary	 	BoundaryArray boundary	 	Boundary Conditions	
% 	dip_FloatArray filterSize	 	FloatArray filterSize	 	Filter sizes	
% 	dip_FilterShape shape	 	int shape	 	../Text/Morphology.html	
% 	dip_Boolean minimum	 	int minimum	 	Minimum	
%
%NOTE
%The filter shape DIP_FLT_SHAPE_PARABOLIC is not supported.
%SEE ALSO
% Kuwahara , VarianceFilter 
