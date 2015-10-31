%LOADOBJ   Converts dip_image objects loaded from a MAT-file.
%   Called by MATLAB for each dip_image object it loads.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2002.
% 15 November 2002: Fixed binary images to work in MATLAB 6.5 (R13)
% 6 January 2005:   Fixed loading of 1D images.
% 11 March 2008:    Fixed to load objects written before the February changes.

function out = loadobj(in)
if di_isdipimobj(in)
   % The object we are trying to read in contains the same elements as the current
   % definition of the dip_image object. We are examining the elements to avoid
   % confusion (assertions). We are also changing the contents of the color field,
   % which has changed because of Judith's additions. Also, we are checking for
   % logical data, which is not supported any more.
   sz = imarsize(in);
   for ii=1:prod(sz)
      if islogical(in(ii).data)
         in(ii).data = uint8(+in(ii).data);
         in(ii).dip_type = 'bin';
      elseif ~isnumeric(in(ii).data)
         warning('This dip_image object you''re loading contains non-numeric data! (converting to doubles)')
         in(ii).data = double(in(ii).data);
         in(ii).dip_type = 'dfloat';
      else
         if ~strcmp(di_mattype(in(ii).dip_type),class(in(ii).data))
            in(ii).dip_type = di_diptype(in(ii).data);
         end
      end
      if issparse(in(ii).data), in(ii).data = full(in(ii).data); end
   end
   isvector = 1;
   imsz = size(in(1).data);
   for ii=2:prod(sz)
      if ~isequal(size(in(ii).data),imsz)
         isvector = 0;
      end
   end
   col = in(1).color;
   if isvector & ~isempty(col)
      if ischar(col)
         col = struct('space',col);
      elseif ~isstruct(col)
         col = '';
      end
   else
      col = '';
   end
   for ii=1:prod(sz)
      dims = in(ii).dims;
      sz = size(in(ii).data);
      switch dims
         case 0
            if prod(sz)~=0
               in(ii).dims = length(sz);
            end
         case 1
            if prod(sz)~=max(sz)
               in(ii).dims = length(sz);
            end
         otherwise
            in(ii).dims = max(length(sz),dims);
      end
      in(ii).color = col;
   end
   out = in;
elseif isa(in,'struct')
   % This case happens when the dip_image structure changes. This is useful for
   % compatability between different versions of DIPimage, or if someone makes
   % his own (different) version of the dip_image object and tries to fool us.
   % In February 2008 we added a 'physDims' element to the dip_image structure.
   arsz = size(in);
   if ~isfield(in,'data')
      warning('This object you''re loading is an invalid dip_image!')
      out = dip_image([]);
   else
      for ii=1:prod(arsz)
         if ~isnumeric(in(ii).data) & ~islogical(in(ii).data)
            warning('This dip_image object you''re loading contains non-numeric data! (converting to doubles)')
            in(ii).data = double(in(ii).data);
         end
         if issparse(in(ii).data), in(ii).data = full(in(ii).data); end
      end
      isvector = 1;
      imsz = size(in(1).data);
      for ii=2:prod(arsz)
         if ~isequal(size(in(ii).data),imsz)
            isvector = 0;
         end
      end
      if isvector & isfield(in,'color')
         col = in(1).color;
         if ~isempty(col)
            if ischar(col)
               col = struct('space',col);
            elseif ~isstruct(col)
               col = '';
            end
         else
            col = '';
         end
      else
         col = '';
      end
      out = dip_image('array',arsz);
      for ii=1:prod(arsz)
         out(ii) = dip_image(in(ii).data);
         if isfield(in,'dims')
            out(ii).dims = max(in(ii).dims,out(ii).dims);
         end
         out(ii).color = col;
         if isfield(in,'physDims')
            % Set it through the SUBSASGN method, which test for correctnes
            tmp = out(ii);
            try
               tmp = subsasgn(tmp,substruct('.','pixelsize'),in.physDims.PixelSize);
               tmp = subsasgn(tmp,substruct('.','pixelunits'),in.physDims.PixelUnits);
            catch
               warning('This dip_image object you''re loading has illegal pixel dimensions! (ignoring)')
            end
            out(ii) = tmp;
         end
      end
   end
else
   % Can this happen???
   warning('This is a very weird dip_image object you''re loading!')
   % This is the best I can do...
   out = dip_image(in);
end
