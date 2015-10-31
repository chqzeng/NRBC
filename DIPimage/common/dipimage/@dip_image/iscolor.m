%ISCOLOR   True if IN is a color image.
%    ISCOLOR(IN) returns true (non-zero) if all images in the
%    tensor image IN have the same color string, and it is not
%    empty.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.
% Changed in.color in in.color.space where appropiate. Judith Dijk, June 2002
% 15 November 2002: returning logical value in all cases.

function result = iscolor(in)
if nargin ~= 1, error('Need an input argument.'); end

result = logical(0);
N = prod(imarsize(in));
if N > 1 & istensor(in)
   c = in(1).color;
   if ~isempty(c)
      d = in(1).color.space;
      for ii=2:N
         if ~strcmp(d,in(ii).color.space)
            return
         end
      end
      result = logical(1);
   end
end
