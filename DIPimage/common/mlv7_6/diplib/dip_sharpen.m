%dip_sharpen   Enhance an image.
%    out = dip_sharpen(in, weight, ps, sigmas, flavour)
%
%   in
%      Image.
%   weight
%      Real number.
%   ps
%      Boolean array.
%   sigmas
%      Real array.
%   flavour
%      Derivative flavour. String containing one of the following values:
%      'gaussiir', 'gaussfir', 'gaussft', 'finitediff'.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo,February 2000.

%   DATA TYPES:
%See Laplace
%FUNCTION
%This function enhances the high frequencies ("sharpens") of the input image in
%by subtracting a Laplace filtered version of in from it. The weight 
%parameter determines by wich amount the laplace information is subtracted from
%the original:
%
% output = input - weight * laplace( input ) 
%The sigmas are the Gaussian smoothing parameters of the Laplace
%operation, and determine how strongly the high-frequency noise in in is
%suppressed.
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input image	
% 	dip_Image out	 	IMAGE *out	 	Output image	
% 	dip_float weight	 	double weight	 	Laplacian weight	
% 	dip_BoundaryArray boundary	 	 	 	Boundary extension	
% 	dip_BooleanArray process (0)	 	 	 	Dimensions to process	
% 	dip_FloatArray sigmas	 	double sX, sY, sZ	 	Sigma of Gaussian	
% 	dip_float truncation (&lt;0)	 	 	 	Truncation of Gaussian	
% 	dip_DerivativeFlavour flavour	 	 	 	Derivative Flavour	
%
%NOTE
%The SCIL-Image interface function used the default trunction (-1.0), the
%default derivative flavour (DIP_DF_FIRGAUSS), and processes all dimensions
%(ps=0).
%SEE ALSO
% Laplace 
