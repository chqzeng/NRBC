%RR   Creates an image with R coordinates
%   RR(M,N,P,...) or RR([M,N,P,...]) returns an image of size
%   M-by-N-by-P-by-... with the value of the R-coordinate of each
%   pixel as the pixel values.
%
%   RR(A) is the same as RR(SIZE(A)).
%
%   RR(...,ORIGIN) allows specifying where the origin is:
%      'left'    the pixel to the left of the true center
%      'right'   the pixel to the right of the true center (default)
%      'true'    the true center, between pixels if required
%      'corner'  the pixel on the upper left corner (indexed at (0,0))
%   Note that the first three are identical if the size is odd.
%
%   RR(A,'freq')    uses frequency domain coordinates, range=(0,0.5)
%      (not in combination with ORIGIN).
%   RR(A,'radfreq') uses frequency domain coordinates, range=(0,pi)
%      (not in combination with ORIGIN).
%
%   RR(A,'math')  Let the Y coordinate increase upwards instead of
%                 downwards. Since the distance to centre does not
%                 depend on the sign of the Y coordinate, this
%                 option has no effect.
%   RR(A,'mleft') Combines 'left' with 'math'. Also available are:
%                 'mright', 'mtrue', 'mcorner', 'mfreq' and 'mradfreq'.
%                 In the case of 'mcorner' the origin is moved to
%                 bottom of the image.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 20 April 2001: Improvements. Fixed 1D version. Using CREATERAMP.
% 26 April 2001: Added to menu.
%                Added 'frequency' option.
% 8 August 2001: Copied parameter parsing from NEWIM. Changed help accordingly.
% 4 July 2002:   Fixed result for 1D image.
% 15 November 2002: Added/improved createramp options. (MvG)
% 15 October 2010:  Added undocumented option to produce rr^2.

function out = rr(varargin)
origin = '';
squared = 0;
sz = [256,256];
N = nargin;
if N > 0 & ischar(varargin{N}) & strcmpi(varargin{N},'squared')
   squared = 1;
   N = N-1;
end
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
                      'display','R-coordinate',...
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
if isempty(sz) | prod(sz) == 0
   out = dip_image([],'single');
else
   out = createramp(sz,1,origin);
   if length(sz) > 1
      out = out^2;
      for ii=2:length(sz)
         out = out + createramp(sz,ii,origin)^2;
      end
      if ~squared
         out = sqrt(out);
      end
   else
      if squared
         out = out^2;
      else
         out = abs(out);
      end
   end
end
