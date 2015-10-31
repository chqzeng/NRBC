%dip_erosion   Mathematical morphology filter.
%    out = dip_erosion(in, se, filterParam, shape)
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
%integer,float
%FUNCTION
%
%The rectangular, elliptic and diamond structuring elements are "flat",
%i.e. these structuring elements have a constant value. For these structuring
%elements, filterParam determines the sizes of the structuring elements. When
%shape is set to DIP_FLT_SHAPE_PARABOLIC, filterParams specifies the curvature
%of the parabola. When shape is set to DIP_FLT_SHAPE_STRUCTURING_ELEMENT,
%se is used as structuring element.
%This can be a "non-flat" structuring element, if a
%real typed scalar image is used.
%
%If shape is not equal to DIP_FLT_SHAPE_STRUCTURING_ELEMENT,
%se is allowed to be set to zero.
%When shape is set to DIP_FLT_SHAPE_STRUCTURING_ELEMENT,
%filterParam is ignored, (and can be set to zero).
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input	
% 	dip_Image out	 	IMAGE *out	 	Output	
% 	dip_Image se	 	IMAGE *se	 	Structuring element	
% 	dip_BoundaryArray boundary	 	 	 	boundary	
% 	dip_FloatArray filterParam	 	double fpX, fpY, fpZ	 	Filter parameters	
% 	dip_FilterShape shape	 	int shape	 	Filter shape	
%
%
%The enumerator dip_FilterShape contains the following constants:
%
%	DIPlib		Scil-Image		Description		DIP_FLT_SHAPE_DEFAULT	 	FS_DEFAULT	 	default structuring element, same as DIP_FLT_SHAPE_RECTANGULAR	
%	DIP_FLT_SHAPE_RECTANGULAR	 	FS_RECTANGULAR	 	rectangular structuring element	
%	DIP_FLT_SHAPE_ELLIPTIC	 	FS_ELLIPTIC	 	elliptic structuring element	
%	DIP_FLT_SHAPE_DIAMOND	 	FS_DIAMOND	 	diamond shaped structuring element	
%	DIP_FLT_SHAPE_PARABOLIC	 	FS_PARABOLIC	 	parabolic structuring element	
%	DIP_FLT_SHAPE_STRUCTURING_ELEMENT	 	FS_STRUCTURING_ELEMENT	 	use se as structuring element	
%
%SEE ALSO
% Closing , Opening , Dilation , Erosion 
