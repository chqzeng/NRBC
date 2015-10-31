%DIPTRUESIZE   Sets the size of a display to its natural size
%   DIPTRUESIZE(H,PERC) sets the size of the image in the figure
%   window with handle H to a percentage of the original. PERC
%   can be both larger and smaller than 100.
%
%   DIPTRUESIZE(H,'MAX') chooses the percentage to maximize the
%   window size.
%
%   DIPTRUESIZE(H,'OFF') causes the axes of the image in H to fill
%   the figure window. The aspect ratio is lost, but the figure
%   window is not moved nor resized.
%
%   DIPTRUESIZE(H,'TIGHT') sets the aspect ratio of the image to 1:1,
%   adjusting the window to wrap it tightly, so that there is no
%   margin. This is useful when copying or saving an image through
%   the File menu of its display window.
%   DIPTRUESIZE(H,'TIGHT',PERC) additionally sets a zoom percentage.
%
%   The H can be left out of all syntaxes, in which case the
%   current figure window will be addressed. PERC cannot be left
%   out.
%
%   See also DIPSHOW, DIPZOOM.

%   Undocumented:
%   DIPTRUESIZE(H,'INITIAL') sets the percentage to 100% unless the
%   image is larger than the screen, in which case it uses 'MAX'.


% (C) Copyright 1999-2012               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, September 2000 (made independent from dipshow)
% 6 October 2000:    Added 'OFF' parameter
% 9 November 2000:   Keeping upper left corner fixed.
%                    No longer any guessing on border sizes.
%                    We now display the zoom factor in the titlebar.
% 16-26 August 2001: Changed DIPSHOW. This function changes accordingly.
%                    Now respects if udata.zoom==0.
%                    Using DIPGETPREF to get default figure size.
%                    Now supporting 1D images.
% 1 October 2001:    New 'TIGHT' parameter.
% 14 March 2002:     Using the 'resize' callback to set the axis position
%                    and limits. Fixed small bug in parameter parsing.
% 18 February 2005:  Maximum figure size was screensize*0.8.
% 22 September 2006: Added 'MAX' option. Fixed bug in 1D window sizing.
% 24 July 2008:      Finally reading the actual figure border sizes. Also
%                    properly moving figure to be inside the screen.
% 18 May 2011:       Added 'INITIAL' option.
% 25 July 2012:      Added 3rd argument to 'TIGHT' option.

