%dip_gettruncation   Get the global gaussian truncation.
%    truncation = dip_gettruncation()
%
%   truncation
%      Real number.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo,February 2000.

%   FUNCTION:
%This function gets the global default of the truncation used by the finite
%impluse response implementation of the Gauss (derivative) filter. The
%initial value of this global is 3.0.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_float *truncation      double *truncation      Gaussian truncation
%
%SEE ALSO
% GlobalBoundaryConditionGet , GlobalBoundaryConditionSet , GlobalGaussianTruncationSet , GlobalFilterShapeGet , GlobalFilterShapeSet
