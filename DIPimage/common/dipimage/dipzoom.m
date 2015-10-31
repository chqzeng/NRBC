%DIPZOOM   Interactive image zooming
%   DIPZOOM ON turns on interactive zooming of the current image.
%   DIPZOOM OFF turns it off.
%   DIPZOOM by itself toggles the state.
%
%   When DIPZOOM is turned on, clicking on the image with the left mouse
%   button zooms in, and with the right mouse button zooms out. A double-
%   click will set the zoom factor to 100%. You can also drag a rectangle
%   around the region of interest, which will be zoomed such that it fits
%   the figure window. DIPZOOM never changes the size of the window itself.
%
%   DIPZOOM only works on figure windows created through DIPSHOW.
%
%   Also: DIPZOOM(H,'ON'), DIPZOOM(H,'OFF'), etc. to specify a window handle.
%
%   See also DIPSHOW, DIPTEST, DIPORIEN, DIPTRUESIZE, DIPSTEP, DIPLINK.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July-August 2000
% 2 September 2000: Enabled DIPZOOM for color images.
% 9 November 2000: Improved title bar display.
%                  We now display the zoom factor in the titlebar.
% 16-26 August 2001: Changed DIPSHOW. This function changes accordingly.
%                    Zoom callback functions are in DIPSHOW now.
%                    Changed how DIPZOOM reacts to the mouse a bit.
%                    Added 1D support.
% 19 May 2009: Changed help to match changes in DIPSHOW.

