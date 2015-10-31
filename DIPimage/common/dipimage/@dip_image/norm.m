%NORM   Computes the (Eucledian) norm of a tensor image.
%   NORM(V,P) = sum(abs(V).^p)^(1/p)
%   NORM(V)   = norm(v,2) default P=2 eucledian

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, November 2000.
% Nov 2002, added norm for tensor images, being the Froebius norm
% 6 March 2008: Huh? Did this code ever work??? Added IMARFUN calls. (CL)
% 27 June 2011: Written out the IMARFUN code, this is more memory efficient. (CL)

function out = norm(a,p)
if nargin == 1
   p = 2;
elseif ~isnumeric(p) | prod(size(p))~=1
   error('Exponent must be a scalar.');
end
if ~istensor(a)
   error('Input image not dip_image tensor.')
end

N = prod(imarsize(a));
if N<=1
   out = abs(a);
else
   if isinf(p)
      if p>0 % p==Inf
         out = abs(a(1));
         for ii=2:N
            out = max(out,abs(a(ii)));
         end
      else   % p==-Inf
         out = abs(a(1));
         for ii=2:N
            out = min(out,abs(a(ii)));
         end
      end
   elseif p==1
      out = abs(a(1));
      for ii=2:N
         out = out + abs(a(ii));
      end
   else
      out = abs(a(1)).^p;
      for ii=2:N
         out = out + abs(a(ii)).^p;
      end
      out = out.^(1/p);
   end
end
