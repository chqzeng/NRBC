%dip_percentile    statistics function.
%    out = dip_percentile(in, mask, percentile, ps)
%
%   in
%      Image.
%   mask
%      Mask image. Can be [] for no mask.
%   percentile
%      Real number.
%   ps
%      Boolean array.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo,May 2000.

%   DATATYPES:
%binary, integer, float, complex
%FUNCTION
%Calculates the perc percentile of the pixel values over all those dimensions which 
%are specified by ps.
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input	
% 	dip_Image mask (0)	 	IMAGE *mask	 	Mask	
% 	dip_Image out	 	IMAGE *out	 	Output	
% 	dip_float perc	 	double perc	 	Percentile	
% 	dip_BooleanArray ps (0)	 	int process	 	Dimensions to project	
%
%SEE ALSO
% Sum , Mean , Variance , StandardDeviation , MeanModulus , SumModulus , MeanSquareModulus %, Maximum , Minimum , Median
