%BILATERALF   Bilateral filter with different implementations
%
% SYNOPSIS:
%  image_out = bilateralf(image_in,spatialSigma,tonalSigma,truncation,method)
%
% PARAMETERS:
%  spatialSigma = sigma of the Gaussian spatial weight
%  tonalSigma = sigma of the Gaussian tonal weight
%  method = one of 'full', 'xysep', 'uvsep', 'arc', 'pwlinear'
%
% DEFAULTS:
%  spatialSigma = [2 2]
%  tonalSigma = 30.0
%  truncation = 2
%  method = 'xysep'
%
% EXAMPLES:
%  a = noise(readim,'gaussian',10)
%  b = bilateralf(a,2,20,3,'full')
%  c = bilateralf(a,2,20,3,'xysep')
%  d = bilateralf(a,3,10,3,'arc')
%  e = bilateralf(a,3,10,3,'uvsep')
%  ans=bilateralf(a,3,10,3,'pwlinear')
%
% LITERATURE:
%  C. Tomasi & R. Manduchi, Bilateral filtering for Gray and Color Images,
%   ICCV'98, New Delhi, 1998, 836-846
%  T.Q. Pham & L.J. van Vliet, Separable bilateral filter for fast video processing, IEEE Int. Conf.
%   on Multimedia & Expo, Amsterdam, 2005
%
% SEE ALSO: arcf

% (C) Copyright 1999-2003               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham, December 2003.

function image_out = bilateralf(varargin)

