%dip_setboundary   Set global boundary conditions.
%    dip_setboundary(boundary)
%
%   boundary
%      Boundary Condition. cell array containing one of these strings for
%      each dimension. It is not necessary to make a cell if there is only
%      one dimension.:
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
%This function sets the global boundary conditions equal to boundary.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_BoundaryArray boundary    int bcX, bcY, bcZ    Boundary conditions
%
%SEE ALSO
% GlobalBoundaryConditionGet , GlobalGaussianTruncationGet , GlobalGaussianTruncationSet , GlobalFilterShapeGet , GlobalFilterShapeSet
