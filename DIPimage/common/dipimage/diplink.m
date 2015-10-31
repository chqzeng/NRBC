%DIPLINK   Linking of displays for 3D images
%   DIPLINK allows the user to select one or more display windows to
%   link the current window with.
%   DIPLINK OFF unlinks the current figure window.
%
%   Linking a window with one or more other windows means that the latter
%   will display the same slice number and orientation as the former.
%   The linking is one way, e.g. if 'a' is linked with 'b', 'b' is not linked
%   with 'a'. Changing the slice of 'a' changes that of 'b', but changing the
%   slice of 'b' does not affect 'a'.
%
%   Also: DIPLINK(H,'ON'), DIPLINK(H,'OFF'), etc. to specify a window handle.
%
%   DIPLINK(H,LIST) links display H with the displays in LIST. LIST is either
%   a numeric array with figure window handles, or a cell array with variable
%   names. The handle H cannot be left out in this syntax.
%
%   NOTE: DIPLINK(H,CHARLIST) only works on registerd windows, i.e.
%   windows that have been bound to a variable using dipfig.
%
%   NOTE: For backwards compatability, DIPLINK ON is the same as DIPLINK.
%
%   See also DIPSHOW, DIPMAPPING, DIPSTEP, DIPZOOM, DIPTEST.

% (C) Copyright 1999-2005               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, July 2001
% 16-26 August 2001 (CL): Changed DIPSHOW. This function changes accordingly.
% 22 September 2001 (CL): Changing the windows we link to immediately.
%                         New syntax: DIPLINK(H,LIST).
% Dec 2002 (BR), extended help (diplink only works on registered images names)
% 2 February 2005 (CL):   DIPLINK no longer toggles the state, but always shows
%                         the dialog box to specify new linlked windows.
% 17 october 2011 (BR):   Added linking for 2D displays

