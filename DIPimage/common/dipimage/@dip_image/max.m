%MAX   Get the first maximum in an image.
%   [VALUE,POSITION] = MAX(B) gets the value and postion of the first
%   maximum in image B.
%
%   [VALUE,POSITION] = MAX(B,M) gets the value and postion of the first
%   maximum in image B masked by M. M may be [] for no mask.
%
%   VALUE = MAX(B,M,DIM) performs the computation over the dimensions
%   specified in DIM. DIM can be an array with any number of
%   dimensions. M may be [] for no mask.
%
%   [VALUE,POSITION] = MAX(B,M,DIM) gets the value and position of
%   the first maximum along dimension DIM. DIM is a single dimension.
%
%   VALUE = MAX(B,C) is the pixel-by-pixel maximum operator. It returns
%   an image with each pixel the largest taken from B or C. C must not
%   be a binary image, or it will be taken as a mask image (see syntax
%   above).
%
%   If B is a tensor image, MAX(B) is the image with the maximum over all
%   the tensor components.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2000.
% 6 November 2000:  Also overloaded for tensor images.
% 28 November 2000: Added DIM parameter, removed silly MASK parameter.
% 19 April 2001:    Not using COMPUTE0 anymore.
% 19 December 2001: Added [v,p]=max(b,[],dim) (BR)
% 6 February 2002:  Added MASK parameter. Using DIP_POSITIONMAXIMUM.
% 7 April 2009:     max(uint8,uint8) = uint8, not single!
% 24 June 2011:     Not using DO1ARRAYINPUT any more. New version of COMPUTE2. (CL)

function [value,position] = max(in1,in2,dim)
if nargin == 2 & ~islogical(in2)
   if nargout > 1
      error('Too many output arguments.')
   end
   try
      value = compute2('max',in1,in2,'keepsame');
   catch
      error(di_firsterr)
   end
   if isempty(value)
      warning('Empty image.')
      value = 0;
   end
else
   if ~di_isdipimobj(in1)
      error('Illegal input to overloaded function MAX.')
   elseif isscalar(in1)
      if nargin == 1
         in2 = []; % no mask image
      end
      if nargin < 3
         if ndims(in1) == 0
            position = [];
            value = double(in1);
         else
            [position,value] = dip_maximumpixel(in1,in2,1);
         end
      else % nargin == 3
         nd = ndims(in1);
         if nd == 0
            position = [];
            value = double(in1);
         else
            try
               process = di_processarray(nd,dim);
               if isempty(process) | all(process==0)
                  value = in1;
               else
                  value = dip_maximum(in1,in2,process);
               end
            catch
               error(di_firsterr)
            end
            if nargout > 1
               if length(dim) ~= 1
                  error('Can only compute position for one dimension at a time');
               end
               try
                  position = dip_positionmaximum(in1,in2,dim-1,1);
               catch
                  error(di_firsterr)
               end
            end
         end
      end
   elseif istensor(in1)
      if nargin > 1
         error('Too many input arguments.')
      end
      if nargout > 1
         error('Too many output arguments.')
      end
      try
         value = compute0array('max',in1);
      catch
         error(di_firsterr)
      end
   else
      error('Input must be a scalar or tensor image.')
   end
end
