%OUT = DI_JOINCHANNELS(COLSTRUCT,SPACESTRING,IN1,IN2,IN3,...)
%    Create a dip_image structure with the given dip_images and sets the
%    color space information to the given COL structure and SPACE string.
%    COL can be [], and SPACE can be '' (see DI_SETCOLSPACE).

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2002.

function out = di_joinchannels(col,space,varargin)
if nargin < 3
   error('Wrong input.')
end
N = prod(size(varargin));
out = dip_image('array',[N,1]);
di = dip_image(varargin{1});
if islogical(di), di = +di; end
out(1) = di;
sz = size(di);
for ii=2:N
   di = dip_image(varargin{ii});
   if ~isequal(sz,size(di))
      error('All channels must have same dimensionality and size.')
   end
   if islogical(di), di = +di; end
   out(ii) = di;
end
out = di_setcolspace(out,col,space);
