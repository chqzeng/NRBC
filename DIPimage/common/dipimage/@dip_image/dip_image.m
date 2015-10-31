%DIP_IMAGE   Creates an image for use in the DIPimage toolbox.
%   DIP_IMAGE(B) converts the matrix B to a DIP_IMAGE of type
%   double. DIP_IMAGE(B,TYPE) converts the data to TYPE first.
%
%   Matrices with only one column or one row are converted to a 1D
%   image. Matrices with one value are converted to 0D images.
%   Otherwise, the dimensionality is not affected, and singleton
%   dimensions are kept.
%
%   TYPE is a string representing the data type. It can be any of the
%   following data types:
%      bin             binary (stored as uint8)
%      uint8           8-bit unsigned integer
%      uint16          16-bit unsigned integer
%      uint32          32-bit unsigned integer
%      sint8           8-bit signed integer
%      sint16          16-bit signed integer
%      sint32          32-bit signed integer
%      sfloat          single precision float
%      dfloat          double precision float
%      scomplex        single precision complex
%      dcomplex        double precision complex
%      bin8            the same as bin
%      bin16           the same as bin
%      bin32           the same as bin
%      uint            the same as uint32
%      int             the same as sint32
%      int8            the same as sint8
%      int16           the same as sint16
%      int32           the same as sint32
%      float           the same as sfloat
%      single          the same as sfloat
%      double          the same as dfloat
%      complex         the same as dcomplex
%
%   If B is a cell array with numeric elements, a dip_image_array is
%   created, each element being one image in the array. These can optionally
%   be converted to a specific data type.

%Undocumented:
%   DIP_IMAGE('array',SIZE) creates an image array of size SIZE with empty
%   images.
%
%   DIP_IMAGE('zeros',SIZE) creates an image of size SIZE filled with zeros.
%
%   The 'array' and 'zeros' options are for independance of the dip_image
%   object. I hope none of the @dip_image functions calls a function in the
%   DIPimage toolbox anymore.
%
%   DIP_IMAGE('trust_me',DATA,TYPE,DIMS) or DIP_IMAGE('trust_me',DATA,TYPE,...
%   DIMS,PHYSDIMS) creates a dip_image object with those components. This is
%   used in some dip_image object functions (no longer in the DML interface).

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-June 1999.
% 7 April 2000:      The default image type is now sfloat. However, double data is not
%                    explicitly converted to sfloat. 16 or 32-bit binary data is no
%                    longer generated (ever!). Data is no longer copied by CONVERT if
%                    IN_TYPE == OUT_TYPE.
% 18 May 2000:       Just some cosmetic changes. A portion of this function now resides
%                    in PRIVATE/DIPTYPE.
% 31 May 2000:       Just some cosmetic changes. A portion of this function now resides
%                    in PRIVATE/MATTYPE.
% 18 July 2000:      In the case NARGIN==2, with IN a dip_image_array, each of the
%                    images in the array are converted to the new type.
% 25 July 2000:      Some more cosmetic changes.
% 8 October 2000:    Added support for color to dip_image.
% 16 October 2000:   Removed bug that created non-binary images with logical data.
% 30 October 2000:   1D images are also squeezed now. 2 1D dip_image objects with the
%                    same LENGTH now always have the same SIZE.
% 18 January 2001:   Images are no longer SQUEEZED by default.
% 28 March 2001:     Added undocumented 'array' feature for use in DIP_IMAGE_ARRAY.
% 19 April 2001:     Added undocumented 'trust_me' feature for use in DML interface.
% 20 April 2001:     Added undocumented 'zeros' feature for use in DIP_IMAGE_NEW.
% 27 April 2001:     1D images are made into a row vector now: QUEEZE(A)==A for 1D images.
% 6 August 2001:     'zeros' feature with 'bin' option did not make the array logical.
% 8 August 2001:     'zeros' feature with a 0 in the SIZE array faild. Now making empty image.
% 30 September 2001: Made converting binary to grey much, much faster. Why did I write the
%                    other code? When has that been faster?
% 3 October 2001:    Fixed small bug.
% 12 June 2002:      Added syntax with cell array to create image array.
% 15 November 2002:  Fixed binary images to work in MATLAB 6.5 (R13)
%                    'bin8' => 'bin'
% 15 March 2005:     Fixed bug for dip_image('zeros',[4,0],'sfloat')
% February 2008:     Adding pixel dimensions and units to dip_image. (BR)
% 5 March 2008:      Bug fix in pixel dimension addition. (CL)
% 22 April 2008:     Keeping physDims when converting data type. (CL)
% 20 May 2013:       Extremely large or small double scalars were converted to singles
%                    even when requesting double output. This was a coding error. (CL)
% 24 May 2013:       No longer creating sfloat images from scalar double input. (CL)
%                    ** This might be a major change, but is more consistent. **
% 26 November 2013:  Fix allowing PhysDims to be empty in the 'trust_me' mode. (CL)

% dip_image objects contain five elements:
% 'data'      An array containing the image data. It can be any integer of
%             float type. If it is complex it must be one of the two float
%             types.
% 'dip_type'  The type of the image data according to DIPlib naming. Always
%             corresponds to the data type of 'data'.
% 'dims'      The number of dimensions the image has. Larger or equal to ndims(data).
% 'color'     Struct containing the name and some other info on the color space.
% 'physDims'  Struct with 'PixelSize' and 'PixelUnits' elements. The first is a numeric
%             array, the second a cell string array, each has 'dims' elements.

