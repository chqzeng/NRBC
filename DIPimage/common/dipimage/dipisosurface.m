%DIPISOSURFACE   Plot isosurfaces of 3D grey value images
%
%   DIPISOSURFACE(IMAGE) plots a isosurface of IMAGE.
%   The initial isovalue is (max(IMAGE)+min(IMAGE))/2.
%
%   DIPISOSURFACE(H) plots an isosurface for the image in the display
%   with handle H.
%
%   Slow for large images and uses lots of memory for the calculation.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Jan 2001
% 16-26 August 2001 (CL): Changed DIPSHOW. This function changes accordingly.
%                         This is still a command in a figure window's menu, but
%                         it is no longer marked or anything.
%                         UIControls now don't queue events when computing.
% 13 February 2002 (CL):  Improved robustness by using the figure handle in all commands.
% 1 July 2002 (CL):       The 'Computing...' uicontrol now hides instead of setting the
%                         string value to empty. Copying the figure window now produces
%                         a better looking bitmap.
% March 2003 (BR):        Added a 'Delete Buttons' button to make exporting easy
% 16 April 2007 (CL):     The axis now start at 0, instead of 1.

% TODO: make the window resizable, and add a Resize callback to position the controls

