%DIPDRAWPOLYGON   Interactive polygon drawing tool
%   Allows the user to draw a polygon over an existing image display.
%
% SYNOPSIS:
%   v = dipdrawpolygon(figure_handle)
%
% PARAMETERS:
%   figure_handle: optional, defaults to GCF.
%
% RETURNS
%   v: vertices of polygon
%
%   To create the polygon, use the left mouse button to add vertices.
%   A double-click adds a last vertex and finishes the interaction.
%   'Enter' ends the tool without adding a vertex. To remove vertices,
%   use the 'Backspace' or 'Delete' keys, or the right mouse button.
%   'Esc' aborts the operation (returns an error message). Shift-click
%   will add a vertex constrained to a horizontal or vertical location
%   with respect to the previous vertex.
%
%   Pressing space will switch to the editing mode, where each vertex
%   is converted to a little circle and the user can drag these around
%   to change the polygon. Pressing space again will return the tool
%   to the vertex adding mode.
%
%   It is still possible to use all the menus in the victim figure
%   window, but you won't be able to access any of the tools (like
%   zooming and testing). The regular key-binding is also disabled.
%
%   Note: If you feel the need to interrupt this function with Ctrl-C,
%   you will need to refresh the display (by re-displaying the image
%   or changing the 'Actions' state).
%
%   See also DRAWPOLYGON, DIPSHOW, DIPGETCOORDS, DIPROI.

% (C) Copyright 1999-2014
% Cris Luengo, May 2010
% Adapted from DIPROI
% 11 August 2014: Fix for new graphics in MATLAB 8.4 (R2014b).

