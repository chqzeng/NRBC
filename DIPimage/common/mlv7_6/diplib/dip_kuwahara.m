%dip_kuwahara   Edge perserving smoothing filter.
%    out = dip_kuwahara(in, se, filterParam, shape)
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
%This function implements the kuwahara edge-preserving smoothing function. See
%
%this section for a description of the algorithm. However, this function does
%not implement the classical kuwahara filter, which only compares the variance
%of four regions in the filter window, but compares the variance of every region
%(of size filterSize/2) that fits in the filter region (with a size of
%filterSize). See  for a description of the supported 
%structuring elements.
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input image	
% 	dip_Image out	 	IMAGE *out	 	Output image	
% 	dip_Image se	 	IMAGE *se	 	Structuring element	
% 	dip_BoundaryArray boundary	 	 	 	Boundary Conditions	
% 	dip_FloatArray filterSize	 	int fx, fy, fz	 	Filter sizes	
% 	dip_FilterShape shape	 	int shape	 	../Text/Morphology.html	
%
%NOTE
%The filter shape DIP_FLT_SHAPE_PARABOLIC is not supported.
%SEE ALSO
% GeneralisedKuwahara , VarianceFilter 
