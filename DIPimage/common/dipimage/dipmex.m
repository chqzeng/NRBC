%DIPMEX   Compile a MEX-file that uses DIPlib
%
% SYNOPSIS:
%  dipmex filename.c
%  dipmex filename.c extrasource.c /path/lib/linkalib.a -I/path/include
%  dipmex('filename.c','extrasource.c',...)
%
%  You can add any option you can pass to the command MEX. This
%  function simply calls MEX with the given options and adds options
%  to link in the DIPlib libraries and DIP/MEX interface. The first
%  source file name given will be the name for the resulting MEX-file,
%  unless an "-output" argument is supplied.
%
% NOTE:
%  This function uses the MEX function, which first needs to
%  be configured by
%     mex -setup

% Cris Luengo, July 2004.
% 24 February 2005: Added Win32 compilation
% 13 July 2007:     Defining DML_HAS_MWSIZE for newer MATLAB versions.
% 5 January 2008:   Changes to work with new DML naming.
% 4 June 2008:      Added to DIPimage toolbox.
% 14 May 2009:      Allowing multiple input arguments.
% 17 December 2009: Using new function MATLABVER_GE.
% 12 October 2011:  Adding the current directory to the include path.

function dipmex(varargin)
if nargin<1 | any(~cellfun('isclass',varargin,'char'))
   error('filename expected');
end
dml = dip_dmllibfile;
[dippath,dml] = fileparts(dml);
dippath = fileparts(dippath);
dml = dml(4:end);
if matlabver_ge([7,3])
   mxopt = '-DDML_HAS_MWSIZE';
else
   mxopt = '-DTHIS_IS_A_ZERO_STATEMENT';
end
if ispc
   mex(varargin{:},fullfile(dippath,'lib',['lib',dml,'.lib']),...
                   fullfile(dippath,'lib','libdipio.lib'),...
                   fullfile(dippath,'lib','libdip.lib'),...
                   ['-I"',fullfile(dippath,'include',''),'"'],...
                   '-DWIN32','-I.',mxopt);
else
   mex(varargin{:},['-l',dml],'-ldipio','-ldip',...
                   ['-L',fullfile(dippath,'lib')],...
                   ['-I',fullfile(dippath,'include')],...
                   '-I.',mxopt);
end
