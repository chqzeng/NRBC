%dip_finitedifference   a linear filter.
%    out = dip_finitedifference(in, processDim, filter)
%
%   in
%      Image.
%   processDim
%      Integer number.
%   filter
%      Filter shape. String containing one of the following values:
%      'm101', '0m11', 'm110', '1m21', '121'.

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
%The FiniteDifference filter implements several basic one dimensional FIR
%convolution filters. The dimension in which the operation is to be performed is
%specified by processDim. The operation itself is selected with filter. The
%(-1 0 1), (-1 1 0) &amp; (0 -1 1) are difference filters that approximate a first
%order derivative, the (1 -2 1) filter approximates a second order derivative
%operation. The piramid shaped (1/4 1/2 1/4) filter is a local smoothing filter. All
%filters are normalized (sum of filter coeff. is 0 or 1).
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input image	
% 	dip_Image out	 	IMAGE *out	 	Output image	
% 	dip_BoundaryArray boundary	 	BoundaryArray boundary	 	Boundary extension	
% 	dip_int processDim	 	int processDim	 	ProcessDim	
% 	dipf_FiniteDifference filter	 	int filter	 	Filter selection	
%
%The dipf_FiniteDifference enumeration consists of the following flags:
%
%	DIPlib		Scil-Image		Description		DIP_FINITE_DIFFERENCE_M101	 	-1 0 1	 	out[ii] = in[ii+1] - in[ii-1]	
%	DIP_FINITE_DIFFERENCE_0M11	 	0 -1 1	 	out[ii] = in[ii+1] - in[ii]	
%	DIP_FINITE_DIFFERENCE_M101	 	-1 0 1	 	out[ii] = in[ii] - in[ii-1]	
%	DIP_FINITE_DIFFERENCE_1M21	 	1 -2 1	 	out[ii] = in[ii-1] - 2*in[ii] + in[ii+1]	
%	DIP_FINITE_DIFFERENCE_121	 	1/4 1/2 1/4	 	out[ii] = (in[ii-1] + in[ii] + in[ii+1])/4	
%
%SEE ALSO
%General information about convolution
%
% SobelGradient , Uniform , Gauss   , SeparableConvolution , Convolve1d , Derivative 
