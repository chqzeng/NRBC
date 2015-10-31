%DIPSTACKINSPECT   Interactive inspection of the third dimension
%   [out,p] = DIPSTACKINSPECT(H, CW, ROI) for a 3D figure window with handle H.
%
% Left-click in the image to see the intensity along the hidden dimension.
%            Possibly the sum intensity in a box if you set ROI
% Right-click to terminate.
%
% OUTPUT:
%   out: 1D image along the selected point
%   p:   Coordinate of the selected point
%
% PARAMETERS:
%   H:   figure handle
%   CW:  boolean, close window after terimnation?
%   ROI: boolean, do you want to select a Region?
%
%   It is still possible to use all the menus in the victim figure
%   window, but you won't be able to access any of the tools (like
%   zooming and testing). You can, however, step through a 3D
%   image by using the keyboard.
%
%   Note: If you feel the need to interrupt this function with Ctrl-C,
%   you will need to refresh the display (by re-displaying the image
%   or changing the 'Actions' state).
%
%   See also DIPSHOW, DIPTEST, DIPCROP, DIPPROFILE, DIPGETCOORDS.

% (C) Copyright 1999-2006               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger October 2006
% 27 October 2006: Fixed bug: the second call to this function always failed.
%                  Made figure handle input argument optional. (CL)
% November 2007:

