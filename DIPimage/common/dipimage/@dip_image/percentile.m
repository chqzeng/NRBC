%PERCENTILE   Get the percentile of an image.
%   VALUE = PERCENTILE(B,P) gets the value of the P percentile of all
%   pixels in the image B. P must be between 0 and 100.
%
%   Note that:
%   PERCENTILE(B,0) is a silly way of doing MIN(B)
%   PERCENTILE(B,50) is exactly the same as MEDIAN(B)
%   PERCENTILE(B,100) is a silly way of doing MAX(B)
%
%   VALUE = PERCENTILE(B,P,M), with M a binary image, is the same as
%   PERCENTILE(B(M),P).
%
%   VALUE = PERCENTILE(B,P,M,DIM) computes the P percentile over the
%   dimensions specified in DIM. For example, if B is a 3D image,
%   PERCENTILE(B,10,[],3) returns an image with 2 dimensions, containing
%   the 10th percentile over the pixel values along the third dimension (z).
%   DIM can be an array with any number of dimensions. M can be [].
%
%   [VALUE,POSITION] = PERCENTILE(B,P,...) returns the position of the found
%   values as well. With this syntax, DIM can specify just one dimension.

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
% 19 April 2001: General improvements.
% 27 April 2001: Added MASK parameter.
% 6 February 2002: Added POSITION parameter. Using DIP_POSITIONPERCENTILE.

function [value,position] = percentile(in,p,mask,d)
if nargin < 2
   error('Percentage required.')
end
if ~isscalar(in)
   error('Parameter "in" is an array of images.')
end
if prod(size(p))~=1 | ~isnumeric(p)
   error('Percentage should be a scalar value.')
end
if p<0 | p>100
   error('Percentage out of range.')
end
nd = ndims(in);
if nd == 0
   position = [];
   value = double(in);
else
   if nargin < 3
      mask = [];
   end
   try
      if nargin < 4
         process = di_processarray(nd);
         value = double(dip_percentile(in,mask,p,process));
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
         value = dip_percentile(in,mask,p,process);
         if nargout > 1
            if length(d) ~= 1
               error('Can only compute position for one dimension at a time');
            end
            position = dip_positionpercentile(in,mask,p,d-1,1);
         end
      end
   catch
      error(di_firsterr)
   end
end
