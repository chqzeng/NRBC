%ACQUIREIM   Read image from a TWAIN source
%
% SYNOPSIS:
%  image_out = acquireim(showui,colorspace)
%
% PARAMETERS:
%  showui: 'yes'/'no' or 1/0, indicating whether to use the source's GUI or not.
%  colorspace: the preferred colorspace to use. Most sources support only one or
%              two. This setting is quite useless if SHOWUI is not set to 'no'.
%
% DEFAULTS:
%  showui = 'yes'
%  colorspace = 'grey'
%
% NOTES:
%  The default TWAIN source is used. To change the default TWAIN source,
%  use the 'Select Source...' menu item in the DIPimage GUI.
%
%  Source setting other than the colorspace are currently not implemented. Use
%  the source's graphical user interface to choose these settings.
%
%  TWAIN is only available under Windows.

% UNDOCUMENTED:
%  ACQUIREIM('SelectSource') shows a dialog box that allows you to select the
%  default TWAIN source. This is a system-wide setting (i.e. it affects other
%  applications as well). This syntax is used by the DIPimage GUI as a response
%  to the 'Select Source...' menu item.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2002.
% 19 September 2007: Fixed bug when the TWAIN MEX-file doesn't exist.

function image_out = acquireim(varargin)

d = struct('menu','File I/O',...
           'display','Acquire image',...
           'inparams',struct('name',       {'showui','colspace'},...
                             'description',{'Show the user interface','Preferred color space'},...
                             'type',       {'boolean','option'},...
                             'dim_check',  {0,0},...
                             'range_check',{0,{'grey','rgb','cmy','cmyk','xyz','lab'}},...
                             'required',   {0,0},...
                             'default',    {'yes','grey'}...
                            ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
notwain = 0;
if exist('twain')~=3
   notwain = 1;
   d.menu = 'none';
end
if nargin == 1 & ischar(varargin{1}) & strcmp(varargin{1},'DIP_GetParamList')
   image_out = d;
   return
end
if notwain
   error ('TWAIN functionality not available. Sorry!')
end

if nargin == 1 & ischar(varargin{1}) & strcmpi(varargin{1},'SelectSource')
   twain('selectsource')
   return
end

try
   [showui,colspace] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

try
   if showui
      [image_out,col] = twain('colorspace',colspace);
   else
      [image_out,col] = twain('showui','no','colorspace',colspace);
   end
catch
   error(firsterr)
end
if ndims(image_out)>2
   image_out = joinchannels(col,image_out);
else
   image_out = dip_image(image_out);
end
