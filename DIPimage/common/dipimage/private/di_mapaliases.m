%DI_MAPALIASES    Map measurement ID aliases to correct ID.

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
%  Bernd Rieger & Cris Luengo.

function feature = di_mapaliases(feature)
switch lower(feature)
    case {'dimension','dimensions'}
        feature = 'CartesianBox';
    case 'min'
        feature = 'Minimum';
    case 'max'
        feature = 'Maximum';
    case 'surfarea'
        feature = 'SurfaceArea';
    case 'ginertia'
        feature = 'GreyInertia';
    case 'gmu'
        feature = 'GreyMu';
    case 'dominantorientation2d'
        feature = 'Orientation2D';
    case 'centre'
        feature = 'center';
end
