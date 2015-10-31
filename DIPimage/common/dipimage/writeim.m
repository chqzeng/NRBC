%WRITEIM   Write grey-value or color image to file
%
% SYNOPSIS:
%  writeim(image_in,filename,format,compression,physDims)
%
% PARAMETERS:
%  image_in:    image to write to file.
%  filename:    string with name of file, optionally with path and extension.
%  format:      any one string of: 'ICSv1', 'ICSv2', 'TIFF', 'PS', 'EPS', 'CSV',
%               'GIF', 'FLD' or 'JPEG'.
%  compression: 1 or 'yes' to use comression or 0 or 'no' not to. Not all
%               formats support compression. The compression method used is
%               the default for that file type. It is not possible to change
%               the compression method from within this function.
%  physDims:    physical dimensions of the pixels, or pixel aspect ratio.
%               physDims can be a struct with elements
%                      physDims.dimensions         pixel pitch
%                      physDims.origin             coordinates of 0th pixel
%                      physDims.dimensionUnits     distance units
%                      physDims.intensity          grey-value gain
%                      physDims.offset             grey-value offset
%                      physDims.intensityUnit      intensity units
%               but it can also be an array giving the pixel pitch along each axis (the
%               physDims.dimensions part only), in which case the units are arbitrary, or
%               a scalar giving the size along the last dimension with repect to the other
%               dimensions (i.e. dimensions = [1,1,physDims]).
%
% DEFAULTS:
%  format = 'ICSv2'
%  compression = 'yes'
%  physdims = [] (meaning the pixel dimensions are read from the image)
%
% NOTES:
%  In the GUI there is no way of giving a struct as physDims. Therefore the name for
%  this parameter in the GUI is 'Aspect ratio'.
%
%  To get a current list of file formats, use the function DIPIO_GETIMAGEWRITEFORMATS,
%  which also gives a short description of each format.
%
%  Writing certian images to certain file types cause this function to generate
%  some warnings, either because the data is transformed in a non-trivial way or
%  because the resulting TIFF file is not recognized by most TIFF readers. To
%  avoid these warnings do
%     dipsetpref('FileWriteWarning','off')
%
%  Format 'TIF' is an alias for 'TIFF'. Likewise, 'ICS' is an alias for 'ICSv2'.
%
%  Use the function DIPIO_IMAGEWRITE to select the compression method.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2000.
% January 2002:  Changed compression default to 1 (BR)
% February 2002: Removed static list of file formats.
% July 2002:     Allowing color images as input. This function now substitutes WRITECOLORIM.
%                Using new DIPIO_IMAGEWRITECOLOUR function.
%                ICS version 2 is now the default (i.e. the 1-file format).
% November 2003: Give warnings when writing non standard tiff format (BR)
% December 2003: Write 2D bin images as tiff default not ics so that they are read as bin
%                not uint8 (BR)
% January 2004:  Write vector images (BR)
% February 2004: Fixed writing color images with other than two dimensions.
% March 2004:    Added file extension recognition in the filename (BR)
% December 2004: Since ICS now supports binary images, undoing BR's fix of Dec-2003.
% April 2006:    Added 3D tiff writing via Matlab imwrite as uint8 (DB,RH,BR)
% July 2006:     Re-organized a bit (removed call to self). Using 'FileWriteWarning' pref.
%                Added physDims parameter. Using new version of dipio_imagewrite.
% February 2008: Adding pixel dimensions and units to dip_image. (BR)
% 6 March 2008:  Re-enabled the aspect ratio input argument. (CL)
% 13 Sept 2013:  Correctly reporting missing input argument if only 1 argument given. (CL)

function out = writeim(varargin)

frmts = dipio_getimagewriteformats;

% The large number of spaces in the 'description' field for 'format' causes the display of
% the 'frmts' list to be wider. The data in the list is not used to determine the width of
% the controls, only the description is.
d = struct('menu','File I/O',...
   'display','Write image',...
   'inparams',struct('name',{'image_in','filename','format','compression','aspect'},...
      'description',{'Image to write','Name of the file to write','File format','Use compression?','Aspect ratio'},...
      'type',       {'image','outfile','option','boolean','array'},...
      'dim_check',  {0,      0,         0,       0,        -1},...
      'range_check',{[],     '*.*',     frmts,   [],      'R+'},...
      'required',   {1,      1,         0,       0,        0},...
      'default',    {'a',    '',        'icsv2', 1,        []}...
      )...
   );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = d;
      return
   end
