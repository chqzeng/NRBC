%YY1   Creates a one-dimensional image with Y coordinates
%   YY1(M,N,P,...) or YY1([M,N,P,...]) returns an image of size
%   M-by-N-by-P-by-... with the value of the Y-coordinate of each
%   pixel as the pixel values.
%
%   YY1(A) is the same as YY1(SIZE(A)).
%
%   YY1(...,ORIGIN) allows specifying where the origin is:
%      'left'    the pixel to the left of the true center
%      'right'   the pixel to the right of the true center (default)
%      'true'    the true center, between pixels if required
%      'corner'  the pixel on the upper left corner (indexed at (0,0))
%   Note that the first three are identical if the size is odd.
%
%   YY1(...,'freq') uses frequency domain coordinates, range=(-0.5,0.5)
%      (not in combination with ORIGIN).
%   YY1(...,'radfreq') uses frequency domain coordinates, range=(-pi,pi)
%      (not in combination with ORIGIN).
%
%   YY1(...,'math')  Let the Y coordinate increase upwards instead of
%                 downwards.
%   YY1(...,'mleft') Combines 'left' with 'math'. Also available are:
%                 'mright', 'mtrue', 'mcorner', 'mfreq' and 'mradfreq'.
%                 In the case of 'mcorner' the origin is moved to
%                 bottom of the image.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2014, based on YY.M

function out = yy1(varargin)
origin = '';
sz = [256,256];
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
                      'display','Y-coordinate (1D)',...
                      'inparams',struct('name',       {'sz',         'origin'},...
                                        'description',{'Input image','Location of origin'},...
                                        'type',       {'image',      'option'},...
                                        'dim_check',  {0,            0},...
                                        'range_check',{[],           options},...
                                        'required',   {0,            0},...
                                        'default',    {'a',          'right'}...
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
   if N > 1
      for ii=1:N
         if ~isnumeric(varargin{ii}) | prod(size(varargin{ii})) ~= 1 | mod(varargin{ii},1)
            error('Input arguments must be scalar integers.')
         end
      end
      sz = cat(2,varargin{1:N});
   elseif N == 1
      sz = varargin{1};
      if isa(sz,'dip_image')
         sz = size(sz);
      elseif isa(sz,'dip_image_array')
         error('Input image is an image array.')
      elseif ~isnumeric(sz) | isempty(sz)
         error('Size vector must be a row vector with integer elements.')
      elseif sum(size(sz)>1)>1
         % Treat sz as an image
         sz = size(dip_image(sz));
      end
   end
end
if length(sz)>=2
   m = sz(2);
   sz(:) = 1;
   sz(2) = m;
else
   sz(:) = 1;
end
try
   out = createramp(sz,2,origin);
catch
   error(firsterr)
end
