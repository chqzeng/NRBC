%BORDER = DIPFIG_GETBORDERSIZE(FIGH)
%    Returns the size in pixels of the decorations around figure FIGH.
%    BORDER = [LEFT,BOTTOM,RIGTH,TOP] is the 4 measures of the borders
%    and menu bars and so on. These are the number of pixels used around
%    the area given by the figure's 'Position' property.
%
%    For older versions of MATLAB (5, 6 and 6.1) the values returned
%    are constants defined in this file. Feel free to edit them to
%    match your system.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, 24 July 2008.
% 17 December 2009: Using new function MATLABVER_GE.

function border = dipfig_getbordersize(figh)
if matlabver_ge([6,5])
   border = get(figh,'outerposition')-get(figh,'position');
   border(1:2) = -border(1:2);
else
   border = [ 10, 10, 10, 60 ];
end
