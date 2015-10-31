%DI_DERIVEDMEASUREMENTS add derivde measurements to the measure function

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
%  Bernd Rieger, February 2008.

function out = di_derivedmeasurements(in)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

out = { ...
   'DimensionsCube', 'extent along the principal axes of a cube', 'Inertia';...
   'GreyDimensionsCube','extent along the principal axes of a cube (grey-weighted) *', 'GreyInertia'; ...
   'DimensionsEllipsoid', 'extent along the principal axes of an ellipsoid', 'Inertia';...
   'GreyDimensionsEllipsoid','extent along the principal axes of an elliposid (grey-weighted)*', 'GreyInertia'; ...
   'MajorAxes','principal axes of an object','Mu'; ...
   'GreyMajorAxes','principal axes of an object (grey-weigheted) *','GreyMu'};
