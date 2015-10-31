%DIP_ARRAY   Extracts the data array from a dip_image.
%   A = DIP_ARRAY(B) converts the dip_image B to a MATLAB
%   array without changing the type. A can therefore become
%   an array of type other than double, which cannot be used
%   in most MATLAB functions.
%
%   [A1,A2,A3,...An] = DIP_ARRAY(B) returns the n images in the
%   dip_image_array B in the arrays A1 through An.
%
%   DIP_ARRAY(B,DATATYPE) converts the dip_image B to a MATLAB
%   array of class DATATYE.
%
%   If B is a tensor image and only one output argument is given,
%   the array dimension are expandend into extra MATLAB array
%   dimensions.
%
%   If B is a tensor image with only one pixel, and only one
%   output argument is given, an array with the tensor dimensions
%   is returned. That is, the image dimensions are discarded.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, March 1999.
% 1 June 2000:      Now returns each image in the dip_image_array in
%                   a separate output argument (instead of giving an error).
% 15 August 2008:   Rewrite, dip_array is now the basis of all conversion
%                   from dip_image to matlab. Double, single etc call this
%                   function. Uniform handling of dip_image array (BR)
% 19 August 2008:   Using DIP_IMAGE for cast, fixed a bug for scalar images. (CL)
% 20 August 2008:   Rewriting again, to allow for 'double' conversion of
%                   complex images. (CL)
% 12 February 2009: Fixed bug introduced 6 months ago. Does nobody use this
%                   function? (CL)
% 20 August 2009:   Fixed bug that happened when catenating images of different
%                   data type. (CL)

function varargout = dip_array(in,dt)
if nargin == 1
   dt = '';
elseif ischar(dt)
   dt = di_diptype(dt); % Allow for aliases.
   dt = di_mattype(dt); % The MATLAB class we need to convert the data to.
else
   error('DATATYPE must be a string.')
end
if prod(imarsize(in))==nargout
   varargout = cell(1,nargout);
   if isempty(dt)
      [varargout{:}] = deal(in.data);
   else
      for ii=1:nargout
         varargout{ii} = di_convert(in(ii).data,dt);
      end
   end
elseif nargout<=1
   if istensor(in)
      if prod(size(in(1).data))==1
         if isempty(dt)
            dt = in(1).dip_type;
            for ii=2:prod(imarsize(in))
               dt = di_findtypex(dt,in(ii).dip_type);
            end
            dt = di_mattype(dt);
         end
         in = dip_image(in,dt);
         out = cat(1,in.data);
         out = reshape(out,imarsize(in));
      else
         dim = in(1).dims+1;
         out = cat(dim,in);
         out = reshape(out,[imsize(in) imarsize(in)]);
         out = out.data;
         if ~isempty(dt)
            out = di_convert(out,dt);
         end
      end
      varargout = {out};
   else
      error('Parameter "in" is an array of images of different sizes.')
   end
else
   error('Output arguments must match imarsize(in) or be 1.')
end
