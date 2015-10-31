%dip_gaussiir   Infinite impulse response filter.
%    out = dip_gaussiir(in, par_ps, sigmas, order, filterOrder, designMethod)
%
%   in
%      Image.
%   par_ps
%      Boolean array.
%   sigmas
%      Real array.
%   order
%      Integer array.
%   filterOrder
%      Integer array.
%   designMethod
%      Integer number.

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
%Recursive infinite impulse response implementation of the Gauss filter.
%ARGUMENTS
%
% 	DIPlib	 	SCIL-Image	 	Description	
% 	dip_Image in	 	IMAGE *in	 	Input	
% 	dip_Image out	 	IMAGE *out	 	Output	
% 	dip_BoundaryArray boundary	 	 	 	Boundary Conditions	
% 	dip_BooleanArray process	 	int process	 	Dimensions to process	
% 	dip_FloatArray sigmas	 	double sigma, sX, sY, sZ	 	Sigma of Gaussian	
% 	dip_IntegerArray order	 	 	 	Order of Derivative	
% 	dip_IntegerArray order	 	 	 	Order of the IIR Filter	
% 	dip_int designMethod	 	 	 	Method of IIR design	
% 	dip_float truncation	 	double truncation	 	Truncation of Gaussian	
%
%SEE ALSO
% Gauss , GaussIIR , Derivative 
