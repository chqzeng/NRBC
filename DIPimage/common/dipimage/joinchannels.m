%JOINCHANNELS   Joins scalar images as channels in a color image
%   JOINCHANNELS(COL,A,B,C,...) creates a color image with components
%   A, B, C, etc. The color space is set to COL. The images A, B, C,
%   etc. must be scalar images of the same size.
%
%   If any of A, B, C is binary, it is converted to a grey-value image
%   with values 0 and 255.
%
%   JOINCHANNELS(COL,A) creates a color image with ndims(A)-1 dimensions.
%   The last dimension of A is assumed to be the color channels.
%
%   See also DIP_IMAGE/COLORSPACE.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.
% 8 August 2001: Removed limitation of 2D channels.
% 22 March 2002: Added syntax with one input image.
% 12 June 2002:  Allowing binary input images.

function out = joinchannels(col,varargin)

% Avoid being in menu
if nargin == 1 & ischar(col) & strcmp(col,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if nargin < 2
   error('I need at least a color space name and an image to work on.')
end
N = nargin-1;
if N == 1
   in = dip_image(varargin{1});
   if isa(in,'dip_image_array')
      if ~iscolor(in)
         out = colorspace(in,col);
      else
         error('The input image is already a color image.')
      end
   else
      if islogical(in)
         in = dip_image(in,'uint8');
      end
      sz = size(in);
      nd = length(sz);
      if nd<2
         error('The input image does not have enough dimensions.')
      end
      nc = sz(end);
      sz = sz(1:end-1);
      out = newimar(nc,1);
      indx = cell(1,nd);
      indx(:) = {':'};
      for ii=1:nc
         indx{end} = ii-1;
         out{ii} = reshape(subsref(in,substruct('()',indx)),sz);
      end
      out = colorspace(out,col);
   end
else
   out = newimar(N,1);
   di = dip_image(varargin{1});
   if isa(di,'dip_image_array')
      error('I need scalar images as channels.')
   end
   if islogical(di)
      tmp = di;
      di = newim(tmp);
      di(tmp) = 255;
   end
   out{1} = di;
   sz = size(di);
   for ii=2:N
      di = dip_image(varargin{ii});
      if isa(di,'dip_image_array')
         error('I need scalar images as channels.')
      end
      if ~isequal(sz,size(di))
         error('All channels must have same dimensionality and size.')
      end
      if islogical(di)
         tmp = di;
         di = newim(tmp);
         di(tmp) = 255;
      end
      out{ii} = di;
   end
   out = colorspace(out,col);
end
