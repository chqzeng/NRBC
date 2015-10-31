%DIPLOOKING   Interactive looking glas over the image
%   DIPLOOKING ON turns on interactive looking glass of the current image.
%   DIPLOOKING OFF turns it off.
%   DIPLOOKING by itself toggles the state.
%
%   When DIPLOOKING is turned on, clicking on the image with the mouse
%   button zooms in on a region under the cursor, 3x magnification.
%
%   DIPLOOKING only works on figure windows created through DIPSHOW.
%
%   Also: DIPLOOKING(H,'ON'), DIPLOOKING(H,'OFF'), etc. to specify a window handle.
%
%   See also DIPSHOW, DIPTEST, DIPORIEN, DIPTRUESIZE, DIPSTEP, DIPLINK.

% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger & Cris Luengo, April 2004
% 22 July 2004: Avoiding strange stuff when right-clicking while the left mouse
%               button is down.

