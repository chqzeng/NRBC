%dip_dmllibfile   Returns the name of the dmllib.so file to link to.
%   P = DIP_DMLLIBFILE returns the name of the DML library file you need
%   to link your DIPlib MEX-files to.
%
%   [P,DML,SOEXT] = FILEPARTS(P) retuns in P the path to the DIPlib
%   library files and in DML the name of the DML library file currently
%   being used. SOEXT will be '.so' under UNIX and '.dll' under Windows.
%
%   Create your MEX-files that link with DIPlib using:
%   MEX('fname.c',['-L',P],['-I',fullfile(P,'..','include')],'-ldip','-ldipio',['-l',DML(4:END)])

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, January 2008, modifed from DIP_SYSTEMDOCTOR
% 22 Nov 2008  - Updated to work on Mac. (CL)

function fnddml = dip_dmllibfile

cv = version;
ix = find(cv=='.');
if length(ix)>1
   cv = cv(1:ix(2)-1);
elseif length(ix)<1
   cv = [cv,'.0'];
end
cv = sscanf(cv,'%d.%d');

% Get the base directory
if ( cv(1)>6 ) | ( cv(1)==6 & cv(2)>=5 )  % >= 6.5
   dipbase = mfilename('fullpath');
else
   dipbase = which(mfilename);
end
[dipbase,mlvname] = fileparts(fileparts(fileparts(dipbase))); % Get the "mlv_X_X" name of the directory

% Get the SO/DLL search paths
if isunix
   % Standard Unix settings, ok for Linux and Solaris, slightly different for Mac.
   psp = ':';
   try
      m = ismac;
   catch
      m = 0;
   end
   if m
      soext = '.dylib';
      scanpaths = getenv('DYLD_LIBRARY_PATH');
   else
      soext = '.so';
      scanpaths = getenv('LD_LIBRARY_PATH');
   end
else
   % Windows settings
   psp = ';';
   soext = '.dll';
   scanpaths = fullfile(matlabroot,'bin');
   if cv(1)==6 | ( cv(1)==7 & cv(1)<4 ) % When did these guys start having 32-bit and 64-bit directories?
      scanpaths = fullfile(scanpaths,'win32');
   end
   envpath = getenv('PATH');
   if ~isempty(envpath)
      scanpaths = [scanpaths,psp,envpath];
   end
end

% Make a cell array of the path elements...
pathix = [0,find(scanpaths==psp),length(scanpaths)+1];
paths = cell(length(pathix)-1,1);
for ii=1:length(paths)
   paths{ii} = scanpaths(pathix(ii)+1:pathix(ii+1)-1);
end

% Now let's scan for the DML library file
libdml = ['libdml_',mlvname,soext];
fnddml = '';
for ii=1:length(paths)
   t = fullfile(paths{ii},libdml);
   if exist(t,'file')
      fnddml = t;
      break;
   end
end
if isempty(fnddml)
   error(['Could not locate the file ',libdml,'.'])
end
