%DIPCROP   Interactive image cropping
%   [B,C] = DIPCROP(H) allows the user to select a rectangular region in
%   the image, which is returned in B. If it is a 3D image, it is not
%   possible to select in the 3rd dimension, so that all slices are
%   returned. H defaults to the current figure.
%
%   It is still possible to use all the menus in the victim figure
%   window, but you won't be able to access any of the tools (like
%   zooming and testing). You can, however, step through a 3D
%   image by using the keyboard.
%
%   In C the selceted box is returned in the form: upper left corner + size
%   B = image(C(1,1):C(1,1)+C(2,1),C(1,2):C(1,2)+C(2,2))
%   B = dip_crop(image,C(1,:),C(2,:)+1)
%
%   Note: If you feel the need to interrupt this function with Ctrl-C,
%   you will need to refresh the display (by re-displaying the image
%   or changing the 'Actions' state).
%
%   See also DIPSHOW, DIPGETCOORDS, DIPTEST, DIPPROFILE.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2001
% 15 August 2001: Catch error in event of closing the window while waiting for the user.
% 16-26 August 2001: Changed DIPSHOW. This function changes accordingly.
%                    Now supporting 1D images.
%                    Changed waiting method: not harmed by changing the state anymore.
% 22 September 2001: Changed specs of 1D image display (again, *sigh*).
% 05 October 2004:   Added cropped coordinates as second output (BR)
% 11 August 2014:    Fix for new graphics in MATLAB 8.4 (R2014b).

