%OUT_PHYS = DI_FINDPHYSDIMS(IN1_PHYSDIMS,IN2_PHYSDIMS)
%    Determines the output physical dimensions that results from an operation
%    between images with physical dimensions IN1_PHYSDIMS and IN2_PHYSDIMS.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger 2008.
% 6 March 2008:  Added some more input checking. Pixel size and units kept in sync. (CL)
% 10 March 2008: Testing PixelSize element for emptyness, not struct variable. (CL)
% 14 April 2008: Added 'ConflictingPixelSize' property. (CL)
% 1 June 2010: converted error -> warning (BR)

function out_type = di_findphysdims(p1,p2)

% One input can be a scalar!

if isempty(p1.PixelSize) & isempty(p2.PixelSize)
   out_type = di_defaultphysdims(0);
elseif isempty(p1.PixelSize)
   out_type = p2;
elseif isempty(p2.PixelSize)
   out_type = p1;
else
   if length(p1.PixelSize)~=1 && length(p2.PixelSize)~=1 && length(p1.PixelSize) ~= length(p2.PixelSize)
      %1D images are often used as doubles
      %putting an error here, breaks some codes
      warning('Dimensionalities of pixel dimensions do not match');
   end
   if all(p1.PixelSize==p2.PixelSize) & all(strcmp(p1.PixelUnits,p2.PixelUnits))
      out_type = p1;
   else
      switch lower(dipgetpref('ConflictingPixelSize'))
         case {'first','ignore'}
            out_type = p1;
         case 'second'
            out_type = p2;
         case 'pixel'
            out_type = di_defaultphysdims(length(p1.PixelSize));
         case 'warning'
            warning('Physical pixel sizes of inputs do not match, setting to default.');
            out_type = di_defaultphysdims(length(p1.PixelSize));
         case 'error'
            error('Physical pixel sizes do not match.');
         otherwise
            error('Illegal ''ConflictingPixelSize'' property value.');
      end
   end
end
