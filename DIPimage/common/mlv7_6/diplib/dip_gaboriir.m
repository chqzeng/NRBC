%dip_gaboriir   Infinite impulse response filter.
%    out = dip_gaboriir(in, par_ps, sigmas, frequencies, order)
%
%   in
%      Image.
%   par_ps
%      Boolean array.
%   sigmas
%      Real array.
%   frequencies
%      Real array.
%   order
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
%Recursive infinite impulse response implementation of the Gabor filter.
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input	
% 	dip_Image out	 	IMAGE *out	 	Output	
% 	dip_BoundaryArray boundary	 	 	 	Boundary conditions	
% 	dip_BooleanArray ps	 	int process	 	Dimensions to process	
% 	dip_FloatArray sigmas	 	double sigma, sX, sY, sZ	 	Sigma of Gaussian	
% 	dip_FloatArray frequencies	 	double frequency, fX, fY, fZ	 	frequencies	
% 	dip_IntegerArray order	 	 	 	order	
% 	dip_float truncation	 	double truncation	 	Truncation	
%
%SEE ALSO
% GaborIIR , Gabor
