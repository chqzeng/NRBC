%DIPORIEN   Interactive orientation testing
%   DIPORIEN ON turns on interactive testing of the current image.
%   DIPORIEN OFF turns it off.
%   DIPORIEN by itself toggles the state.
%
%   The image containing the orientation must be specified in a dialog
%   box the first time you select the option.
%
%   When DIPORIEN is turned on, the current coordinates and orientation
%   value are displayed while a mouse button is depressed. The mouse
%   cursor indicates the current tangent orientation. Orientation lies
%   between -pi/2 and pi/2. A vertical line correspondes with 0 and
%   horizontal with +-pi/2. You can move the mouse while holding down
%   the mouse button to find some coordinates.
%
%   DIPORIEN only works on 2D figure windows created through DIPSHOW.
%
%   Also: DIPORIEN(H,'ON'), DIPORIEN(H,'OFF'), etc. to specify a window handle.
%
%   See also DIPSHOW, DIPLINK, DIPZOOM, DIPSTEP, DIPTEST.

% code mostly copied from diptest.m

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Jan 2001
% 30 March 2001 (CL): Added 'Compute' button to IMAGESELECT and implemented
%                     computing functionality here.
% 28 June 2001 (CL): Fixed bug that occurred when clicking outside the image area.
% 29 July 2001 (CL): now using dipfig_getcurpos(), a shared private function.
% 16-26 August 2001 (CL): Changed DIPSHOW. This function changes accordingly.
% 15 September 2001 (CL): Using FORMATVALUE instead of NUM2STR to display orientation values.
% 21 Juni 2005 (BR): enable binary images

%??? TODO: allow specifying the orientation image through a parameter, so
%    that the dialog box is not shown.

