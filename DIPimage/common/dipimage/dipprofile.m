%DIPPROFILE   Interactive extraction of 1D function from image
%   B = DIPPROFILE(H) returns a 1D image extracted from the image in
%   the figure window with handle H, which defaults to the current
%   figure. The user is allowed to define a line over the image
%   composed of multiple straight segments. The image is interpolated
%   along this line to obtain the 1D image (using cubic interpolation).
%
%   [B,X] = DIPPROFILE(H) also returns the coordinates of the samples
%   in X. X is a N-by-2 array, where N is the size of B.
%
%   B = DIPPROFILE(H,N) terminates automatically after N clicks.
%
%   DIPPROFILE is only available for 2D figure windows.
%
%   To create the line, use the left mouse button to add points.
%   A double-click adds a last point. 'Enter' terminates the line without
%   adding a point. To remove points, use the 'Backspace' or 'Delete'
%   keys, or the right mouse button. 'Esc' aborts the operation.
%   Shift-click will add a point constrained to a horizontal or vertical
%   location with respect to the previous vertex.
%
%   Note that you need to select at least two points. If you don't, an
%   error will be generated.
%
%   It is still possible to use all the menus in the victim figure
%   window, but you won't be able to access any of the tools (like
%   zooming and testing). The regular key-binding is also disabled.
%
%   Note: If you feel the need to interrupt this function with Ctrl-C,
%   you will need to refresh the display (by re-displaying the image
%   or changing the 'Actions' state).
%
%   See also DIPSHOW, DIPGETCOORDS, DIPCROP, DIPROI.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, December 2003
% Adapted from DIPROI
% November 2007: Added predefined number of clicks (BR)
% November 2008: Added functionality for 2D color images (BR)
% 28 May 2010:   Fixed double display of image (CL)
% 11 August 2014: Fix for new graphics in MATLAB 8.4 (R2014b).

