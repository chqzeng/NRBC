%SUBSREF   Overloaded operator for b=a{i}(j).
%   Additionally defines:
%      b = a.pixelsize(j)   % returns the physical dimensions of the pixels.
%      b = a.pixelunits(j)  % returns the units for the values above.
%      b = a.whitepoint     % returns the whitepoint for the XYZ color space.

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000.
% 18 January 2001:  Dimensions are preserved.
% 28 March 2001:    Added same tests as in SUBSASGN for coordinates.
% 14 August 2001:   Fixed bug with trailing singleton dimensions.
% 29 August 2001:   Fixed bug when indexing with one index.
% 18 December 2001: Added indexing by 1x1x.. dip_images (BR)
% 15 November 2002: Fixed binary images to work in MATLAB 6.5 (R13)
% February 2008:    Adding pixel dimensions and units to dip_image. (BR)
% 6 March 2008:     Allowing slightly more complex syntax with property indexing.
%                   Fixed bug when A is an image array. (CL)
% 10 March 2008:    Added whitepoint property. (CL)
% 28 April 2008:    Fixed bug: physDims was wrong when output was 1D. (CL)
% 22 November 2013: Allowing physDims to be empty. (CL)

function b = subsref(a,s)

if ~di_isdipimobj(a)
   error('Illegal indexing (this shouldn''t happen).')
end
N = length(s);
arrayindex = 0;
imageindex = 0;
propindex = 0;

for ii=1:N
   if strcmp(s(ii).type,'{}')
      if arrayindex
         error('Illegal indexing.')
      end
      arrayindex = ii;
      idx = s(arrayindex).subs;
      sz = imarsize(a);
      if length(idx) == 1
         if isnumeric(idx{1}) & (any(idx{1} > prod(sz)) | any(idx{1} < 1))
            error('Index exceeds array dimensions.')
         end
      else
         if length(idx) ~= length(sz)
            error('Number of array indices not the same as image array dimensionality.')
         end
         for ii=1:length(idx)
            if isnumeric(idx{ii}) & (any(idx{ii} > sz(ii)) | any(idx{ii} < 1))
               error('Index exceeds array dimensions.')
            end
         end
      end
   elseif strcmp(s(ii).type,'()')
      if imageindex
         error('Illegal indexing.')
      end
      imageindex = ii;
   else   % Dot-indexing
      % Allowed:
      %  a.p
      %  a.p(i)
      % Meaning: propindex [ imageindex ]
      if arrayindex | imageindex | propindex
         error('Illegal indexing.')
      end
      propindex = ii;
   end
end
if propindex
   % Get properties
   if imageindex
      idx = s(imageindex).subs;
      if length(idx)~=1
         error('Illegal indexing.')
      end
      idx = idx{1};
      if isequal(idx,':')
         idx = [];
      end
   else
      idx = [];
   end
   switch lower(s(propindex).subs)
   case 'pixelsize'
      b = a(1).physDims.PixelSize;
      if isempty(b)
         b = repmat(1,1,a(1).dims); 
      end
      if ~isempty(idx)
         if any(idx<=0) | any(idx>a(1).dims)
            error('Index exceeds matrix dimensions.')
         end
         b = b(idx);
      end
   case 'pixelunits'
      b = a(1).physDims.PixelUnits;
      if isempty(b)
         b = repmat({'px'},1,a(1).dims);
      end
      if ~isempty(idx)
         if any(idx<=0) | any(idx>a(1).dims)
            error('Index exceeds matrix dimensions.')
         end
         b = b(idx);
      end
   case 'whitepoint'
      if isempty(a(1).color)
         error('The image is not a color image');
      end
      if isfield(a(1).color,'xyz')
         b = a(1).color.xyz;
      else
         b = di_defaultwhite;
      end
   otherwise
      error('Unknown indexing functions.')
   end
else
   % First index into array if required.
   if arrayindex
      try
         b = builtin('subsref',a,substruct('()',s(arrayindex).subs));
      catch
         error(di_firsterr)
      end
      N = prod(imarsize(b));
      if N ~= prod(imarsize(a))
         % Not all components were kept: remove color information.
         for ii=1:N
            b(ii).color = '';
         end
      end
   else
      b = a;
      N = prod(imarsize(b));
   end
   % Then index into images if required.
   if imageindex
      if N > 1
         if ~istensor(b)
            error('Cannot index by pixel in a dip_image_array that is not a tensor.')
         end
      end
      sz = size(b(1).data);
      s = s(imageindex);
      dims = b(1).dims;
      if length(s.subs) == 1 % (this should produce a 1D image)
         if di_isdipimobj(s.subs{1})
            if ndims(squeeze(s.subs{1}))==0 % added for Piet (BR)
               s.subs{1} = double(s.subs{1})+1;
            elseif ~islogical(s.subs{1})
               error('Only binary images can be used to index.')
            else
               s.subs{1} = logical(s.subs{1}.data);
            end
         elseif ~ischar(s.subs{1}) & ~islogical(s.subs{1})
            s.subs{1} = s.subs{1}+1;
            if any(s.subs{1} > prod(sz)) | any(s.subs{1} < 1)
               error('Index exceeds image dimensions.')
            end
         end
         if islogical(s.subs{1})
            if ~isequal(size(s.subs{1}),sz)
               error('Mask image must match image size when indexing.')
            end
         end
         for ii=1:N
            try
               b(ii).data = subsref(b(ii).data,s);
               b(ii).data = reshape(b(ii).data,1,prod(size(b(ii).data)));
               b(ii).dims = 1;
               b(ii).physDims = di_defaultphysdims(1);
            catch
               error(di_firsterr)
            end
         end
      elseif length(s.subs) == b(1).dims
         tmp = s.subs(2);
         s.subs(2) = s.subs(1);
         s.subs(1) = tmp;
         for ii=1:length(sz)
            if islogical(s.subs{ii})
               error('Illegal indexing.')
            elseif di_isdipimobj(s.subs{ii})
               if ndims(squeeze(s.subs{ii}))==0 %added for Piet (BR)
                  s.subs{ii}=double(s.subs{ii});
               else
                  error('Illegal indexing.');
               end
            end
            if ~ischar(s.subs{ii})
               s.subs{ii} = s.subs{ii}+1;
               if any(s.subs{ii} > sz(ii)) | any(s.subs{ii} < 1)
                  error('Index exceeds image dimensions.')
               end
            end
         end
         for ii=(length(sz)+1):length(s.subs) % indexing into the singleton dimensions
            if di_isdipimobj(s.subs{ii}) | islogical(s.subs{ii})
               error('Illegal indexing.')
            elseif ~ischar(s.subs{ii})
               if any(s.subs{ii} ~= 0)
                  error('Index exceeds image dimensions.')
               end
            end
         end
         s.subs = s.subs(1:length(sz));
         for ii=1:N
            try
               b(ii).data = subsref(b(ii).data,s);
            catch
               error(di_firsterr)
            end
         end
      else
         error('Number of indices not the same as image dimensionality.')
      end
   end
end
