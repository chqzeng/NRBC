%NOT   Overloaded operator for ~a.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2000.
% 15 September 2001: We don't need to use COMPUTE1 for logical operators.
% 15 November 2002:  Fixed binary images to work in MATLAB 6.5 (R13)
% February 2008:     Adding pixel dimensions and units to dip_image. (BR)
% 24 June 2011:      Not using DO1INPUT any more. (CL)

function img = not(img)
for ii=1:prod(imarsize(img))
   img(ii).data = uint8(+(~img(ii).data));
   img(ii).dip_type = 'bin';
end
