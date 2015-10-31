%IMARFUN   Functions on all images in an array.
%   B = IMARFUN(FUN,A) where FUN is one of
%
%     'isempty'   -- true for empty image
%     'islogical' -- true for binary image
%     'isreal'    -- true for non-complex image
%     'ndims'     -- number of dimensions of image
%     'prodofsize'-- number of pixels in image
%     'max'       -- maximum pixel value in image
%     'mean'      -- mean pixel value in image
%     'median'    -- median pixel value in image
%     'min'       -- minimum pixel value in image
%     'std'       -- standard deviation of pixels in image
%     'sum'       -- sum of pixels in image
%
%   and A is the dip_image_array, returns the results
%   of applying the specified function to each element
%   of the image array. B is a double array the same
%   size as A containing the results of applying FUN on
%   the corresponding images in A.
%                                       [ B(ii)=FUN(A{ii}) ]
%
%   B = IMARFUN(FUN,A) where FUN is one of
%
%     'imsum'     -- sum of all images
%     'improd'    -- product of all images
%     'imor'      -- true if any pixel is non-zero
%     'imand'     -- true if all pixels are non-zero
%     'immax'     -- maximum pixels over all images
%     'immin'     -- minimum pixels over all images
%     'imeq'      -- true if pixel is equal in all images
%     'imlargest' -- index of first image with largest pixel value
%     'imsmallest'-- index of first image with smallest pixel value
%
%   and A is the dip_image_array with images of the same
%   sizes and dimensionalities, returns the result
%   of applying the specified diadic function to each image
%   in the array and the previous result in turn. The result
%   is also a dip_image.
%                              [ B=FUN(A{1},A{2},A{3},...) ]

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 21 August 2001: Added 'isreal', needed by new DIPSHOW.

function b = imarfun(fun,a)
if ~ischar(fun)
   error('First parameter should be a string.')
end
s = imarsize(a);
try
   if strncmpi(fun,'im',2)
      % Type is [ B=FUN(A{1},A{2},A{3},...) ]
      N = prod(s);
      if N < 2
         error('Need at least two images in array to do diadic operations.')
      end
      switch fun
         case 'imsum'
            b = a(1)+a(2);
            for ii=3:N
               b = b+a(ii);
            end
         case 'improd'
            b = a(1)*a(2);
            for ii=3:N
               b = b*a(ii);
            end
         case 'imor'
            b = a(1)|a(2);
            for ii=3:N
               b = b|a(ii);
            end
         case 'imand'
            b = a(1)&a(2);
            for ii=3:N
               b = b&a(ii);
            end
         case 'immax'
            b = max(a(1),a(2));
            for ii=3:N
               b = max(b,a(ii));
            end
         case 'immin'
            b = min(a(1),a(2));
            for ii=3:N
               b = min(b,a(ii));
            end
         case 'imeq'
            b = a(1)==a(2);
            for ii=3:N
               b = b & (a(1)==a(ii));
            end
         case 'imlargest'
            b = (a(1) < a(2)) + 1;
            tmp = max(a(1),a(2));
            for ii=3:N
               b = max(b,(tmp < a(ii))*ii);
               tmp = max(tmp,a(ii));
            end
         case 'imsmallest'
            b = (a(1) > a(2)) + 1;
            tmp = min(a(1),a(2));
            for ii=3:N
               b = max(b,(tmp > a(ii))*ii);
               tmp = min(tmp,a(ii));
            end
         otherwise
            error('Unknown FUNction.')
      end
   else
      % Type is [ B(ii)=FUN(A{ii}) ]
      b = zeros(s);
      for ii=1:prod(s)
         switch fun
            case 'isempty'
               b(ii) = isempty(a(ii));
            case 'islogical'
               b(ii) = islogical(a(ii));
            case 'isreal'
               b(ii) = isreal(a(ii));
            case 'ndims'
               b(ii) = ndims(a(ii));
            case 'prodofsize'
               b(ii) = prod(size(a(ii)));
            case 'max'
               b(ii) = max(a(ii));
            case 'mean'
               b(ii) = mean(a(ii));
            case 'median'
               b(ii) = median(a(ii));
            case 'min'
               b(ii) = min(a(ii));
            case 'std'
               b(ii) = std(a(ii));
            case 'sum'
               b(ii) = sum(a(ii));
            otherwise
               error('Unknown FUNction.')
         end
      end
   end
catch
   error(di_firsterr)
end
