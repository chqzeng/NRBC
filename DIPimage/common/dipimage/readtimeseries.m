%READTIMESERIES   Reads a series/stack of images from disk in one image.
%
% SYNOPSIS
%  out = readtimeseries(basefilename, extension, range, color, verbose)
%
%  basefilename : File name without the running number or full file name
%  extension    : File extension
%  range        : First and last index to read [first last]
%  color        : Conserve color information? 'no','yes'
%  verbose      : Show diagnostic messages on which files are read
%
% DEFAULTS:
%  extension    : ''
%  range        : []   % All found images are read
%  color        : no
%  verbose      : no
%
% EXAMPLE:
%  In the directory /data/here, there are 16 files:
%     myfile4.tif,myfile5.tif,myfile006.tif,...myfile020.tif
%  out = readtimeseries('/data/here/myfile','tif')  or equivalent
%  out = readtimeseries('/data/here/myfile012.tif') or equivalent
%  out = readtimeseries('/data/here/myfile*.tif')
%
% SEE ALSO:
%  readim
%
% NOTES:
%  For files like myleica_z004_ch01.tif etc. use
%  readtimeseries('myleica_z*_ch01.tif')
%
%  The given file name can have only one wildcard '*'. The directory
%  name or the extension cannot. The wildcard can be anywhere in the
%  name of the file.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
% Bernd Rieger, June 2001.
% March, 2004, renamed D2toD3 to readtimeseries and added more functionality (BR)
% April, 2004, changed filelist to be more flexible, use now find_files
%              instead of num_slices (BR)
% April, 2004, allowing empty range parameter (I'm lazy!). Removed second reading
%              of first input image (Bernd is lazy too!). Provided for the (unlikely)
%              case that the input slices are not RGB. (CL)
% July 2004,   bug fix for readcolor images, changed default to 'tif' (BR)
% July 2004,   filename is browseable (BR)
% September 2004, moved trimming IN to FIND_FILES.M; changed extension parameter to
%                 string, defaulting to '', changed default file name (CL)
% June 2006,   changed global SupressOutput to parameter VERBOSE (CL)
% July 2006,   added support for multiple tiffs in one tiff (BR)
% December 2006, changed readim call due to change in readim/readcolorim (BR)
% March 2007,  added support for 3D tiff file series (BR)
% July 2007,   small bug fix for some 3D tiff files (BR)
% February 2008, rehaul: better overview for reading multiple multi-page TIFF files,
%                removed trick to fool MATLAB into making a larger array, better
%                handling of color images, not using EVAL, etc.
% April 2009,  made faster by avoiding indexing in dip_image object. Improved
%              FIND_FILES to make file selection more flexible. (CL)
% August 2010, using new option in dipio_imagereadtiff to read in all pages of a
%              multi-page TIFF in one go.
% November 2012, recoded reading of timeseries in diplib instead of via matlab,
%                now a lot faster (BR)
% December 2012, couldn't help myself to simplify the code a bit! (CL)
% 23 April 2014, fixed the case where the image files are in colour. (CL)

function out=readtimeseries(varargin)

d = struct('menu','File I/O',...
 'display','Read time series',...
 'inparams',struct('name',       {'in','ext','range','col','verbose'},...
                   'description',{'Base filename','Extension','Range','Conserve color information?','Verbose?'},...
                   'type',       {'infile','string','array','boolean','boolean'},...
                   'dim_check',  {0,0,{[1,2],[]},0,0},...
                   'range_check',{'*.*','','N',[],[]},...
                   'required',   {1,0,0,0,0},...
                   'default',    {'imser','',[],1,0}...
                    ),...
 'outparams',struct('name',{'out'},...
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
try
   [in,ext,range,col,verbose] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if isempty(range)
   range = [0,0];
elseif prod(size(range))~=2
   error('The range parameter must be of the form [start ending]');
end
if range(1) > range(2)
   range = range(end:-1:1);
end

fns = find_files(in,ext,range(1),range(2),verbose);
if isempty(fns)
   fns = {in};
end
M = length(fns);

% Read in the image files
if M==1
   M = dipio_imagefilegetinfo(fns{1},'',0);
   if isempty(M)
      M = 1;
   else
      M = M.numberOfImages;
   end
   if M==1
      if verbose
         disp(['Reading single 2D file ',fns{1},'.']);
      end
      out = readim(fns{1});
   else
      % If the file is not a TIFF, numberOfImages is always 1 -- unless we add new file types!
      if verbose
         disp(['Reading multi-page tiff file ',fns{1},' as 3D image.']);
      end
      [out,colsp] = dipio_imagereadtiff(fns{1},-1);
      if ~strcmp(colsp,'gray')
         out = joinchannels(colsp,out);
      end
   end
else
   if verbose
      disp('Reading the following files:');
      disp(char(fns(:)));
   end
   [out,colsp] = dipio_imagereadcolourseries(fns,'',0);
   if ~isempty(colsp) & ~strcmp(colsp,'gray')
      out = joinchannels(colsp,out);
   end
end
if ~col
   out = colorspace(out,'grey');
end
