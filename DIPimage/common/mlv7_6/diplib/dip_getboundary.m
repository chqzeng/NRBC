%dip_getboundary   Get global Boundary Conditions.
%    boundary = dip_getboundary(size)
%
%   size
%      Number of dimensions in the output array. Integer number.
%   boundary
%      Boundary Condition. cell array containing one of these strings for
%      each dimension:
%      'symmetric', 'asymmetric', 'periodic', 'asym_periodic',
%      'add_zeros', 'add_max', 'add_min', '0_order', '1_order', '2_order'

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo,February 2000.

%   FUNCTION:
%This function allocates the boundary array array of sie size with the global
%default boundary conditions for each dimension of the image. The initial values
%of this global array is DIP_BC_SYMMETRIC_MIRROR.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%SEE ALSO
% GlobalBoundaryConditionSet , GlobalGaussianTruncationGet , GlobalGaussianTruncationSet , GlobalFilterShapeGet , GlobalFilterShapeSet
