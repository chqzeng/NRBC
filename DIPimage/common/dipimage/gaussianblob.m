%GAUSSIANBLOB  Adds Gauss shaped spots to an  image
%
% SYNOPSIS:
%  image_out = gaussianblob(image_in, coordinates, sigma, strength, domain, truncation)
%
%  image_in:    input image, where the spots will be set
%  image_out:   image_in + spots
%  coordinates: NxD array containing the location of the spots 
%               D = NDIMS(IMAGE_IN)
%  sigma:       the sigmas of the gaussians, NxD array
%  strength:    the integrated intensity of the spots, Nx1 array
%  domain:      'spatial' or 'frequency'
%    SPATIAL:   the image is in the spatial domain
%               STRENGTH is defined such that the integral over the spot is:
%                    strength * (2pi sigma^2)^(-imagedimension/2) * exp(-1/2 (x/sigma)^2)
%    FREQUENCY: the image is in the frequency domain
%               COORDINATES is in frequency domain units, in the range (-0.5,0.5)
%               SIGMA is in spatial domain units
%               STRENGTH is defined such that the integral over the spot is:
%                    strength / (sqrt(sum(pixels))) * exp(-1/2 (sigma 2 pi f)^2)
%  truncation:  gives the region in which the blob is computed. For the spatial
%               domain, truncation*sigma is the radius of the region being computed.
%               For the frequency domain, truncation/(2*pi*sigma) is the radius.
%
% DEFAULTS:
%  sigma = 2
%  strength = 255
%  domain = 'spatial'
%  truncation = 3

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Apr 2001
% 30 April 2004: Added 'truncation' parameter. (CL)
% 5 May 2004   : Output bug fix (BR)
% November 2005: Added possibility of anisotropic sigma (BR)
% October 2006:  Improved speed for large images and small blobs. (CL)
% 5 April 2007:  Fixed bug for non-integer coordinates.
%                Fixed bug for normalization in spatial coordinates.
%                Fixed bug for truncation in frequency domain. (CL)
% 1 Feb 2013:    The option 'freq' was called 'frequency' in documentation. Fixed. (CL)
% Aug 2013:      Added possibility to add _fast_ multiple Gaussians with one call (BR)
% 27 Oct. 2014:  Rewrite to fix inconsistencies in the definition of input params.
%                Is equally fast now for multiple blobs in any number of dims. (CL)

function in = gaussianblob(varargin)

d = struct('menu','Generation',...
           'display','Add Gaussian blob',...
           'inparams',struct('name',       {'in',         'coord',      'sigma','strength','domain','truncation'},...
                             'description',{'Input image','Coordinates','Sigma','Strength','Domain','Truncation'},...
                             'type',       {'image',      'array',      'array','array',   'option','array'},...
                             'dim_check',  {0,            [-1,-1],      [-1,-1],-1,        0,       0},...
                             'range_check',{[],           'R',          'R+',   'R',{'spatial','frequency'},'R+'},...
                             'required',   {1,            1,            0,      0,         0,       0},...
                             'default',    {'a',          '[128 128]',  2,      255,      'spatial',3}...
                            ),...
           'outparams',struct('name',{'in'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
         );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      in = d;
      return
   end
end
if nargin>=5
   if isequal(varargin{5},'freq')
      varargin{5} = 'frequency';
   end
end
try
   [in,coord,sigma,strength,domain,truncation] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

sz = size(coord);
di = ndims(in);
if length(sz)~=2 || sz(2)~=di
    error('input coordinates must be a [ N x NDIMS(IMAGE_IN) ] array');
end
N = sz(1);
sz = size(in);

if size(sigma,1)==1
   sigma = repmat(sigma,N,1);
end
if size(sigma,2)==1
   sigma = repmat(sigma,1,di);
end
if size(sigma)~=[N,di]
   error('Sigmas and coordinates sizes do not match.')
end
if length(strength)==1
   strength = repmat(strength,N,1);
elseif length(strength)~=N
   error('Strength and coordinates sizes do not match.')
end

switch domain
   case 'spatial'
      normalisation = prod(sigma,2) * (sqrt(2*pi))^di;
      sigma = 1./sigma;
      origin = 'corner';
   case 'frequency'
      normalisation = sqrt(prod(size(in)));
      normalisation = repmat(normalisation,N,1);
      coord = 2*pi*coord;
      origin = 'radfreq';
      % make sure ift(frequency)=spatial therefore normalisation 1/sqrt(N)
   otherwise
      error('Unkown domain.');
end

% Create ramp images
ramp = cell(1,di);
for jj=1:di
   ramp{jj} = dip_array(createramp(sz,jj,origin));
end

% Write N blobs
dt = datatype(in);
physdims.PixelSize = in.pixelsize;
physdims.PixelUnits = in.pixelunits;
if ~dipgetpref('KeepDataType') && ~strcmp(dt,'dfloat')
   in = single(in);
   dt = 'sfloat';
else
   in = dip_array(in);
end
mdt = class(in);
for ii=1:N
   if isinf(truncation)
      s = [];
   else
      % Remember: COORD in dip_image coordinates!
      s = substruct('()',{});
      for jj = 1:di
         I = coord(ii,jj)+(truncation/sigma(ii,jj)*[-1,1]);
         if strcmp(domain,'frequency')
            I = (I+pi)*(sz(jj)/(2*pi));
         end
         I(1) = max(floor(I(1))+1,1);
         I(2) = min(ceil(I(2))+1,sz(jj));
         s.subs{jj} = I(1):I(2);
      end
      if di>1
         s.subs = s.subs([2,1,3:end]);
      end
   end
   exponent = 0;
   for jj = 1:di
      r = ramp{jj};
      if ~isempty(s)
         r = subsref(r,s);
      end
      exponent = exponent + ((r-coord(ii,jj)).*sigma(ii,jj)).^2;
   end
   blob = ((strength(ii)/normalisation(ii))*exp(-0.5*exponent));
   blob = feval(mdt,blob); % convert to MATLAB class of IN, so that the addition below works.
   if ~isempty(s)
      in = subsasgn(in,s,subsref(in,s)+blob);
   else
      in = in+blob;
   end
end
in = dip_image('trust_me',in,dt,di,physdims);
