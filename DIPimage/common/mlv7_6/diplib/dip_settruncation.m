%dip_settruncation   Set the global gaussian truncation.
%    dip_settruncation(truncation)
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
%This function sets the global default of the truncation used by the finite
%impluse response implementation of the Gauss (derivative) filter. The
%initial value of this global is 3.0.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_float truncation    double truncation    Truncation
%
%SEE ALSO
% GlobalBoundaryConditionGet , GlobalBoundaryConditionSet , GlobalGaussianTruncationGet , GlobalFilterShapeGet , GlobalFilterShapeSet
