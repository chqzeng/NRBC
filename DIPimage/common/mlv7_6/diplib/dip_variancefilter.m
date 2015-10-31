%dip_variancefilter   Sample Variance Filter.
%    out = dip_variancefilter(in, se, filterParam, shape)
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
%This function calculates for every pixel the sample variance of the pixels
%in the filter window (it size specifiied by filterSize).
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input	
% 	dip_Image out	 	IMAGE *out	 	Output	
% 	dip_Image se	 	IMAGE *se	 	Structuring element	
% 	dip_BoundaryArray boundary	 	BoundaryArray boundary	 	Boundary Conditions	
% 	dip_FloatArray filterSize	 	FloatArray filterSize	 	Filter sizes	
% 	dip_FilterShape shape	 	int shape	 	../Text/Morphology.html	
%
%NOTE
%The filter shape DIP_FLT_SHAPE_PARABOLIC is not supported.
%SEE ALSO
%Kuwahara
