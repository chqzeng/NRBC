%dip_gauss   Gaussian Filter.
%    out = dip_gauss(in, process, sigmas, parOrder)
%
%   in
%      Image.
%   process
%      Boolean array.
%   sigmas
%      Real array.
%   parOrder
%      Integer array.

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
%Finite impulse response implementation of a Gaussian convolution filter and
%Gaussian derivative convolution filters. The Gaussian kernel is cut off
%at truncation times the sigma of the filter (in each dimension). The
%sum of the Gaussian's coefficients is normalised to one.
%
%
%Defaults:
%
%A truncation smaller than zero indicates that the global
%preferred truncation ought to be used. Both the process and the order
%parameter may be zero. If process is zero all dimensions are processed.
%If order is zero no derivatives are taken.
%
%
%Limitations:
%
%The order of the derivative is limited to the interval 0-3. Sigmas
%considerably smaller than 1.0 will yield nonsensical results.
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input	
% 	dip_Image out	 	IMAGE *out	 	Output	
% 	dip_BoundaryArray boundary	 	 	 	Boundary extension	
% 	dip_BooleanArray process (0)	 	int process	 	Dimensions to process	
% 	dip_FloatArray sigmas	 	double sigma, sX, sY, sZ	 	Sigma of Gaussian	
% 	dip_IntegerArray order (0)	 	 	 	Order of Derivative along each dimension	
% 	dip_float truncation (&lt;0)	 	double truncation	 	Truncation of Gaussian	
%
%SEE ALSO
%FIP - smoothing filters
%
%FIP - derivative operations
%
%General information about convolution
%
% GaussIIR , Derivative 
