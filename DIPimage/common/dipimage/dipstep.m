%DIPSTEP   Stepping through slices of a 3D image
%   DIPSTEP ON turns on stepping through slices of the current 3D image.
%   DIPSTEP OFF turns it off.
%   DIPSTEP by itself toggles the state.
%
%   When DIPSTEP is turned on, clicking on the image with the left mouse
%   button shows the next slice of the 3D image, and with the right one
%   the previous slice.
%
%   Dragging the mouse over the image works like dragging a scrollbar:
%   drag down or to the right to go to higher slice numbers, drag up or to
%   the left to go to lower slice numbers. The linked displays will only
%   be updated after you release the mouse button. For 4D images, drag with
%   the right mouse button to move through the 4th dimension.
%
%   DIPSTEP only works on figure windows created through DIPSHOW with 3D
%   or 4D image data.
%
%   Also: DIPSTEP(H,'ON'), DIPSTEP(H,'OFF'), etc. to specify a window handle.
%
%   See also DIPSHOW, DIPTEST, DIPORIEN, DIPZOOM, DIPLINK.

% (C) Copyright 1999-2005               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2001
% 18 December 2001: Added virtual sliders.
% 7 February 2005:  Dragging right mouse button moves through 4th dimension.

