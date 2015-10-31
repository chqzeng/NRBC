%READIM   Read image from file
%
% SYNOPSIS:
%  [image_out, file_info] = readim(filename,format)
%
% OUTPUT:
%  image_out: the image
%  file_info: additional parameters of the image (if avaiable) returned as a
%             struct, see DIPIO_IMAGEFILEGETINFO for more information.
%
% PARAMETERS:
%  filename: string with name of file, optionally with path and extension.
%  format:   string with any of: 'ICS', 'LSM', 'TIFF', 'GIF', 'CSV' or 'PIC',
%            or an empty string, which will cause the function to search for
%            the correct type.
%
% DEFAULTS:
%  filename = 'erika.ics'
%  format = ''
%
% NOTES:
%  Color images will now automatically be read as color. The use of READCOLORIM
%  is not longer required. Use READGRAYIM for old functionality.
%
%  To get a current list of file formats, use the function
%  DIPIO_GETIMAGEREADFORMATS, which also gives a short description of each
%  format.
%
%  For JPEG, BMP, PNG and other such files not recognized by dipIO, leave
%  FORMAT empty. This will allow READIM to call IMREAD (a MATLAB function)
%  that does recognize these files.
%
%  Some LSM files will not be read in properly. Use the function FIXLSMFILE
%  to fix a large class of these. For others - uh, well.
%
%  To read multi-page TIFF files use READTIMESERIES or the low-level function
%  DIPIO_IMAGEREADTIFF.
%
%  For access to even more file formats, you can download the file
%  'loci_tools.jar' from
%      http://www.loci.wisc.edu/bio-formats/downloads
%  Get a version created after August 12, 2010 (release 4.2.1 or later).
%  Put the file in <dip>/common/dipimage/private/ (the 'private' subdirectory
%  of the directory that contains this function, use WHICH READIM to find out
%  the full path). Java must be enabled for this to work. Images read through
%  the Bio-Formats library are always grey-value images, color channels are an
%  additional dimension of the image. The file_info structure is slightly
%  different: fileInfo.sigbits is set according to the data type and doesn't
%  actually indicate bit depth, and fileInfo.history contains a cell array
%  with setting names in the first column and setting values in the second.

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2000.
% 17 December 2001: Using MATLAB's IMREAD if dipIO cannot read the file.
% February 2002:    Removed static list of file formats.
% September 2006:   Added second output argument,  output of dipio_imagefilegetinfo (BR)
% September 2006:   Integrated readcolorim into readim (BR)
% December 2006:    Fixed bug with colormap after calling IMREAD. (CL)
% February 2008:    Adding pixel dimensions and units to dip_image. (BR)
% 5 March 2008:     Bug fix in pixel dimension addition. (CL)
% 5 January 2009:   Added link to Bio-Formats and restructured code. (CL)
% 3 June 2010:      Added scaling for png files with sBit (BR)
% 13 August 2010:   Updated link to Bio-Formats, it's more efficient now. (CL)
% 15 May 2012:      Now reads multiple images from .lif files/Bio-Formats (BR)

function varargout = readim(varargin)

frmts = [struct('name','','description','Any type'),dipio_getimagereadformats];

