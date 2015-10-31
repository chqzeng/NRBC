%dip_gradientdirection2d   Derivative filter.
%    out = dip_gradientdirection2d(in, ps, sigmas, atanFlavour, flavour)
%
%   in
%      Image.
%   ps
%      Boolean array.
%   sigmas
%      Real array.
%   atanFlavour
%      Flavour of the arctangent. String containing one of the following values:
%      'half_circle', 'full_circle'.
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
%Computes the gradient direction of an image using the Derivative function.
%This functions supports only two dimensional images.
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input	
% 	dip_Image out	 	IMAGE *out	 	Output	
% 	dip_BoundaryArray boundary	 	 	 	Boundary extension	
% 	dip_BooleanArray ps	 	int process	 	Dimensions to process	
% 	dip_FloatArray sigmas	 	double sigmas	 	Sigma of Gaussian	
% 	dip_float tc	 	double tc	 	Truncation of Gaussian	
% 	dip_GradientDirectionAtanFlavour atanFlavour	 	int atanFlavour	 	Atan flavour	
% 	dip_DerivativeFlavour flavour	 	DerivativeFlavour flavour	 	Derivative flavour	
%
%
%The flavourflavour	 	DerivativeFlavour flavour	 	Derivative flavour	
%
%
%	DIPlib		Scil-Image		Description	
%	DIP_DF_DEFAULT	 	DF_DEFAULT	 	Default family (DIP_DF_FIRGAUSS)	
%	DIP_DF_FIRGAUSS	 	DF_FIRGAUSS	 	Gaussian family, FIR implementation	
%	DIP_DF_IIRGAUSS	 	DF_IIRGAUSS	 	Gaussian family, IIR implementation	
%
%
%SEE ALSO
%FIP - derivative operations
%
% Derivative , GradientMagnitude , Laplace, Dgg , LaplacePlusDgg , LaplaceMinDgg 
