%OUT_PHYS = DI_CONSISTENTPHYSDIMS(PHYSDIMS,PROPERTY)
%    Checks physical dimensions against PROPERTY.
%    PROPERTY currently unused: only all must be equal

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger 2008.
% 6 March 2008:  Pixel size and units kept in sync. (CL)
% 14 April 2008: Added 'InconsistentPixelSize' property. (CL)

function p = di_consistentphysdims(p,prop)
% prop unused at the moment

if any(diff(p.PixelSize)) | any(~strcmp(p.PixelUnits,p.PixelUnits(1)))
   switch lower(dipgetpref('InconsistentPixelSize'))
      case 'ignore'
         ;
      case 'pixel'
         p = di_defaultphysdims(length(p.PixelSize)); 
      case 'warning'
         warning('Physical pixel sizes of input dimensions do not match, setting to default.');
         p = di_defaultphysdims(length(p.PixelSize)); 
      case 'error'
         error('Physical pixel sizes do not match.');
      otherwise
         error('Illegal ''InconsistentPixelSize'' property value.');
    end
end
