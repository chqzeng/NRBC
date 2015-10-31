%dip_multiscalemorphgrad   Mathematical morphology filter.
%    out = dip_multiscalemorphgrad(in, se, upperSize, lowerSize, shape)
%
%   in
%      Image.
%   se
%      Image.
%   upperSize
%      Integer number.
%   lowerSize
%      Integer number.
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
%This function computes the average morphological gradient over a range of scales
%bounded by upperSize and @lowerSize. The morphological gradient is computed as
%the difference of the dilation and erosion of the input image at a particular
%scale, eroded by an erosion of one size smaller. At the lowest scale,
%the size of the structuring element is  2 * upperSize + 1.
%
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
% 	dip_BoundaryArray boundary	 	 	 	Boundary conditions	
% 	dip_int upperSize	 	dip_int upperSize	 	Upper size of structuring element	
% 	dip_int lowerSize	 	dip_int lowerSize	 	Lower size of structuring element	
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
%LITERATURE
%D. Wang, Pattern Recognition, 30(12), pp. 2043-2052, 1997
%SEE ALSO
% MorphologicalGradientMagnitude 
