%DELTAIM   Generate a discrete delta function
%
% SYNOPSIS:
%  image_out = deltaim(image_size,data_type)
%
% Generates a discrete delta function. It is centred such that it
% is at what is considered the origin by the Fourier transform. The
% argument "image_size" has many possiblities (an image to copy size
% from, a size array, etc). Read the help on "newim" for the possibilities.
%
% "data_type" sets the data type of the new image. The default is 'sfloat'.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel, September 2001.
% 27 November 2001: Fixed for 1D images.
% 20 March 2002: Added to menu (CL).
% 21 March 2002: Added 'data type' parameter (CL).
% 15 November 2002: 'bin8' => 'bin'

function out = deltaim(varargin)
dip_type = 'sfloat';
n = [256,256];
N = nargin;
if N ~= 0
   if ischar(varargin{N})
      dip_type = varargin{N};
      if strcmp(dip_type,'DIP_GetParamList') % Add to menu
         out = struct('menu','Generation',...
                      'display','Discrete delta function',...
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
   out = dip_image('zeros',n,dip_type);
   %out = subsasgn(out,substruct('()',num2cell(floor(n/2))),1);
   ind = num2cell(floor(n/2));
   out(ind{:}) = 1;
catch
   error(firsterr)
end
