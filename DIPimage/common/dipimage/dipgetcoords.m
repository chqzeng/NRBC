%DIPGETCOORDS   Interactive coordinate extraction
%   V = DIPGETCOORDS(N) returns coordinates of N pixels, to be
%   selected interactively with the mouse, in the current image.
%   N default to 1.
%
%   Right clicking in the image returns [-1 -1] as coordinates at any time.
%
%   V = DIPGETCOORDS(H,N) returns coordinates selected from
%   figure window with handle H. N cannot be ommited.
%
%   It is still possible to use all the menus in the victim figure
%   window, but you won't be able to access any of the tools (like
%   zooming and testing). You can, however, step through a 3D/4D
%   image by using the keyboard.
%
%   Note: If you feel the need to interrupt this function with Ctrl-C,
%   you will need to refresh the display (by re-displaying the image
%   or changing the 'Actions' state).
%
%   See also DIPSHOW, DIPTEST, DIPCROP, DIPPROFILE.

% (C) Copyright 1999-2003               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000
% Adapted from DIPTEST
% 29 July 2001: Now using dipfig_getcurpos(), a shared private function.
%               The 'slicing' is now regarded: it's not always X-Y slices!
%               Shown in menus.
% 15 August 2001: Catch error in event of closing the window while waiting for the user.
% 16-26 August 2001: Changed DIPSHOW. This function changes accordingly.
%                    Now supporting 1D images.
%                    Removed call to WAITFORBUTTONPRESS. Now using callbacks like DIPCROP.
% 07 April 2005: added right clicking returns -1 (BR)
% 28 July 2006: added 4D image support (BR)
% 04 July 2008: Bug fix for 3D/4D images (BR)
% 18 Aug  2009: Bug fix when using and changing the view slice xy, xz etc (BR)