d = struct('menu','Adaptive Filters',...
           'display','Bilateral filter',...
           'inparams',struct('name',       {'image_in',   'spatialSigma', 'tonalsigma',     'truncation',       'method'},...
                             'description',{'Input image','Spatial sigma','Intensity sigma','spatial truncation','implementation'},...
                             'type',       {'image',      'array',        'array',          'array',            'option'},...
                             'dim_check',  {0,            1,              0,                0,                  0},...
                             'range_check',{[],           'R+',           'R',              'R+',               {'full','pwlinear','xysep','uvsep','arc'}},...
                             'required',   {1,            0,              0,                0,                  0},...
                             'default',    {'a',          2.0,            30.0,             2,                  'xysep'}...
                            ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
%           'output_select',1 ...
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      image_out = d;
      return
   end
end
try
   [image_in,spatialSigma,tonalSigma,truncation,method] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if strcmp(method,'full')
   image_out = dip_bilateralfilter(image_in,[],spatialSigma,tonalSigma,truncation);

elseif strcmp(method,'pwlinear')
   if length(size(image_in))==2
      % faster than full 2D but still slower than separable
      bins = selectChannels(image_in);
      image_out = dip_quantizedbilateralfilter(image_in,[],spatialSigma,tonalSigma,bins,truncation);
   elseif length(size(image_in))==3
      % must do sub-images here for big images, esp for 3D images -> save memory
      [w,h,l] = size(image_in);
      image_out = newim([w h l]);
      for x=0:64:w-1
      for y=0:64:h-1
      for z=0:64:l-1
         row = [x:min(x+63,w-1)];
         col = [y:min(y+63,h-1)];
         len = [z:min(z+63,l-1)];
         in = image_in(row,col,len);
         bins = selectChannels(in);
         out = dip_quantizedbilateralfilter(in,[],spatialSigma,tonalSigma,bins,truncation);
         clear in;    % try to save some memory on the fly
         image_out(row,col,len) = out;
         clear out;
      end
      end
      end
   end

elseif strcmp(method,'xysep')
   % xy-separable as done in gaussf, much faster than brute-force method
   % little bit smoother because 2 bilateral filtering is done in x & y dimensions
   % also note that bilateralf(a) ~= shiftdim(bilateralf(shiftdim(a,2)),2)
   % if image is noisy, should use a good initial estimate for the next dimension
   image_out = dip_bilateral(image_in,[],ones(1,length(size(image_in))),spatialSigma,tonalSigma,truncation);

elseif strcmp(method,'uvsep')
   % not much faster than doing it directly in 2D since spatialSigma is small
   % however, may be faster in 3D. Also: spatialSigma must be the same on all dimensions
   if length(size(image_in))==2
      phi = structuretensor(image_in,1,spatialSigma(1),{'orientation'});
      % the first bilateral filtering along local orientation
      image_tmp = arcf(image_in,newimar(phi,phi*0+spatialSigma(1)), tonalSigma);
      % the second bilateral filtering along perpendicular orientation
      image_out = arcf(image_tmp,newimar(phi+pi/2,phi*0+spatialSigma(1)), tonalSigma);
   elseif length(size(image_in))==3
      [phi1, theta1, phi2, theta2, phi3, theta3] = ...
          structuretensor3d(image_in,1,spatialSigma(1), ...
             {'phi1', 'theta1', 'phi2', 'theta2', 'phi3', 'theta3'});
      % the first bilateral filtering along local orientation(1)
      image_tmp = arcf(image_in,newimar(phi3,theta3,phi1*0+spatialSigma(1)),tonalSigma);      
      % the second bilateral filtering along local orientation(2)
      image_tmp = arcf(image_tmp,newimar(phi2,theta2,phi1*0+spatialSigma(1)),tonalSigma);
      % the third bilateral filtering along gradient direction
      image_out = arcf(image_tmp,newimar(phi1,theta1,phi1*0+spatialSigma(1)),tonalSigma);      
   end

elseif strcmp(method,'arc')
   % for image with low noise, 1D bilateral filtering is good enogh
   % however, image with high noise, 1D contain 2 little sample
   % -> not good for flat region -> need separable bilateral filltering
   if length(size(image_in))>2
      error('3D arc bilateral filter not supported');
   end
   phi = structuretensor(image_in,1,spatialSigma(1),{'orientation'});
   image_out = arcf(image_in,newimar(phi,phi*0+spatialSigma(1)), tonalSigma);
end

% chan = selectChannels(in, minDistPC, minSamplePC, nbins)
%
% The selection is based on sample density of the histogram
% Used in piecewise-linear bilatearl filtering
%
% SEE ALSO: bilateralf
function chan = selectChannels(in, minDistPC, minSamplePC, nbins)

% @ most 10 channels, should use 5% for MRI image with 2 close tissue intensities
if nargin<2|isempty(minDistPC) minDistPC = 10; end
% good coverage 4 @ least 99% of all pixels
if nargin<3|isempty(minSamplePC) minSamplePC = 1; end
% diphist default
if nargin<4|isempty(nbins) nbins = 256; end

[h,b] = diphist(in,'all',nbins);
minDist = floor(minDistPC * nbins / 100);
minSample = minSamplePC * sum(h) / 100;

bins = [1, minDist+selectBins(h(1+minDist:end-minDist), minDist, minSample), nbins-1];
chan = b(bins);

if nargout==0
   % Draw it.
   figure;
   stem(b,h,'b.-');
   Y = axis; Y(1) = b(1); Y(2) = b(end);
   axis(Y);
   hold on
   % title('Automatic channel selection','FontSize',16 );
   % xlabel('intensity','FontSize',16 )
   % ylabel('occurence','FontSize',16 )
   for x=chan
      plot([x x],[0 max(h)*1.1],'--');
   end
end



% recursive bin selection that ensure minimum distance b/w most selected bins,
% and no histogram section with more than minSample samples is left uncovered
function bins = selectBins(hist, minDist, minSample)

if isempty(hist) | sum(hist)<minSample
   bins = [];

else
   [V,I] = max(hist);
   ind = I(1);
   bins = [selectBins(hist(1:ind-minDist), minDist, minSample), ...
        ind, ...
        ind+minDist + selectBins(hist(ind+minDist:end), minDist, minSample)];
end

