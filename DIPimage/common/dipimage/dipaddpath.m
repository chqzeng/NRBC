%DIPADDPATH   Adds a path to be used in the DIPimage GUI
%   DIPADDPATH(PATH) adds directory PATH to both the MATLAB path
%   and the path used by DIPimage when generating the GUI menus.
%
%   Functions in the directory added through this function can
%   shadow (or hide) the functions in DIPimage, because the
%   directory is added to the beginning of the MATLAB path. If
%   the directory was already on the path, it is not moved.
%
%   Notice that the path is not stored from one session to the
%   next. You can add a DIPADDPATH command to your STARTUP file
%   to create a permanent path addition.
%
%   See also: ADDPATH

% (C) Copyright 2009, All rights reserved
%
% Cris Luengo, July 2009.

function menu_out = dipaddpath(d)

if ~ischar(d)
   error('Directory name required (as a string)')
end
if strcmp(d,'DIP_GetParamList')
   menu_out = struct('menu','none');
   return
end
% The MATLAB path
ii = find(strcmp(convertpath(path),d));
if isempty(ii)
   addpath(d,'-begin');
end
% The DIPimage path
p = dipgetpref('CommandFilePath');
ii = find(strcmp(convertpath(p),d));
if isempty(ii)
   p = [p,pathsep,d];
   dipsetpref('CommandFilePath',p);
end
