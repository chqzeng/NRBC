%NUFFT_TYPE1   Compute uniform DFT from non-uniform grid
%
%
% SYNOPSIS:
%  image_out = nufft_type1(knots_in, coordinates, outsize, dimensions, nonuniform, direction);
% 
% PARAMETERS:
%  

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lennard Voortman, Jun 2011

function out = nufft_type1(varargin)
% TODO: make sure dimension check works on relevant input
d = struct('menu','Transforms',...
           'display','Non-uniform FFT of type 1',...
           'inparams',struct('name',       {'in',            'knots',           'outsize',    'dimensions', 'nonuniform',  'direction'},...
                             'description',{'Input Knots',   'Knots Locations', 'Output size', 'Dimensions', 'Non-Uniform', 'Direction'},...
                             'type',       {'image',         'image',           'array',     'array',       'array',       'option'},...
                             'dim_check',  {[1,2],           [],                [1,2],       {0,[1,2]},     {0,[1,2]},     []},...           
                             'range_check',{{'scalar'},      [],                'N+',        'N',           'N',           {'forward','inverse'}},...
                             'required',   {1,               1,                 1,            0,            0,             0},...                            
                             'default',    {'a',             [],                [],           1,            1,             'inverse'}...
                              ),...
           'outparams',struct('name',{'out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
           );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = d;
      return
   end
end

try
   [in, knots, outsize, dimensions, nonuniform,direction] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

% some constants
R = 2;
M_sp = 8;

dimensions = dimensions > 0;
nonuniform = (nonuniform.*dimensions) > 0;  % nonuniform only makes sense for dimensions that are being transformed


insize = imsize(in);
knotsize = imsize(knots);
outdim = 2;

if numel(dimensions) == 1
   dimensions = ones(1,2)*dimensions(1);
end
if numel(nonuniform) == 1
   nonuniform = ones(1,2)*nonuniform(1);
end
if numel(outsize) == 1
   outsize = ones(1,2)*outsize;
   outsize(nonuniform == 0) = insize(nonuniform == 0);
end

if sum(nonuniform) == 2 && insize ~= knotsize
   error('length of input does not match size of knots');
end
if sum(nonuniform) == 1 && insize(nonuniform) ~= knotsize(nonuniform)
   error('size of image and knots array does not match');
end
if sum(nonuniform) == 1 && knotsize(nonuniform == 0) ~= 1 && insize(nonuniform == 0) ~= knotsize(nonuniform == 0)
   error('size of image and knots array does not match on linked dimension');
end
if sum(nonuniform) == 0
   error('Nothing to NUFFT');
end
if prod(imarsize(knots))~=sum(nonuniform)
   error('Length of Knots array is not equal to number of dimensions to NUFFT');
end

transformsize = outsize;
transformsize(find(nonuniform)) = transformsize(find(nonuniform))*R;

% one generic solutions seems to be overly complicated. Cover all scenarios instead
switch num2str([outdim sum(nonuniform)])
   case num2str([1 1])
      %TODO
      % do actual 1D NUFFT
   case num2str([2 1])
      procdimensions = find( nonuniform ) - 1;
      procdimensions = 1 - procdimensions; %REASON: difference between dip_image and double matrix (swap xy)
      transformsize = transformsize(end:-1:1); %REASON: difference between dip_image and double matrix (swap xy)
      out = dip_image(nufft_type1_2D_low(double(in),double(knots),transformsize,procdimensions));
   case num2str([2 2])
      %full 2D NUFFT
      out = dip_image(nufft_type1_2D_low(double(in),double(knots),transformsize,-1));
   case num2str([3 1])
   case num2str([3 2])
   case num2str([3 3])
      error('Full 3D NUFFT is not supported');
   otherwise
      if outdim > 3
         error('Dimensions > 3 are not supported');
      else
         error('this is not supposed to happen');
      end
end

out = dip_fouriertransform(out,direction,double(dimensions)); % should be double instead of logical% compute FT
tau = pi*M_sp./(outsize.^2*R*(R-0.5));

% cut padded NUFFT dimensions
out = cut(out, outsize);

% for all NUFFT image dimensions multiply with Gaussian mask
for ii = 1:outdim
   if nonuniform(ii) == 1
      xramp = ramp(outsize,ii,'');
      out = out*sqrt(pi/tau(ii))*exp(tau(ii)*xramp^2);
   end
end
