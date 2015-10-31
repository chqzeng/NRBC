%NUFFT_TYPE2   Compute non-uniform DFT from uniform grid
%
%
% SYNOPSIS:
%  knots_out = nufft_type2(image_in, knots,dimensions,nonuniform,direction);
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

function out = nufft_type2(varargin)

% some constants
R = 2;
M_sp = 12;

d = struct('menu','Transforms',...
           'display','Non-Uniform FFT of type 2',...
           'inparams',struct('name',       {'in',            'knots', 'dimensions', 'nonuniform',  'direction'},...
                             'description',{'Input image',   'Knots', 'Dimensions', 'Non-Uniform', 'Direction'},...
                             'type',       {'image',         'image', 'array',      'array',       'option'},...
                             'dim_check',  {[2 3],               [],      1,            1,             []},...           
                             'range_check',{{'scalar'},      [],      'N',          'N',           {'forward','inverse'}},...
                             'required',   {1,               1,       0,            0,             0},...                            
                             'default',    {'a',             [],      1,            1,             'forward'}...
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
   [in, knots, dimensions, nonuniform,direction] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

dimensions = dimensions > 0;
nonuniform = (nonuniform.*dimensions) > 0;  % nonuniform only makes sense for dimensions that are being transformed

indim = ndims(in);
insize = imsize(in);

if ~(any(size(knots) == 1) && any(size(knots) > 1)) && sum(nonuniform) > 1 % (any(size(knots) == 1) && any(size(knots) > 1)) is a replacement for isvector
   error('Knots is not a vector image');
end
if prod(imarsize(knots))~=sum(nonuniform)
   error('Length of Knots array is not equal to number of dimensions to NUFFT');
end
if sum(nonuniform) == 0
   error('Nothing to NUFFT');
end

tau = pi*M_sp./(insize.^2*R*(R-0.5));
 
% for all NUFFT image dimensions multiply with Gaussian mask
for ii = 1:indim
    if nonuniform(ii) == 1
        xramp = ramp(insize,ii,'');
        in = in*sqrt(pi/tau(ii))*exp(tau(ii)*xramp^2);
    end
end

% pad NUFFT dimensions
newsize = insize;
newsize(nonuniform) = newsize(nonuniform)*R;
in = extend(in, newsize);

% compute FT
in = dip_fouriertransform(in,direction,double(dimensions)); % should be double instead of logical

% one generic solutions seems to be overly complicated. Cover all scenarios instead
switch num2str([indim sum(nonuniform)])
    case num2str([1 1])
        %TODO
        % do actual 1D NUFFT
    case num2str([2 1])
    	procdimensions = find( nonuniform ) - 1;
    	procdimensions = 1 - procdimensions; %REASON: difference between dip_image and double matrix (swap xy)
    	
      % out = dip_image(nufft_type2_2Dto1D_low(double(in),double(knots),procdimensions));
      out = dip_image(nufft_type2_2D_low(double(in),double(knots),procdimensions));
    case num2str([2 2])
        %full 2D NUFFT
        %out = dip_image(nufft_type2_2Dto2D_low(double(in),double(knots)));
        out = dip_image(nufft_type2_2D_low(double(in),double(knots),-1));
    case num2str([3 1])
	    if(find(nonuniform)==3)
            if size(knots,3) == 1
                error('size(knots,3) needs to be bigger than 1');
            end
            in = reshape(in,newsize(1)*newsize(2),newsize(3));
            knots = reshape(knots,newsize(1)*newsize(2),size(knots,3));
            out = dip_image(nufft_type2_2D_low(double(in),double(knots),0));
            out = reshape(out,insize(1),insize(2),size(knots,2));
        else
            error('not supported');
        end
    case num2str([3 2])
    case num2str([3 3])
        error('Full 3D NUFFT is not supported');
    otherwise
        if indim > 3
            error('Dimensions > 3 are not supported');
        else
            error('this is not supposed to happen');
        end
end

