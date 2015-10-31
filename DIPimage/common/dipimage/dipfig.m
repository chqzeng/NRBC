%DIPFIG   Links a variable name with a figure window
%   DIPFIG A creates a figure window for the variable A. The functional
%   form also accepts other parameters:
%
%   DIPFIG(N,'A') links figure window N with variable name 'A'. It also
%   creates figure window N if it doesn't yet exist.
%
%   DIPFIG(...,POS) puts the (new) figure window at position POS. POS is
%   a 1-by-4 array in the form [left,bottom,width,height], or a 1-by-2
%   array in the form [width,height].
%
%   H = DIPFIG(...) also returns the figure window handle.
%
%   It is possible to link many variables to a single figure window. The
%   last variable send to the display is always the one seen. Note that
%   even the most simple operations cause the variable name to be either
%   ANS or unknown.
%
%   The variable name 'other' is reserved for those variables not associated
%   with a figure window. If more than one figure window is associated
%   with it, they will be used in alternating sequence. Other variable
%   names cannot be associated with more than one figure window.
%
%   DIPFIG is the only way of linking a variable name with a figure window.
%   DIPSHOW(N,A) causes the DIPFIG setting to be overruled, but doesn't link
%   'A' with N.
%
%   DIPFIG -UNLINK unlinks all variables names. This is a reset of the figure
%   handle list.
%
%   H = DIPFIG('-GET','A') returns the handle associated to the variable
%   named 'A'. Returns the handle associated to 'other' if 'A' was not
%   previously registered with DIPFIG, or 0 if no handle is associated to
%   'other'.
%
%   Please note that
%      DIPSHOW(X)
%      H = DIPFIG('-GET','X');
%      COORDS = DIPGETCOORDS(H,1);
%   Need not work (if 'X' is not registered, and 'other' has several handles
%   associated, DIPFIG will return a different handle than that used by DIPSHOW).
%   Instead use the syntax H = DIPSHOW(X).

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000.
% 26 October 2000:   DIPFIG now fills the figure window it creates with an
%                    empty image to set the title bar and the menus.
% 5 April 2001:      This function is now a lot shorter and better because
%                    we added stuff to DIPSHOW we will use here.
% 7 April 2001:      Added the '-GET' syntax.
% 15 April 2001:     Default figure size is 256 by 256 again.
% 22 August 2001:    Using DIPGETPREF to get default figure size.
% 22 September 2001: Not clearing windows created by DIPSHOW.
% 25 November 2007:  As proposed by Cris, removed direct calls to DIPPREFERENCES,
%                    routing these through DIPSETPREF and DIPGETPREF instead. (MvG)
% 12 March 2008:     Using PERSISTENT and MLOCK instead of DIPPREFERENCES.MEX.
% 4 December 2008:   Fixed typo that made it impossible to -unlink.
% 12 August 2014:    Fixes for new graphics in MATLAB 8.4 (R2014b).

