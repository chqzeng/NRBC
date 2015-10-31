%HIST_EQUALIZE   Histogram equalization
%
% SYNOPSIS:
%  image_out = hist_equalize(image_in,histogram_in)
%
% PARAMETERS:
%  histogram_in: Histogram to match. The output will have a histogram
%                as close as possible to the histogram of this image.
%                Give [] to generate a histogram that is as flat as
%                possible (the traditional histogram equalization).
%
% DEFAULTS:
%  histogram_in = [].
%
% EXAMPLE 1: Match the histogram of another image
%  a = readim('trui');
%  diphist(a,32,'bar'), title('original histogram')
%  b = readim('orka');
%  diphist(b,32,'bar'), title('histogram to match')
%  c = hist_equalize(a,diphist(b));
%  diphist(c,32,'bar'), title('matched histogram')
%
% EXAMPLE 2: Force the histogram of an image to be Gaussian
%  a = readim('trui');
%  diphist(a,32,'bar'), title('original histogram')
%  h = exp(-(((0:255)-128)/60).^2);
%  b = hist_equalize(a,h)
%  diphist(b,32,'bar'), title('modified histogram')
%
% NOTES:
%  The bins of HISTOGRAM_IN are assumed to correspond to integer grey
%  values starting at 0. That is, BINS = 0:LENGTH(HISTOGRAM_IN)-1.
%  These bin numbers correspond to the generated output grey values.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% (C) Copyright 2013, Patrik Malm & Cris Luengo,
% Centre for Image Analysis, Uppsala, Sweden.
%
% Cris Luengo, September 2000.
% 4 December 2001: Catching dfloat bug in dip_histogram.
% 8 March 2002:    Catching dfloat bug in dip_histogram in a better way.
% 9 April 2002:    Replacing dip_histogram() by diphist(). (MvG)
% 11 July 2013:    Added histogram matching option and 2nd input argument. (PM & CL)

function image_out = hist_equalize(varargin)

d = struct('menu','Point',...
           'display','Histogram equalization',...
           'inparams',struct('name',       {'image_in','histogram_im'},...
                             'description',{'Input image','Histogram to match'},...
                             'type',       {'image','array'},...
                             'dim_check',  {0,-1},...
                             'range_check',{[],'R+'},...
                             'required',   {1,0},...
                             'default',    {'a','[]'}...
                              ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
           );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      image_out = d;
      return
   end
end
try
   [image_in,hist_in] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if strcmp(datatype(image_in),'dfloat')
   image_in = dip_image(image_in,'sfloat');
end

% Get normalised cumulative histogram
nbins = 256; % Assuming the output should be between 0 and 255.
min_val = min(image_in);
max_val = max(image_in);
interval = (max_val-min_val)/(nbins-1);
[histogram, bins] = diphist(image_in,[min_val,max_val],nbins);
cumhist = cumsum(histogram);
cumhist = cumhist/cumhist(end)*(nbins-1);

% Catch rounding errors etc. by providing safety margins
bins = [min_val-2*interval,bins,max_val+2*interval];
cumhist = [0,cumhist,nbins-1];

% Map pixel values to new values using linear interpolation
% bins -> cumhist
image_out = interp1(bins,cumhist,double(image_in),'*linear');

if ~isempty(hist_in)

   % Remove zeros from hist_in (these mess with interpolation)
   hist_in = hist_in(:)';
   bins = 0:length(hist_in)-1;
   I = hist_in>0;
   bins = bins(I);
   hist_in = hist_in(I);
   % Get normalized cumulative version of hist_in
   cumhist = cumsum(hist_in);
   cumhist = cumhist/cumhist(end)*(nbins-1);

   % Map pixel values to new values using linear interpolation
   % cumhist -> bins
   image_out = interp1(cumhist,bins,image_out,'linear');
   
end

image_out = dip_image(image_out,'sfloat');
