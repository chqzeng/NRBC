%dip_initialise_libs   Initialises the DIPlib library
%   DIP_INITIALISE_LIBS must be called before using any of the DIPlib
%   functions. When DIPlib is no longer needed, a call to
%   DIP_EXIT will remove DIPlib from memory.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2000.
% 19 April 2001: The error message is more helpful now in case of
%                wrong installation.
% 30 May 2004: Renamed the private MEX-file dip__initialise to avoid
%              confusing problems with dip_initialise_libs.m .
% 28 Feb 2005: Removed the stupid MATLAB 5.3 required message, since
%              this is actually tested for and returns an explicit
%              message in this case. (MVG)
% 28 Feb 2005: This Microsoft-style of error reporting must cease. I am
%              adding some (hopefully) more helpful information. (MVG)
% 28 Feb 2005: Inspired by Mike's additions, also adding a check for
%              the existance of dip__initialise. (CL)
%  2 May 2006: Extended the error message given if dip__initialise does
%              not exist, and reformatted some of the output. (CL)
%  9 Dec 2007: Renamed to DIP_INITIALISE_LIBS. (MvG)
% 18 Dec 2007: Moved test for MATLAB 5.3 to new DIP_INITIALISE. (CL)

function dip_initialise_libs(mode)

try
   dip__initialise(1);
catch
   if exist('dip__initialise')~=3
      disp(' ')
      disp(['   Initialisation of DIPlib failed because of a wrong installation.     ';...
            '   Either not all files were extracted from the distribution properly,  ';...
            '   or the distribution was built for a different operating system,      ';...
            '   architecture and/or MATLAB version.                                  '])
      disp(' ')
      disp(['   Please read the manual for more information on installing this       ';...
            '   toolbox. It can be found at:                                         ';...
            '   http://www.diplib.org/documentation/dipimage_user_manual.pdf         '])
      disp(' ')
      disp(' ')
      error('Initialisation of DIPlib failed.')
   elseif ~isempty(findstr(lasterr,'This version of DIPlib has expired.'))
      disp(' ')
      disp(' ')
      disp(['   This version of DIPimage has expired. Please visit:';...
            '   http://www.diplib.org                              ';...
            '   to obtain a new version.                           '])
      disp(' ')
      disp(' ')
      error('DIPlib has expired.')
   else
      disp(' ')
      disp(['   Initialisation of DIPlib failed. The most probable cause is incorrect';...
            '   installation. Please make sure that the DIPimage distribution you    ';...
            '   have is compatible with your operating system, architecture and/or   ';...
            '   MATLAB version. What follows is a diagnostic tool that should help   ';...
            '   debugging your installation:                                         ']);
      disp(' ')
      dip_systemdoctor(which('dip__initialise'),lasterr);
      disp(' ')
      disp(['   Please read the manual for more information on installing this       ';...
            '   toolbox. It can be found at:                                         ';...
            '   http://www.diplib.org/documentation/dipimage_user_manual.pdf         '])
      disp(' ')
      disp(' ')
      error('Initialisation of DIPlib failed.')
   end
end

if nargin == 1 & ischar(mode) & strcmpi(mode,'silent')
   return
end

dipInfo = dip_getlibraryinformation;
fprintf('\n%s %s (%s - %s [on %s])\n',dipInfo.name,dipInfo.version,dipInfo.date,...
        dipInfo.type,dipInfo.architecture);
fprintf('    %s\n',dipInfo.description);
fprintf('    %s\n',dipInfo.copyright);
fprintf('    %s\n\n',dipInfo.contact);

dipInfo = dipio_getlibraryinformation;
fprintf('\n%s %s (%s - %s)\n',dipInfo.name,dipInfo.version,dipInfo.date,dipInfo.type);
fprintf('    %s\n',dipInfo.description);
fprintf('    %s\n',dipInfo.copyright);
fprintf('    %s\n\n',dipInfo.contact);
