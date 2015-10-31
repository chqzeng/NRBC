%DIPPAN   Interactive panning of an image
%   DIPPAN ON turns on panning of the current image.
%   DIPPAN OFF turns it off.
%   DIPPAN by itself toggles the state.
%
%   When DIPPAN is turned on, it is possible to pan the image by clicking
%   and dragging with the mouse on the image. This is especially useful
%   when working with very large images (i.e. they don't fit on your screen)
%   or when zooming in on an image.
%
%   DIPPAN only works on figure windows created through DIPSHOW.
%
%   Also: DIPPAN(H,'ON'), DIPPAN(H,'OFF'), etc. to specify a window handle.
%
%   See also DIPSHOW, DIPZOOM, DIPSTEP.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, March 2002
% 29 April 2002: User can keep panning when mouse is outside the window.
% 19 Oct   2011: added call to update linked displays (BR)

