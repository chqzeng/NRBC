%RAMP   Creates an image with general coordinates
%   RAMP(SIZE,DIM) returns an image of size SIZE with the value of the
%   DIM dimension's coordinate as the pixel values.
%
%   RAMP(A,DIM) is the same as RAMP(SIZE(A),DIM).
%
%   RAMP(...,ORIGIN) allows specifying where the origin is:
%      'left'    the pixel to the left of the true center
%      'right'   the pixel to the right of the true center (default)
%      'true'    the true center, between pixels if required
%      'corner'  the pixel on the upper left corner (indexed at (0,0))
%   Note that the first three are identical if the size is odd.
%
%   RAMP(...,'freq') uses frequency domain coordinates, range=(-0.5,0.5)
%      (not in combination with ORIGIN).
%   RAMP(...,'radfreq') uses frequency domain coordinates, range=(-pi,pi)
%      (not in combination with ORIGIN).
%
%   RAMP(...,'math')  Let the Y coordinate increase upwards instead of
%      downwards.
%   RAMP(...,'mleft') Combines 'left' with 'math'. Also available are:
%      'mright', 'mtrue', 'mcorner', 'mfreq' and 'mradfreq'.
%      In the case of 'mcorner' the origin is moved to the bottom of
%      the image.
%
%   Note that the syntax RAMP(X,Y,Z,...) is illegal, in contrast to
%   the functions XX, YY, etc.

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2001.
% 15 November 2002: added/improved createramp options.

function out = ramp(varargin)
origin = '';
n = [256,256];
dim = 1;
N = nargin;
if N > 0
   if ischar(varargin{N})
      origin = varargin{N};
      if strcmp(origin,'DIP_GetParamList') % Add to menu
         options = struct('name',{'left','right','true','corner','freq','radfreq',...
                                  'mleft','mright','mtrue','mcorner','mfreq','mradfrq'},...
                          'description',{'left of true center','right of true center','true center',...
                                         'top-left corner','frequency domain','frequency domain in radians',...
                                         'left of true center, math mode','right of true center, math mode',...
                                         'true center, math mode','top-left corner, math mode',...
                                         'frequency domain, math mode','frequency domain in radians, math mode'});
         out = struct('menu','Generation',...
                      'display','Ramp',...
                      'inparams',struct('name',       {'sz',         'dim',      'origin'},...
                                        'description',{'Input image','Dimension','Location of origin'},...
                                        'type',       {'image',      'array',    'option'},...
                                        'dim_check',  {0,            0,          0},...
                                        'range_check',{[],           'N+',       options},...
                                        'required',   {0,            0,          0},...
                                        'default',    {'a',          1,          'right'}...
                                       ),...
                      'outparams',struct('name',{'out'},...
                                         'description',{'Output image'},...
                                         'type',{'image'}...
                                        )...
                     );
         return
      end
      N = N-1;
   end
   if N > 2
      error('Too many input parameters.');
   elseif N > 1
      dim = varargin{2};
      if ~isnumeric(dim) | prod(size(dim)) ~= 1 | mod(dim,1)
         error('DIM  must be a scalar integer.')
      end
   end
   if N > 0
      n = varargin{1};
      if isa(n,'dip_image')
         n = size(n);
      elseif isa(n,'dip_image_array')
         error('Input image is an image array.')
      elseif ~isnumeric(n) | isempty(n)
         error('Size vector must be a row vector with integer elements.')
      elseif sum(size(n)>1)>1
         % Treat n as an image
         n = size(dip_image(n));
      end
   end
end
try
   out = createramp(n,dim,origin);
catch
   error(firsterr)
end
