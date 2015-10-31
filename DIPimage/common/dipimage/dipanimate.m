%DIPANIMATE   Animates a 3D image in a display window
%   DIPANIMATE(H) animates the 3D image in window with handle H. It shows
%   all slices in sequence, starting at 0 till the end. Interrupt with Esc.
%   H defaults to the current figure window.
%
%   DIPANIMATE(H,T) waits T seconds between slices. T must be at least 0.05
%   (20 frames per second). This minimum is imposed because a smaller pause
%   is useless. H cannot be left out in this syntax.
%
%   DIPANIMATE(...,'loop') loops. It continues going until the user interrupts
%   with the Esc key. The looping is performed by going from slice 0 to the
%   last slice, then backwards, then forward again, etc. To skip the reverse
%   sequence use 'loopfwd'.
%
%   Note: If you feel the need to interrupt this function with Ctrl-C,
%   you will need to refresh the display (by re-displaying the image
%   or changing the 'Actions' state).
%
%   See also DIPSHOW.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, September 2001
% 18 February 2002: Fixed bug because of difference between versions of MATLAB.
% 22 Jan 2004: Changed looping behaviour, to go 0:N-1,N-1:0 instead of 0:N-1,0:N-1 (BR)
% 11 Aug 2005: Added the 'loopfwd' option, and made the non-looping version not go backwards. (CL)
% 19 September 2007: Using new function MATLABVERSION.
% 17 December 2009: Using new function MATLABVER_GE.

