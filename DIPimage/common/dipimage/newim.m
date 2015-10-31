%NEWIM   Creates a dip_image of the specified size
%   NEWIM(N) is an 1D image with N pixels all set to zero.
%
%   NEWIM(N,M) or NEWIM([N,M]) is an N-by-M image. NEWIM, by itself,
%   creates an image of 256 by 256 pixels.
%
%   NEWIM(N,M,P,...) or NEWIM([N,M,P,...]) is an
%   N-by-M-by-P-by-... image.
%
%   NEWIM(IMSIZE(B)) is an image with the same size as the dip_image
%   B. This does not work if B is not a dip_image.
%   In that case, do DIP_IMAGE(ZEROS(SIZE(B))).
%
%   NEWIM(B) does the same thing, but also copies over the pixel
%   size information.
%
%   NEWIM(...,TYPE) sets the data type of the new image to TYPE.
%   TYPE can be any of the type parameters allowed by DIP_IMAGE. The
%   default data type is 'sfloat'.
%
%   NEWIM(B,DATATYPE(B)) creates an empty image with the same size
%   and data type as B.
%
%  SEE ALSO: newimar, newcolorim

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2001. Copy of DIP_IMAGE_NEW
% 7 August 2001: Removed silly section that was a remain of a copy/paste action
%                (it would never have been executed, though).
% 8 August 2001: Added to menu.
% 27 August 2001: Minor bug fix.
% 15 November 2002: 'bin8' => 'bin'
% 21 June 2004: Check for zero dimensions (BR)
% 10 March 2008: Copying over pixel sizes for NEWIM(B) syntax.
% 7 December 2011: Allowing the creation of 0D images.

function out = newim(varargin)
dip_type = 'sfloat';
n = [256,256];
N = nargin;
psize = [];
if N ~= 0
   if ischar(varargin{N})
      dip_type = varargin{N};
      if strcmp(dip_type,'DIP_GetParamList') % Add to menu
         out = struct('menu','Generation',...
                      'display','New image',...
                      'inparams',struct('name',       {'sz',     'dip_type'},...
                                        'description',{'Size',   'Data type'},...
                                        'type',       {'array',  'option'},...
                                        'dim_check',  {-1,       0},...
                                        'range_check',{'N+',     {'bin','uint8','uint16','uint32','sint8','sint16','sint32','sfloat','dfloat','scomplex','dcomplex'}},...
                                        'required',   {0,        0},...
                                        'default',    {[256,256],'sfloat'}...
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
      n = cat(2,varargin{1:N});
   elseif N == 1
      n = varargin{1};
      if isa(n,'dip_image')
         psize = n.pixelsize;
         punit = n.pixelunits;
         n = size(n);
      elseif isa(n,'dip_image_array')
         error('Input image is an image array.')
      elseif ~isnumeric(n)
         error('Size vector must be a row vector with integer elements.')
      elseif sum(size(n)>1)>1
         % Treat n as an image
         n = size(dip_image(n));
      elseif ~isempty(n) & any(n)==0
         error('One of the dimensions is zero.');
      end
   end
end
try
   out = dip_image('zeros',n,dip_type);
   if ~isempty(psize)
      out.pixelsize = psize;
      out.pixelunits = punit;
   end
catch
   error(firsterr)
end
