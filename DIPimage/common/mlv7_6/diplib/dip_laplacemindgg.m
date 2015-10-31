%dip_laplacemindgg   Second order derivative filter.
%    out = dip_laplacemindgg(in, ps, sigmas, flavour)
%
%   in
%      Image.
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

%   DATATYPES:
%Depends on the underlying implementation, but expect:
%
%binary, integer, float
%FUNCTION
%Computes Laplace - Dgg. For two-dimensional images this is equivalent to the
%second order derivative in the direction perpendicular to the gradient
%direction.
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input	
% 	dip_Image out	 	IMAGE *out	 	Output	
% 	dip_BoundaryArray boundary	 	 	 	Boundary extension	
% 	dip_BooleanArray ps	 	int process	 	Dimensions to process	
% 	dip_FloatArray sigmas	 	double sigma, sX, sY, sZ	 	Sigma of Gaussian	
% 	dip_float tc	 	double tc	 	Truncation of Gaussian	
% 	dip_DerivativeFlavour flavour	 	int flavour	 	Derivative flavour	
%
%
%The flavourflavour	 	int flavour	 	Derivative flavour	
%
%
%	DIPlib		Scil-Image		Description	
%	DIP_DF_DEFAULT	 	DF_DEFAULT	 	Default family (DIP_DF_FIRGAUSS)	
%	DIP_DF_FIRGAUSS	 	DF_FIRGAUSS	 	Gaussian family, FIR implementation	
%	DIP_DF_IIRGAUSS	 	DF_IIRGAUSS	 	Gaussian family, IIR implementation	
%
%
%SEE ALSO
% Derivative , GradientMagnitude , GradientDirection2D , Laplace, Dgg , LaplacePlusDgg 