end

% Aliases for elements in the 'format' list.
alias = {'tif','tiff'; 'ics','icsv2'; 'ics1','icsv1'; 'ics2','icsv2'};
if nargin>=3 & ~isempty(varargin{3})
  ii = strcmpi(varargin{3},alias(:,1));
  if any(ii)
     varargin{3} = alias{ii,2};
  end
elseif nargin>=2 % test filename on contained extension - only if no file format is given
   ii = find(varargin{2}=='.');
   if ~isempty(ii)
      ext = varargin{2}(ii(end)+1:end);
      ii = strcmpi(ext,alias(:,1));            % aliases for extensions
      if any(ii)
         varargin{3} = alias{ii,2};
      else
         ii = find(strcmpi(ext,{frmts.name})); % extensions in dipio_formats
         if ~isempty(ii)
            varargin{3} = frmts(ii).name;
         end
      end
   end
end

% Storing the physDims structure to allow automatic parsing of the rest.
if nargin>=5 & isstruct(varargin{5})
   physDims = varargin{5};
   varargin{5} = [];
else
   physDims = [];
end

% Parsing the other input arguments
try
   [image_in,filename,format,compression,pd] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if compression
   compression = '';
else
   compression = 'none';
end

% Parsing the PhysDims array
N = ndims(image_in{1});
if ~isempty(pd)
   % "aspect" parameter given.
   if prod(size(pd))==1
      physDims.dimensions = [ones(1,N-1),pd];
      physDims.dimensionUnits = repmat({''},1,N);
   elseif prod(size(pd))==N
      % it's ok!
      physDims.dimensions = pd;
      physDims.dimensionUnits = repmat({''},1,N);
      % we'll leave the units empty.
   else
      error('physDims array of illegal size: should be scalar or of same length as image dimensionality.')
   end
else
   if isempty(physDims)
      % No argument given
      physDims.dimensions = image_in.pixelsize;
      physDims.dimensionUnits = image_in.pixelunits;
   end
end

% If this is an array, either it's a color image or a tensor image.
if isa(image_in,'dip_image_array')
   if iscolor(image_in)
      photometric = colorspace(image_in);
      image_in = array2im(image_in);
      try
         dipio_imagewritecolour(image_in,filename,photometric,physDims,format,compression);
      catch
         error(firsterr)
      end
      return % Color image written, we're done!
   elseif isvector(image_in)
      dim = ndims(image_in{1})+1;
      if dipgetpref('FileWriteWarning')
         warning(['Writing an array of ' num2str(dim-1) ...
                  'D images as one ' num2str(dim)  'D image. ' ...
                  'Use IM2ARRAY to recover the vector image.']);
      end
      image_in = cat(dim,image_in);
   else
      error('Input is an image array.')
   end
end

% TIFF images can have some special modes and methods...
if strcmpi(format,'tiff')
   if ndims(image_in)==3
      if dipgetpref('FileWriteWarning')
         warning('Converting the data to uint8 and writing a sequence of tiffs in one file.');
      end
      if max(image_in) > 255
         image_in = uint8(image_in / (max(image_in)/255));
      else
         image_in = uint8(image_in);
      end
      num_slices = size(image_in,3);    
      imwrite(image_in(:,:,1),filename,'tif','WriteMode','overwrite','Compression','none');
      for ii = 2:num_slices
          imwrite(image_in(:,:,ii),filename,'tif','WriteMode','append','Compression','none');
      end
      return
   end
   if isempty(compression) & dipgetpref('FileWriteWarning')
      warning(['You are writing a ZIP compressed TIFF.' ...
               ' Older image viewers may not be able to read this compression.']);
   end
   if ~any(strcmp(datatype(image_in{1}),{'uint8','bin'})) & dipgetpref('FileWriteWarning')
      warning(['You are writing a ' datatype(image_in{1}) ' TIFF.' ...
               ' This is not supported by most image viewers.'])
   end
end

% This is the grey-value image writing
try
   dipio_imagewrite(image_in,filename,physDims,format,compression);
catch
   error(firsterr)
end
