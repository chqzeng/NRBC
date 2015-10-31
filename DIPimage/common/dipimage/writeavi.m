%WRITEAVI   Writes 3D image into an AVI file
%  Writes a 3D grey-value image into an avi movie file, where the z-direction
%  is the time component (only Matlab 6).
%
% SYNOPSIS:
%  writeavi(image_in, filename, fps, comp)
%
% PARAMETERS:
%  image_in: image to write to file.
%  filename: string with name of file, optionally with path and extension.
%  fps:      frames per second to write
%  comp:     compression (only under windows)
%
% DEFAULTS:
%  fps = 15
%  comp = 'Cinepak' under Windows, 'None' elsewhere
%
% NOTE:
%  compression is only available under Windows 
%
% SEE ALSO:
%  writedisplayavi

% (C) Copyright 1999-2005               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, May 2001.
%    MvG - 11 Nov 2002 - Directly writes image data (ignoring display mode).
%          The old (display) version is now available as writedisplayavi.
%    Now supports colour images. That is COLOUR, Cris.
%    BR  - 10 Mar 2004 - changed os determination so that it works  
%    BR  - 11 April 2005 - catch not closing avi when error occurs
  
function out = writeavi(varargin)

if isunix
   compressionopts={'None'};
   compdef = compressionopts{1};
else
   compressionopts={ 'None', 'Indeo3', 'Indeo5', 'Cinepak', 'MSVC', 'RLE' };
   compdef = compressionopts{4};
end
d = struct('menu','File I/O',...
           'display','Write AVI',...
           'inparams',struct('name',       {'in',              'filename',                   'fps',               'compression'       },...
                             'description',{'Image to write',  'Name of the file to write',  'Frames per second', 'Compression method'},...
                             'type',       {'image',           'outfile',                    'array',             'option'            },...
                             'dim_check',  {0,               0,                  0,      0},...
                             'range_check',{[],              '*.*',              'R+',   compressionopts},...
                             'required',   {1,               1,                  0,      0},...
                             'default',    {'a',             '',                 15,    compdef}...
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
   [in,filename,fps,compression] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if iscolor(in)
   if ndims(in{1}) ~= 3
      error('Input image must be 3D.');
   end
   nslices = size(in{1},3)-1;
else
   if ndims(in) ~= 3
      error('Input image must be 3D.');
   end
   nslices = size(in,3)-1;
end

aviobj = avifile(filename,'fps',fps,'compression',compression);
if ~iscolor(in)
   try %this can go wrong depending on the compression and image content
      aviobj.Colormap = gray(256);
   catch
      close(aviobj);
      error(lasterr);
   end
end

for ii=0:nslices
   if iscolor(in)
      imt1 = colorspace( squeeze(in(:,:,ii)), 'RGB' );
      imt2 = newim([size(imt1{1}), 3]);
      imt2(:,:,0) = imt1{1};
      imt2(:,:,1) = imt1{2};
      imt2(:,:,2) = imt1{3};
      aviobj = addframe(aviobj, uint8(imt2));
   else
      aviobj = addframe(aviobj, uint8(squeeze(in(:,:,ii))));
   end
end
aviobj = close(aviobj);