function out = dip_image(varargin)
trust_me = 0; % set to 1 if the data in IN corresponds with DIP_TYPE.
physDims = [];
switch nargin
   case 0
      in = single([]);
      dip_type = 'sfloat';
      dims = 0;
      trust_me = 1;
   case 1
      in = varargin{1};
      if di_isdipimobj(in)
         out = in;
         return
      end
      if iscell(in)
         out = dip_image;
         sz = num2cell(size(in));
         out(sz{:}) = dip_image;
         for ii=1:prod(size(in));
            out(ii) = dip_image(in{ii});
         end
         return
      else
         if islogical(in)
            out = dip_image(uint8(in),'bin');
            return
         end
         if ~isnumeric(in), error('Data must be numeric.'); end
         if issparse(in), in = full(in); end
         dip_type = di_diptype(in);
         [in,dims] = getdipndims(in);
      end
   otherwise
      in = varargin{1};
      if ischar(in)
         switch in
            case 'array'
               % Undocumented feature: DIP_IMAGE('array',[size])
               if nargin ~= 2, error('Wrong number of input arguments.'), end
               sz = varargin{2};
               if isempty(sz)|any(sz<=0), error('Cannot make an empty image array.'), end
               sz = [sz,ones(1,2-length(sz))];
               sz = num2cell(sz);
               out = dip_image;
               out(sz{:}) = dip_image;
               return;
            case 'zeros'
               % Undocumented feature: DIP_IMAGE('zeros',[size],[datatype])
               if nargin > 3, error('Wrong number of input arguments.'), end
               sz = varargin{2};
               if nargin == 3
                  dip_type = di_diptype(varargin{3});
               else
                  dip_type = 'sfloat';
               end
               dims = length(sz);
               switch dims
                  case 0
                     sz = [1,1];
                  case 1
                     sz = [1,sz];
                  otherwise
                     sz = sz([2,1,3:end]);
               end
               if any(sz==0)
                  in = di_convert([],di_mattype(dip_type));
                  dims = 0;
               else
                  in = di_create(sz,di_mattype(dip_type));
               end
               trust_me = 1;
            case 'trust_me'
               % Undocumented feature: DIP_IMAGE('trust_me',DATA,TYPE,DIMS[,PHYSDIMS])
               if nargin~=4 & nargin~=5, error('Wrong number of input arguments.'), end
               in = varargin{2};
               dip_type = varargin{3};
               dims = varargin{4};
               if ~ischar(dip_type) | ~isnumeric(dims)
                  error('You asked me to trust you, but I can''t.')
               end
               if nargin==5
                  physDims = varargin{5};
                  if ~isstruct(physDims) | ~isfield(physDims,'PixelSize') | ~isfield(physDims,'PixelUnits') ...
                   | ~isnumeric(physDims.PixelSize) | ~iscellstr(physDims.PixelUnits)
                     % Is this too much of a test? We don't test for much else in this mode...
                     error('You asked me to trust you, but I can''t.')
                  end
               end
               trust_me = 1;
            otherwise
               error('Data must be numeric.');
         end
      else
         if nargin ~= 2, error('Wrong number of input arguments.'), end
         if di_isdipimobj(in)
            N = prod(imarsize(in));
            if N > 1
               % It is an image array. Iterate.
               if iscolor(in)
                  col = in(1).color;
               else
                  col = '';
               end
               for ii=1:N
                  in(ii) = dip_image(in(ii),varargin{2});
                  in(ii).color = col;
               end
               out = in;
               return
            end
            dims = in.dims;
            physDims = in.physDims;
            in = in.data;
         elseif iscell(in)
            tmp = dip_image;
            sz = num2cell(size(in));
            out = tmp;
            out(sz{:}) = tmp;
            for ii=1:prod(sz);
               out(ii) = dip_image(in{ii},varargin{2});
            end
            return;
         else
            if islogical(in)
               in = uint8(in);
            elseif ~isnumeric(in)
               error('Data must be numeric.');
            end
            if issparse(in), in = full(in); end
            [in,dims] = getdipndims(in);
         end
         dip_type = di_diptype(varargin{2});
      end
end

if ~trust_me
   switch dip_type
      case 'bin'
         if ~isreal(in), error('Cannot convert complex image to real image.'); end
         in = uint8(in);
         in = di_forcebin(in);
      case {'uint8','uint16','uint32','sint8','sint16','sint32','sfloat','dfloat'}
         if ~isreal(in), error('Cannot convert complex image to real image.'); end
         in = di_convert(in,di_mattype(dip_type));
      case {'scomplex','dcomplex'}
         in = di_convert(in,di_mattype(dip_type));
         if isreal(in), in=complex(in); end
      otherwise
         error('Unknown dip_type.')
   end
end

if isempty(physDims)
   % If we haven't set the physDims struct yet, use the default
   physDims = di_defaultphysdims(dims);
end

s = struct('data',in,'dip_type',dip_type,'dims',dims,'color','','physDims',physDims);
out = class(s,'dip_image');


function [in,dims] = getdipndims(in)
siz = size(in);
if isempty(in) | all(siz==1)
   dims = 0;
elseif length(siz)==2 & any(siz==1)
   dims = 1;
   in = reshape(in,1,max(siz));
else
   dims = ndims(in);
end
