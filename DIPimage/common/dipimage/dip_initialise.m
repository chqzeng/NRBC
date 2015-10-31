%DIP_INITIALISE   Initialises the DIPimage toolbox and library
%   Add the directory this function is in to your MATLAB path,
%   then call DIP_INITIALISE.
%
%   dip_initialise('nopathenv') does not add the library path
%   to the environment variable. Do this if you set the library
%   path manually before starting MATLAB, for example if you
%   have your libraries in a non-default place. This option is
%   only effective on Windows, and will be ignored on other
%   platforms.
%
%   dip_initialise('noaliaspath') does not add the directory
%   with aliases for old and renamed functions.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel & Cris Luengo, December 2007.
% 5 January 2008:    Allowing repeated calling of this function, as before.
%                    Added MODE argument.
% 24 March 2009:     Automatically setting the library path, on Windows
%                    with MATLAB >= 7.2.
% 17 December 2009:  Using new function MATLABVER_GE.
% 13 August 2010:    Removing existing diplib directories from PATH.
% 5 September 2011:  Adding 'aliases' directory to MATLAB path.

function dip_initialise(varargin)

dipbase = '';
debug = 0;
mode = '';
setpathenv = 1;
addaliaspath = 1;
matlab_version_extdll_no_longer_supported=[8,0];     % Version of Windows MATLAB that does not understand MEX-files with DLL extension.
   % To work with MATLAB V7.5 (R2007b), MEX-files compiled on any platform with MATLAB versions earlier than V7 (R14) no longer load correctly and must be rebuilt.
matlab_version_old_mex_no_longer_supported=[7,5];    % MATLAB 7.5 no longer supports MEX-files build with MATLAB 6.5 and earlier.
   % In order to work with MATLAB V7.4 (R2007a), MEX-files compiled on Windows (32--bit) platforms with MATLAB R11 or earlier will no longer load correctly and must be recompiled. These files can be compiled with MATLAB R12 or later.
matlab_version_win_very_old_mex_not_supported=[7,4]; % MATLAB 7.4 on Windows no longer supports MEX-files build with MATLAB 5.3 and earlier.
matlab_version_lowest_supported=[5,3];               % DIPimage works with MATLAB starting at version 5.3.
matlab_version_has_mfilename=[6,5];                  % MFILENAME supports the 'fullpath' argument since MATLAB 6.5.
matlab_version_has_setenv=[7,2];                     % SETENV function new to MATLAB 7.2.

if ~matlabver_ge(matlab_version_lowest_supported)
   error('MATLAB 5.3 (Release 11) or later required');
end

for ii=1:nargin
   if ~ischar(varargin{ii})
      error('Illegal input to DIP_INITIALISE: string expected');
   else
      if strcmp(varargin{ii},'debug')
         debug = 1;
      elseif strcmp(varargin{ii},'silent')
         mode = 'silent';
      elseif strcmp(varargin{ii},'nopathenv')
         setpathenv = 0;
      elseif strcmp(varargin{ii},'noaliaspath')
         addaliaspath = 0;
      else
         dipbase = varargin{ii};
      end
   end
end

if exist('dip_initialise_libs')==2
   % Apparently this file already ran!
   % Or -- worse -- the user added paths that (s)he shouldn't.
   try
      dip_exit
   end
   p = which('-all','dip_initialise_libs'); % This is the common/mlvX_X/diplib/ directory
   if ischar(p); p = {p}; end
   p2 = which('-all','di_forcebin');        % This is the common/mlvX_X/dipimage_mex/ directory
   if ischar(p2); p2 = {p2}; end
   p = [p;p2];
   for ii=1:length(p)
      rmpath(fileparts(p{ii}));
   end
end

% Get the MATLAB version number
cv = matlabver_ge([]);

% Get the base directory
if isempty(dipbase)
   if vnge(cv,matlab_version_has_mfilename)
      dipbase = mfilename('fullpath');
   else
      dipbase = which(mfilename);
   end
   dipbase = fileparts(fileparts(dipbase)); % remove M-file name and go up a directory.
else
   % test to see if the user is being truthful
   while dipbase(end)==filesep
      dipbase(end) = [];
   end
   tf = fullfile(dipbase,'dipimage','dip_initialise.m');
   if ~exist(tf,'file')
      error('Illegal input to DIP_INITIALISE: path does not point to the DIPimage base directory.')
   end
end

% Find the library search path
if ~vnge(cv,matlab_version_has_setenv)
   setpathenv = 0;
end
if isunix
   setpathenv = 0;
end
if setpathenv
   libpath = fileparts(dipbase);
   switch computer
      case 'PCWIN'
         libpath = fullfile(libpath,'win32','lib');
      case 'PCWIN64'
         libpath = fullfile(libpath,'win64','lib');
      otherwise
         % This should not happen.
         error('Unsupported platform!')
   end
   envvar = 'PATH';
   envsep = ';';
end

% Find the directory compiled with the latest version of MATLAB that
% is equal or older than this version.
vds = dir(fullfile(dipbase,'mlv*'));
vds = {vds([vds.isdir]).name};
exts={mexext};
if strcmp(mexext,'mexw32') & ~vnge(cv,matlab_version_extdll_no_longer_supported)
   exts{2}='dll';
end
for ii=1:length(vds)
   candidate = [-1,0]; % not a good directory!
   % Test to see if the version directory contains MEX-files for this platform & version.
   for mi=1:length(exts)
      if exist(fullfile(dipbase,vds{ii},'dipimage_mex',['di_forcebin.',exts{mi}]),'file')
         candidate = sscanf(vds{ii},'mlv%d_%d');
         break;
      end
   end
   % If this is MATLAB version >= 7.5, then discard any directories that are < 7.0.
   if vnge(cv,matlab_version_old_mex_no_longer_supported) & ~vnge(candidate,[7,0])
      %candidate = [-1,0]; % BOLLOCKS! It works for me!!!
   end
   % If this is MATLAB version >= 7.4 on Windows, then discard any directories that are < 6.0.
   if ~isunix & vnge(cv,matlab_version_win_very_old_mex_not_supported) & ~vnge(candidate,[6,0])
      candidate = [-1,0];
   end
   vds{ii}=candidate;
end
lv = [0;0]; % initialise to unusable number
for ii=1:length(vds)
   if vnge(vds{ii},lv) & vnge(cv,vds{ii})
      lv = vds{ii};
   end
end
if all(lv==0)
   error('DIPimage does not currently support your version of MATLAB on your platform. Please see http://www.diplib.org/')
end
vdir = sprintf('mlv%d_%d',lv);

% Add paths and initialise DIPlib libraries
if setpathenv
   setenv(envvar,[libpath,envsep,getenv(envvar)]);
end
if addaliaspath   
   addpath(fullfile(dipbase,'dipimage','aliases'));
end
addpath(fullfile(dipbase,vdir,'dipimage_mex'));
if debug
   addpath(fullfile(dipbase,vdir,'diplib_dbg'));
else
   addpath(fullfile(dipbase,vdir,'diplib'));
end
dip_initialise_libs(mode);
dipsetpref('CommandFilePath',fullfile(dipbase,vdir,'dipimage_mex'));


function r = vnge(a,b) % >=
r = 0;
if ( a(1)>b(1) ) | ( a(1)==b(1) & a(2)>=b(2) )
   r = 1;
end
