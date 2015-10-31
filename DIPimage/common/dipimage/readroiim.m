%READROIIM   Read ROI of a grey-value image from file
%
% SYNOPSIS:
%  [out, file_info] = readroiim(filename, sampling, offset, roi, format)
%
% OUTPUT:
%  image_out: the image
%  file_info: additional parameters of the image (if avaiable) returned as a struct,
%             see DIPIO_IMAGEFILEGETINFO for more information.
%
% PARAMETERS:
%  filename: string with name of file, optionally with path and extension.
%  sampling: subsampling factor, integer array
%  offset:   ROI offset, integer array
%  roi:      ROI size, integer array
%  format:   either 'ICS', 'LSM' or 'PIC' or an empty string, which will cause
%            the function to search for the correct type.
%
% DEFAULTS:
%  filename = 'erika.ics'
%  sampling = 4
%  offset = []
%  roi = []
%  format = ''
%
% EXAMPLE:
%  out = readroiim('erika',[2 2],[64 64],[128 128])
%
% This function is useful for large image files, if only a smaller region is
% needed for processing, or to extract a thumbnail from it.


% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% September 2002, Cris Luengo, Bernd Rieger
% 27 September 2004, Put sampling up front, made parameters optional,
%                    and using DIPIO_IMAGEFILEGETINFO to determine image
%                    dimensionality. (CL)
% 9 November 2004,   Corrected bug when the image was found on the path.
% September 2006: added second output argument,  output of dipio_imagefilegetinfo (BR)

function varargout = readroiim(varargin)

frmts = dipio_getimagereadformats;
ICSi = find(strcmp({frmts.name},'ICS'));
LSMi = find(strcmp({frmts.name},'LSM'));
PICi = find(strcmp({frmts.name},'PIC'));
frmts = frmts([ICSi,LSMi,PICi]);
frmts = [struct('name','','description','Any type'),frmts];

d = struct('menu','File I/O',...
   'display','Read ROI of image',...
   'inparams',struct('name',{'filename','sampling','offset','roi','format'},...
     'description',{'Name of the file to open','Sampling','ROI offset','ROI size','File format'},...
     'type',       {'infile','array','array','array','option'},...
     'dim_check',  {0,-1,-1,-1,0},...
     'range_check',{'*.*','R+','R+','R+', frmts},...
     'required',   {1,0,0,0,0},...
     'default',    {'erika.ics',4,[],[],''}...
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

try
   [filename,sampling,offset,roi,format] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

% OFFSET, ROI and SAMPLING should be vectors with 0, 1 or more elements.
if ~isempty(offset) & prod(size(offset))~=length(offset)
   error('OFFSET should be a vector with 0, 1 or NDIMS elements.')
end
if ~isempty(roi) & prod(size(roi))~=length(roi)
   error('ROI should be a vector with 0, 1 or NDIMS elements.')
end
if ~isempty(sampling) & prod(size(sampling))~=length(sampling)
   error('SAMPLING should be a vector with 0, 1 or NDIMS elements.')
end

foundfile = 0;
try
   image_info = dipio_imagefilegetinfo(filename,format,1);
catch
   status = dipio_filestatus(lasterr);
   if status == 0
      error(firsterr)
   end
   image_info = [];
   if status == 1
      foundfile = 1;
   end
end
if isempty(image_info) & isempty(fileparts(filename)) % The file name has no path.
   p = convertpath(dipgetpref('imagefilepath'));
   for ii=1:length(p)
      fname = fullfile(p{ii},filename);
      try
         image_info = dipio_imagefilegetinfo(fname,format,1);
      catch
         status = dipio_filestatus(lasterr);
         if status == 0
            error(firsterr)
         end
         image_info = [];
         if status == 1
            foundfile = 1;
         end
      end
      if ~isempty(image_info)
         filename = fname;
         break;
      end
   end
end
if isempty(image_info)
   if ~foundfile
      error('File not found.')
   end
   error('File type not recognized')
end
if isequal(image_info.photometric,'gray')
   imsz = image_info.size;
else
   imsz = image_info.size(1:end-1);
end
ndims = length(imsz);
if length(offset)==1
   offset = repmat(offset,1,ndims);
elseif ~isempty(offset) & length(offset)~=ndims
   error('OFFSET should be a vector with 0, 1 or NDIMS elements.')
end
if length(roi)==1
   roi = repmat(roi,1,ndims);
elseif ~isempty(roi) & length(roi)~=ndims
   error('ROI should be a vector with 0, 1 or NDIMS elements.')
end
if length(sampling)==1
   sampling = repmat(sampling,1,ndims);
elseif ~isempty(sampling) & length(sampling)~=ndims
   error('SAMPLING should be a vector with 0, 1 or NDIMS elements.')
end
varargout{1} = dipio_imagereadroi(filename,offset,roi,sampling,format,1);
varargout{2} = image_info;
