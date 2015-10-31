%MEDIAN   Get the median of an image.
%   VALUE = MEDIAN(B) gets the value of the median of all pixels in
%   the image B.
%
%   VALUE = MEDIAN(B,M), with M a binary image, is the same as MEDIAN(B(M)).
%
%   VALUE = MEDIAN(B,M,DIM) computes the median over the dimensions specified
%   in DIM. For example, if B is a 3D image, MEDIAN(B,[],3) returns an image
%   with 2 dimensions, containing the median over the pixel values along
%   the third dimension (z). DIM can be an array with any number of
%   dimensions. M can be [].
%
%   [VALUE,POSITION] = MEDIAN(B,...) returns the position of the found values
%   as well. With this syntax, DIM can specify just one dimension.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 20 September 2000: Removed MASK parameter (useless).
% 28 November 2000: Added DIM parameter.
% 27 April 2001: Added MASK parameter.
% 6 February 2002: Added POSITION parameter. Using DIP_POSITIONPERCENTILE.

function [value,position] = median(in,mask,d)
if ~isscalar(in), error('Parameter "in" is an array of images.'), end
nd = ndims(in);
if nd == 0
   position = [];
   value = double(in);
else
   if nargin < 2
      mask = [];
   end
   try
      if nargin < 3
         process = di_processarray(nd);
         value = double(dip_percentile(in,mask,50,process));
         if nargout > 1
            if mask
               position = findcoord(in==value & mask);
            else
               position = findcoord(in==value);
            end
            position = position(1,:); % location of first value
         end
      else
         process = di_processarray(nd,d);
         value = dip_percentile(in,mask,50,process);
         if nargout > 1
            if length(d) ~= 1
               error('Can only compute position for one dimension at a time');
            end
            position = dip_positionpercentile(in,mask,50,d-1,1);
         end
      end
   catch
      error(di_firsterr)
   end
end
