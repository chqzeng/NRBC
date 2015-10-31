%dip_derivative   Derivative filter.
%    out = dip_derivative(in, process, sigma, order, flavour)
%
%   in
%      Image.
%   process
%      Boolean array.
%   sigma
%      Real array.
%   order
%      Integer array.
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
%This function provides a common interface to different families of regularised
%derivative operators. Which family is used, is specified by the flavour
%parameter. The order of the derivative operator along each of the cartesian
%axes may be specified independently.
%
%
%Be sure to read the documentation on the underlying implementation
%to learn about the properties and limitations of the various families.
%
%
%Limitations:
%
%Currently only one family of derivative operators has been implemented,
%the Gaussian family. There are two different implementations, the FIR
%(Finite Impulse Response) and the IIR (Infinite Impulse Response)
%implementation.
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input	
% 	dip_Image out	 	IMAGE *out	 	Output	
% 	dip_BoundaryArray bc	 	 	 	Boundary extension	
% 	dip_BooleanArray ps (0)	 	int process	 	Dimensions to process	
% 	dip_FloatArray sigmas	 	double sigma,sX,sY,sZ	 	Sigma of Gaussian	
% 	dip_int order (0)	 	int oX, oY, oZ	 	Derivative order	
% 	dip_float truncation	 	double truncation	 	Truncation	
% 	dip_DerivativeFlavour flavour	 	DerivativeFlavour flavour	 	Flavour	
%
%
%The flavourflavour	 	DerivativeFlavour flavour	 	Flavour	
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
% Gauss , GaussIIR , GradientMagnitude , GradientDirection2D , Laplace, Dgg , LaplacePlusDgg , LaplaceMinDgg 
