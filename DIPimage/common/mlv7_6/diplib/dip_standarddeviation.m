%dip_standarddeviation    statistics function.
%    out = dip_standarddeviation(in, mask, ps)
%
%   in
%      Image.
%   mask
%      Mask image. Can be [] for no mask.
%   ps
%      Boolean array.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo,February 2001.

%   DATATYPES:
%binary, integer, float
%FUNCTION
%Calculates the standard deviation of the pixel values over all those dimensions which 
%are specified by ps.
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input	
% 	dip_Image mask (0)	 	IMAGE *mask	 	Mask	
% 	dip_Image out	 	IMAGE *out	 	Output	
% 	dip_BooleanArray ps (0)	 	int process	 	Dimensions to project	
%
%SEE ALSO
% Sum , Mean , Variance , MeanModulus , SumModulus , MeanSquareModulus , Maximum , Minimum , Median , Percentile 
