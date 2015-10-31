%READRAWIM   Read image from RAW format file
%
% SYNOPSIS:
%  image_out = readrawim(filename,size,datatype)
%
% PARAMETERS:
%  filename: string with name of file (including extension), optionally with path.
%  size:     array with image dimensions.
%  datatype: string with the name of one of the valid dip_image data type strings
%            (see HELP DIP_IMAGE) or a MATLAB numeric class string.
%
% DEFAULTS:
%  datatype: 'uint8'
%
% NOTES:
%  READRAWIM will attempt to read the requested number of bytes from the given
%  file. If the file has not enough data, an error will be returned. However, if
%  the file has more data, this additional data will simply be ignored.
%
%  If the dimensions and data type given by the user are not correct, the output
%  will be giberish. Consider using any of the existing image file formats to
%  store your images in (e.g. ICS or TIFF).

% (C) Copyright 2011, Cris Luengo
% Centre for Image Analysis, Uppsala, Sweden.
%
% Cris Luengo, August 2011.

function out = readrawim(varargin)

types = struct('name',       {'uint8','uint16','uint32','sint8','sint16','sint32','sfloat','dfloat'},...
               'description',{'8-bit unsigned integer','16-bit unsigned integer','32-bit unsigned integer',...
                              '8-bit signed integer','16-bit signed integer','32-bit signed integer',...
                              '32-bit floating point','64-bit floating point'});

d = struct('menu','File I/O',...
           'display','Read image from RAW file',...
           'inparams',struct('name',       {'filename',                'size', 'datatype'},...
                             'description',{'Name of the file to open','Size', 'Data type'},...
                             'type',       {'infile',                  'array','option'},...
                             'dim_check',  {0,                         -1,     0},...
                             'range_check',{'*.*',                     'N+',   types},...
                             'required',   {1,                         1,      0},...
                             'default',    {'trui.ids',                '[256,256]',     'uint8'}...
                            ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = d;
      return
   end
end
%%% aliases for elements in the 'datatype' list.
if nargin>=3 & ischar(varargin{3})
   switch varargin{3}
      case 'uint'
         varargin{3} = 'uint32';
      case 'int8'
         varargin{3} = 'sint8';
      case 'int16'
         varargin{3} = 'sint16';
      case {'int','int32'}
         varargin{3} = 'sint32';
      case {'single','float'}
         varargin{3} = 'sfloat';
      case 'double'
         varargin{3} = 'dfloat';
   end
end
%%%
try
   [filename,sz,dt] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

% Convert DIPimage type string to MATLAB type string
if strcmp(dt,'sfloat')
   dt = 'single';
elseif strcmp(dt,'dfloat')
   dt = 'double';
elseif dt(1)=='s'
   dt = dt(2:end);
end

% Look for the file
[fid,errmsg] = fopen(filename,'rb');
if fid<0 & isempty(fileparts(filename)) % The file name has no path.
   p = convertpath(dipgetpref('imagefilepath'));
   for ii=1:length(p)
      [fid,errmsg] = fopen(fullfile(p{ii},filename),'rb');
      if fid>0
         break;
      end
   end
end
if fid<0
   error(errmsg);
end

% Read the file
[out,count] = fread(fid,prod(sz),['*',dt]);
fclose(fid);
if count<prod(sz)
   error('Insufficient data in the file to read an image of requested size and data type.');
end
out = dip_image(out);
out = reshape(out,sz);
