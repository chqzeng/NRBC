%dip_systemdoctor   Checks the DIPlib library installation

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel, February 2005.
% 28 Feb 2005 - Also checking the time stamp of the libraries. (CL)
% 17 Jun 2005 - Added MESSAGE_FROM_DIP__INITIALISE parameter. (MvG)
% 17 Jun 2005 - LOCATION is now INITMEX, with the name of the MEX-file in it. (CL)
%  2 May 2006 - Rewrote small portions of code, added input arg checks and defaults,
%               removed VERSION input, and modified the output. (CL)
% 18 Dec 2007 - Adapted to newest directory structure. (CL)
% 25 Dec 2007 - strfind -> findstr for matlab v5.3 (MvG)
% 18 Nov 2008 - Updated to work on Mac. (CL)
% 13 Aug 2010 - Added a tiny bit of robustness. (CL)

function dip_systemdoctor(initmex,message_from_dip__initialise)

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
[dipbase,mlvname] = fileparts(fileparts(fileparts(dipbase))); % Get the "mlvX_X" name of the directory

dolddscan = 0;
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
      dolddscan = 1;
   end
else
   % Windows settings
   psp = ';';
   soext = '.dll';
   scanpaths = fullfile(matlabroot,'bin');
   if cv(1)==6 | ( cv(1)==7 & cv(2)<4 ) % When did these guys start having 32-bit and 64-bit directories?
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
% if isempty(paths) % This never happens!!!

% Now let's scan for the DIP crap
libdip   = ['libdip',         soext];
libdipio = ['libdipio',       soext];
libdml   = ['libdml_',mlvname,soext];
fnddip   = '';
fnddipio = '';
fnddml   = '';
disp(['   The files ',libdip,', ',libdipio,' and ',libdml,' must be available']);
disp('   on the library search path. Looking for them now:');
for ii=1:length(paths)
   disp(['     Scanning ',paths{ii}]);
   cfile = fullfile(paths{ii},libdip);
   if exist( cfile, 'file' )
      disp(['        Found ',libdip]);
      if isempty(fnddip)
         fnddip = cfile;
      end
   end
   cfile = fullfile(paths{ii},libdipio);
   if exist( cfile, 'file' )
      disp(['        Found ',libdipio]);
      if isempty(fnddipio)
         fnddipio = cfile;
      end
   end
   cfile = fullfile(paths{ii},libdml);
   if exist( cfile, 'file' )
      disp(['        Found ',libdml]);
      if isempty(fnddml)
         fnddml = cfile;
      end
   end
end
disp(' ');

disp('   Summary of Library locations:');
if ~isempty(fnddip)
   dipt = dir(fnddip); dipt = dipt.date;
   disp(['     ',fnddip,' (',dipt,')']);
   dipt = floor(datenum(dipt));
else
   disp(['     ',libdip,' not found']);
   dipt = 0;
end
if ~isempty(fnddipio)
   dipiot = dir(fnddipio); dipiot = dipiot.date;
   disp(['     ',fnddipio,' (',dipiot,')']);
   dipiot = floor(datenum(dipiot));
else
   disp(['     ',libdipio,'  not found']);
   dipiot = 0;
end
if ~isempty(fnddml)
   dmlt = dir(fnddml); dmlt = dmlt.date;
   disp(['     ',fnddml,' (',dmlt,')']);
   dmlt = floor(datenum(dmlt));
else
   disp(['     ',libdml,' not found']);
   dmlt = 0;
end

if nargin<1
   initmex = which('dip__initialise','in','dip_initialise_libs');
end
if ~isempty(initmex)
   initt = dir(initmex); initt = initt.date;
   disp(['     ',initmex,' (',initt,')']);
   initt = floor(datenum(initt));
else
   % This is not expected, though.
   disp(['     ',dip__initialise,' not found']);
   initt = 0;
end

if isempty(fnddip) | isempty(fnddipio) | isempty(fnddml) | isempty(initmex)
   disp(' ');
   disp('   Some or all of the relevant libraries were not found.');
else
   disp(' ');
   disp('   All the relevant libraries were found.');
   if any([dipt,dipiot,dmlt]~=initt)
      disp(' ');
      disp(['   Since the dates on the found libraries and the toolbox functions   ';...
            '   do not match, it is possible that the wrong version of these       ';...
            '   libraries is being used. Please remove the old DIPimage/DIPlib     ';...
            '   files from your system, and make sure the files found come from the';...
            '   correct DIPimage distribution.                                     '])
   end
   if dolddscan
      disp(' ');
      disp(['   Creating a temporary file to do a ldd scan. This may provide you   ';...
            '   with more information or, in the worst case, more information to   ';...
            '   send to us...                                                      ']);
      disp(' ');
      fname = fullfile(tempdir,'dip_tryldd');
      fd = fopen(fname,'w');
      fprintf(fd,'#! /bin/sh\n\n');
      if length(paths)>0
         fprintf(fd,['LD_LIBRARY_PATH="',paths{1},'"\n']);
      end
      for ii=2:length(paths)
         fprintf(fd,['LD_LIBRARY_PATH="$LD_LIBRARY_PATH:',paths{ii},'"\n']);
      end
      fprintf(fd,'export LD_LIBRARY_PATH\n\n');
      fprintf(fd,['ldd ',initmex,'\n']);
      fclose(fd);
      system(['chmod +x ',fname]);
      system([fname,'; exit']);
      delete(fname);
   end
   if nargin>=2 & ~isempty(message_from_dip__initialise)
      disp(' ');
      disp(['   Finally: this is the error message generated by the low-level      ';...
            '   initialisation function:                                           ']);
      disp(['   ',message_from_dip__initialise]);
   end
end
