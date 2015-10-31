%DIPTEST   Interactive pixel testing
%   DIPTEST ON turns on interactive testing of the current image.
%   DIPTEST OFF turns it off.
%   DIPTEST by itself toggles the state.
%
%   When DIPTEST is turned on, the current coordinates and pixel value are
%   displayed while a mouse button is depressed. You can move the mouse
%   while holding down the mouse button to find some coordinates. The right
%   mouse button can be used to measure lengths.
%
%   DIPTEST only works on figure windows created through DIPSHOW.
%
%   Also: DIPTEST(H,'ON'), DIPTEST(H,'OFF'), etc. to specify a window handle.
%
%   See also DIPSHOW, DIPORIEN, DIPZOOM, DIPSTEP, DIPLINK.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000
% 2 September 2000:  Enabled DIPTEST for color images.
% 9 November 2000:   Improved title bar display.
% 29 March 2001:     Added right-button functionality.
% 28 June 2001:      Fixed bug that occurred when clicking outside the image area.
% 29 July 2001:      getCoords() is now dipfig_getcurpos(), a shared private function.
% 16-26 August 2001: Changed DIPSHOW. This function changes accordingly.
%                    Now supporting 1D images. Fixed bug for empty images
% 15 September 2001: Using FORMATVALUE instead of NUM2STR to display pixel values.
% 22 September 2001: Changed specs of 1D image display (again, *sigh*).
% 14 September 2004: 3D images now display slice when Button down (BR)
% 28 September 2006: added ComplexMappingDisplay option (BR)
% 11 August 2014:    Fix for new graphics in MATLAB 8.4 (R2014b).

%FIRST VERSION:
% Cris Luengo, June/August 1999
% Tested on MATLAB Version 5.2.1.1420 on PCWIN
% Tested on MATLAB Version 5.3.0.10183 (R11) on PCWIN

