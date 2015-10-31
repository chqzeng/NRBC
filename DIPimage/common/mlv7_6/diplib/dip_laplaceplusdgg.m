%dip_laplaceplusdgg   Second order derivative filter.
%    out = dip_laplaceplusdgg(in, ps, sigmas, flavour)
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
%Computes the laplace and the second derivative in gradient direction of an
%image using the Derivative function and adds the results. The
%zero-crossings of the result correspond to the edges in the image, just as for
%the individual Laplace and Dgg operators. The localization is improved by an
%order of magnitude with respect to the individual operators.
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
%LITERATURE
%Lucas J. van Vliet,
%"Grey-Scale Measurements in Multi-Dimensional Digitized Images",
%Delft University of Technology, 1993
%
%
%P.W. Verbeek and L.J. van Vliet,
%"On the location error of curved edges in low-pass filtered 2-D and 3-D images",
%IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 16, no. 7, 1994, 726-733.
%SEE ALSO
% Derivative , GradientMagnitude , GradientDirection2D , Laplace, Dgg , LaplaceMinDgg 
