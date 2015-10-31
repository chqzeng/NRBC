%DIPPROJECTION   Calculates the max/sum projection along the not visible axis for 3D
%   DIPPROJECTION(H,PROJ)
%
%   H, the figure window handle, can be left out. It will default to
%   the current figure.
%   
%   PROJ: 'max','sum' 
%
%   The projection is displayed in a new window. For 4D images the projection is
%   done along the time axis if a spatial only slice is displayed, otherwise first
%   not visible dimension is used. For color images the operation is performed per channel
% 
%   See also DIPSHOW, DIP_IMAGE/MAX, DIP_IMAGE/SUM

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, July 2004
% Feb 2005:       Added color images.
% 11 August 2014: Fix for new graphics in MATLAB 8.4 (R2014b).