d = struct('menu','File I/O',...
           'display','Read image',...
           'inparams',struct('name',       {'filename',                'format'},...
                             'description',{'Name of the file to open','File format'},...
                             'type',       {'infile',                  'option'},...
                             'dim_check',  {0,                         0},...
                             'range_check',{'*.*',                     frmts},...
                             'required',   {0,                         0},...
                             'default',    {'erika.ics',               ''}...
                            ),...
           'outparams',struct('name',{'image_out',''},...
                              'description',{'Output image','Image Parameters'},...
                              'type',{'image','array'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      varargout{1} = d;
      return
   end
end
%%% aliases for elements in the 'format' list.
if nargin>=2 & ischar(varargin{2})
   if strcmpi(varargin{2},'tif')
      varargin{2} = 'tiff';
   end
end
%%%
try
   [filename,format] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

foundfile = 0;
try
   status = [];
   [varargout{1},fileInfo] = dipread(filename,format);
catch
   if isempty(status) | status == 0
      error(firsterr)
   end
   varargout{1} = [];
   if status == 1
      foundfile = 1;
   end
end
if isempty(varargout{1}) & isempty(fileparts(filename)) % The file name has no path.
   p = convertpath(dipgetpref('imagefilepath'));
   for ii=1:length(p)
      try
         status = [];
         [varargout{1},fileInfo] = dipread(fullfile(p{ii},filename),format);
      catch
         if isempty(status) | status == 0
            error(firsterr)
         end
         varargout{1} = [];
         if status == 1
            foundfile = 1;
         end
      end
      if ~isempty(varargout{1})
         break;
      end
   end
end
if isempty(varargout{1})
   if ~foundfile
      error(['File "' filename  '" not found.'])
   end
   if ~isempty(format)
      error(['File type not recognized (leave ''format'' empty to allow IMREAD to be called).'])
   end
   try
      varargout{1} = mlread(filename);
   catch
      %try
         [varargout{1},fileInfo] = bfread(filename);
      %catch
      %   error('File type not recognized.')
      %end
   end
end

if exist('fileInfo')
   varargout{2} = fileInfo;
else
   varargout{2} = [];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read an image using DIPlib's ImageReadColour()
function [image,fileInfo] = dipread(filename,format)

try
   [image,photometric] = dipio_imagereadcolour(filename,format,1);
catch
   assignin('caller','status',dipio_filestatus(lasterr));
   error(lasterr)
end
if ~strcmp(photometric,'gray')
   image = joinchannels(photometric,image);
end
fileInfo = dipio_imagefilegetinfo(filename,format,1);
n = ndims(image{1}); % If it's a color image, physDims below usually contains one more element.
image.pixelsize = fileInfo.physDims.dimensions(1:n);
image.pixelunits = fileInfo.physDims.dimensionUnits(1:n);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read an image using MATLAB's IMREAD
function image = mlread(fname)

[image,map] = imread(fname);
if ~isempty(map)
   map = single(map*255);
   image = lut(image,map);
elseif ndims(image)==3
   if isa(image,'double')
      image = image*255;
   end
   image = dip_image(image);
   image = joinchannels('RGB',image);
else
   image = dip_image(image);
end

% reading .png that set the sBit are not correctly scaled
% by matlab reader at least in versions <=2008b
% e.g. exported by LabView
[bla,tmp,ext] = fileparts(fname);
if strcmp(ext,'.png')
   try
      fp = fopen(fname);
      header=fscanf(fp,'%c',200);
      fclose(fp);

      indx = findstr(header,'sBIT');
      bd = uint8(header(indx+4));
      if isnumeric(bd) && bd >0
         image = floor(image/(2^bd)); %equal to bit shift by bd
      end
   catch
   end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read an image using the Bio-Formats library
function [imageCELL,fileInfoCELL] = bfread(fname)

% See if 'loci_tools.jar' is on the Java Class Path
p = javaclasspath('-all');
p = regexp(p,'loci_tools\.jar$','once');
p = [p{:}];
if isempty(p)
   locifile = fullfile(fileparts(mfilename('fullpath')),'private','loci_tools.jar');
   if ~exist(locifile,'file')
      error('Bio-Formats JAR file not installed.')
   end
   if dipgetpref('DebugMode')
      warning('All your global variables are cleared! Due to "javaaddpath" very strange design choice.')
   end
   javaaddpath(locifile);
% else: we don't want to change the Java Class Path if not necessary.
end

% Create & initialize a useful reader object
r = loci.formats.ChannelFiller();
r = loci.formats.ChannelSeparator(r);
r.setId(fname);
nSeries = r.getSeriesCount;
fprintf('Number of series %d\n',nSeries);

%% series nummer
imageCELL= cell(nSeries,1);
fileInfoCELL = cell(nSeries,1);
for imageseries = 0:nSeries-1
   fprintf(' Reading series %d\n',imageseries)
   r.setSeries(imageseries); 

   % Find out info on the image
   sz = [r.getSizeX(),r.getSizeY()];
   imsz = [sz(2),sz(1),r.getSizeZ(),r.getSizeC(),r.getSizeT()];
   pixelType = r.getPixelType();
   bpp = loci.formats.FormatTools.getBytesPerPixel(pixelType);
   fp = loci.formats.FormatTools.isFloatingPoint(pixelType);
   sgn = loci.formats.FormatTools.isSigned(pixelType);
   little = r.isLittleEndian();
   numImages = r.getImageCount();
   if numImages ~= prod(imsz(3:end))
      error('Assertion failed: number of planes in the image file not as expected!')
   end
   switch bpp
      case 1
         cls = 'int8';
      case 2
         cls = 'int16';
      case 4
         if fp
            cls = 'single';
         else
            cls = 'int32';
         end
      case 8
         if fp
            cls = 'double';
         else
            error('Unexpected number of bytes per pixel');
         end
      otherwise
         error('Unexpected number of bytes per pixel');
   end
   if ~sgn & cls(1)=='i'
      cls = ['u',cls];
   end

   % Allocate space and read all image planes
   image = zeros(imsz,cls);
   for ii = 0:numImages-1
      plane = r.openBytes(ii);
      arr = loci.common.DataTools.makeDataArray2D(plane,bpp,fp,little,sz(2));
      pos = r.getZCTCoords(ii);
      if ~sgn
         % Unsigned types are cast to signed types in Java...
         %arr = di_signtounsign(arr); %crashes matlab (BR)

         %this does not change the data - no copying of the data
         %but does only work on vectors not arrays!
         %arr = typecast(arr,'uint16');

         %this copies the data
         s = ['image(:,:,pos(1)+1,pos(2)+1,pos(3)+1)=' cls '(arr);'];
         eval(s);
      end
      image(:,:,pos(1)+1,pos(2)+1,pos(3)+1) = arr;
      %fprintf('(%d) %d %d %d\n',ii,pos);
   end

   % Convert data to a dip_image object
   image = dip_image(image);
   image = expanddim(image,5);
      % OR: image = dip_image('trust_me',image,cls,5);

   % Try to find pixel sizes
   ht = r.getMetadata();
   if ht.containsKey('Scale Factor for X')
      image.pixelsize(1) = str2double(ht.get('Scale Factor for X'));
      image.pixelunits(1) = 'micron';
   end
   if ht.containsKey('Scale Factor for Y')
      image.pixelsize(2) = str2double(ht.get('Scale Factor for Y'));
      image.pixelunits(2) = 'micron';
   end
   if ht.containsKey('Scale Factor for Z')
      image.pixelsize(3) = str2double(ht.get('Scale Factor for Z'));
      image.pixelunits(3) = 'micron';
   end
   image.pixelsize(4) = 0;       % This is the color dimension.
   image.pixelunits(4) = 'none'; % Time dimension (5) we leave as 1px.

   % Remove unused dimensions
   image = squeeze(image);

   % Extract metadata table
   sz = ht.size;
   keys = ht.keys;
   metadata = cell(sz,2);
   for ii=1:sz;
      k = keys.next;
      metadata{ii,1} = k;
      metadata{ii,2} = ht.get(k);
   end

   % Fill in the FILEINFO structure
   fileInfo.filename = fname;
   fileInfo.filetype = '';
   fileInfo.size = imsize(image);
   fileInfo.datatype = datatype(image);
   fileInfo.photometric = 'gray';
   fileInfo.physDims.dimensions = image.pixelsize;
   fileInfo.physDims.origin = image.pixelsize*0;
   fileInfo.physDims.dimensionUnits = image.pixelunits;
   fileInfo.physDims.intensity = 1;
   fileInfo.physDims.offset = 0;
   fileInfo.physDims.intensityUnit = 'relative';
   fileInfo.numberOfImages = 1;
   switch fileInfo.datatype
      case {'uint8','sint8'}
         fileInfo.sigbits = 8;
      case {'uint16','sint16'}
         fileInfo.sigbits = 16;
      case {'uint32','sint32'}
         fileInfo.sigbits = 32;
      otherwise
         fileInfo.sigbits = 0;
   end
   fileInfo.history = metadata;
   imageCELL{imageseries+1}=image;
   fileInfoCELL{imageseries+1}=fileInfo;

end
