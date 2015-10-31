%DIPCLF   Clears figure windows created by DIPSHOW
%   DIPCLF clears all figure windows created by DIPSHOW, without
%   changing their position or size.
%
%   DIPCLF(H) clears the figure window with handle H. If H is zero,
%   clears all figure windows. H can be a numeric array [H1,H2,H3]
%   or a cell array {H1,H2,'varname1','varname2'} or just a variable
%   name. The window associated with that name is cleared.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.
% 9 November 2000:   We now display an empty image into the figure window.
% 5 April 2001:      Using new, undocumented DIPSHOW option.
% 20 August 2001:    Added optional argument to clear only one window.
% 16-26 August 2001: Changed DIPSHOW. This function changes accordingly.
% 8 March 2002:      Added 'var' and {'var',h'} syntaxes.
% 11 August 2014:    Fix for new graphics in MATLAB 8.4 (R2014b).

