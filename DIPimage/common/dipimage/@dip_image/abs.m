%ABS   The absolute of the pixel values.
%   ABS(B) computes the magnitude of each pixel in B.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 15 November 2002: Fixed binary images to work in MATLAB 6.5 (R13)
% February 2008:    Adding pixel dimensions and units to dip_image. (BR)
% 7 April 2009:     abs(sint) = uint, not single!
% 24 June 2011:     Rewritten for new version of COMPUTE1. (CL)

function img = abs(img)
for ii=1:prod(imarsize(img))
   if ~strcmp(img(ii).dip_type,'bin') & ~strncmp(img(ii).dip_type,'uint',4)
      % Do nothing for binary or unsigned images.
      try
         out_type = img(ii).dip_type;
         if strcmp(out_type,'scomplex')
            out_type = 'sfloat';
         elseif strcmp(out_type,'dcomplex')
            out_type = 'dfloat';
         elseif strncmp(out_type,'sint',4)
            out_type(1) = 'u';
         end
         img(ii) = compute1('abs',img(ii),out_type);
      catch
         error(di_firsterr)
      end
   end
end
