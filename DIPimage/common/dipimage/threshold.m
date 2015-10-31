%THRESHOLD   Thresholding
%
% SYNOPSIS:
%  [out, th_value] = threshold(in,type,parameter)
%
% PARAMETERS:
%  type: string, one of:
%     'isodata':    Thresholding using the Isodata algorithm
%                   by Ridler and Calvard (1978)
%                   (dip_isodatathreshold also allows mask image).
%     'otsu'        Thresholding using maximal inter-class variance method
%                   by Otsu (1979).
%     'minerror'    Thresholding using minimal error method
%                   by Kittler and Illingworth (1986).
%     'triangle':   Thresholding using chord method
%                   (a.k.a. skewed bi-modality, maximum distance to triangle)
%                   by Zack, Rogers and Latt (1977).
%     'background': Thresholding using unimodal background-symmetry method.
%     'fixed':      Thresholding at a fixed value.
%     'double':     Thresholding between two fixed values.
%     'volume':     Thresholding to obtain a given volume fraction.
%     'hysteresis': From the binary image (in>low) only those regions are
%                   selected for which at least one pixel is (in>high)
%
%  parameter ('isodata'):    The number of thresholds to compute. If not
%                            equal to 1, the output image is a labelled image
%                            rather than binary. Inf means 1.
%            ('background'): Distance to the peak where we cut off, in
%                            terms of the half-width at half the maximum.
%                            Inf selects the default value, which is 2.
%            ('fixed'):      Threshold value. Inf means halfway between
%                            minimum and maximum value. Use a vector with
%                            multiple values to produce a labelled image
%                            with multiple classes.
%            ('double'):     Two threshold values. Inf means
%                            min+[1/3,2/3]*(max-min).
%            ('volume'):     Parameter = the volume fraction. Inf means 0.5.
%            ('hysteresis'): Two values: [low,high] (see above)
%
% DEFAULT:
%  type:      'isodata'
%  parameter: Inf (means: use default for method)
%
% See Also DIP_RANGETHRESHOLD, DIP_HYSTERESISTHRESHOLD, DIP_ISODATATHRESHOLD.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
% Bernd Rieger, May 2001.
% with code by Lucas van Vliet and Cris Luengo
% 31 August    2001 (CL):  Added 'double' method after comments by Geert.
% 11 September 2001 (CL):  'double' method now uses dip_rangethreshold.
% 14 September 2001 (CL):  Fixed 'background' method. Vectorized 'triangle' method.
% 25 September 2001 (CL):  Fixed small bug in 'triangle' and 'background' methods.
%  8 March     2002 (CL):  Catching dfloat bug in dip_histogram in a better way.
%  9 April     2002 (MvG): Replacing dip_histogram() by diphist().
%  9 October   2002 (MvG): Added "kmeans" alias for "isodata".
% 20 October   2002 (MvG): Added "volume" method.
% 23 March     2004 (BR):  Integrated "hystersis" method from KvW
%                          return threshold value also in menu.
%  1 April     2004 (KvW): Changed "hystersis" to "hysteresis"
%                          Threshold value high can be lower than threshold value low
%                          which will yield the same result as fixed thresholding.
%  8 April     2004 (CL):  Added check for binary or complex input image.
%  8 April     2005 (CL):  Reorganized file by making sub-functions.
% 26 August    2005 (CL):  Multiple thresholds for isodata.
%  6 April     2006 (CL):  Using new k-means clustering algorithm w/out random init.
%  4 February  2008 (CL):  Added Otsu's method and minimum error method.
% 15 September 2011 (CL):  Giving a sensible error when the image is constant.
%  8 February  2013 (CL):  Multiple thresholds in 'fixed' threshold mode.
% 14 April     2014 (CL):  Fixed: 'background' mode would fail in some situations.

function [varargout] = threshold(varargin)

d = struct('menu','Segmentation',...
           'display','Threshold',...
           'inparams',struct('name',       {'in','type','parameter'},...
                  'description',{'Input image','Type','Parameter'},...
                  'type',       {'image','option','array'},...
                  'dim_check',  {0,0,-1},...
'range_check',{'real',{'isodata','otsu','minerror','triangle','background','fixed','double','volume','hysteresis'},[]},...
                  'required',   {1,0,0},...
                  'default',    {'a','isodata',Inf}...
                   ),...
           'outparams',struct('name',{'out','thres'},...
                   'description',{'Output image','Threshold value'},...
                   'type',{'image','array'}...
                   )...
           );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      varargout{1} = d;
      return
   end
end
%%% aliases for elements in the 'type' list.
if nargin>=2 & ischar(varargin{2})
   if strcmpi(varargin{2},'kmeans')
      varargin{2} = 'isodata';
   end
end

try
   [in,type,parameter] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

switch type

   case 'isodata'
      if ~isfinite(parameter)
         parameter = 1;        % Default value
      end
      if length(parameter)~=1 | parameter<=0 | mod(parameter,1)~=0
         error('Positive scalar integer value expected as parameter for ''isodata'' method.')
      end
      parameter = isodatathreshold(in,parameter);
      if length(parameter)==1
         out = in>=parameter;
      else
         out = newim(in,'uint16');
         for ii=1:length(parameter)
            out(in>=parameter(ii)) = ii;
         end
      end
      varargout{1} = out;
      varargout{2} = parameter;

   case 'otsu'
      varargout{2} = otsuthreshold(in);
      varargout{1} = in >= varargout{2};

   case 'minerror'
      varargout{2} = minerrorthreshold(in);
      varargout{1} = in >= varargout{2};

   case 'triangle'
      varargout{2} = trianglethreshold(in);
      varargout{1} = in >= varargout{2};

   case 'background'
      if length(parameter)~=1 | parameter<=0
         error('Positive scalar value expected as parameter for ''background'' method.')
      end
      if ~isfinite(parameter)
         parameter = 2;        % Default value
      end
      varargout{2} = backgroundthreshold(in,parameter);
      varargout{1} = in >= varargout{2};

   case 'fixed'
      if any(~isfinite(parameter))
         parameter = (max(in)+min(in))/2;
      end
      if length(parameter)==1
         out = in>=parameter;
      else
         out = newim(in,'uint16');
         for ii=1:length(parameter)
            out(in>=parameter(ii)) = ii;
         end
      end
      varargout{1} = out;
      varargout{2} = parameter;

   case 'double'
      if any(~isfinite(parameter))
         mn = min(in);
         threshold_new = mn + [1/3,2/3]*(max(in)-mn);
      elseif length(parameter)~=2
         error('Two values expected as parameter for ''double'' method.')
      else
         threshold_new = parameter;
         if threshold_new(1) > threshold_new(2)
            threshold_new = threshold_new([2,1]);
         end
      end
      varargout{1} = dip_rangethreshold(in,threshold_new(1),threshold_new(2),1,0,1);
      varargout{2} = threshold_new;

   case 'volume'
      fraction = 0.5;
      if length(parameter)>0
         if isfinite(parameter(1))
            fraction = parameter(1);
         end
         if fraction<0 | fraction>1
            error('Volume fraction must be in range [0;1]');
         end
      end
      if length(parameter)>1
         error('Volume fraction method has exactly one parameter');
      end
      varargout{2} = percentile(in,100*(1-fraction));
      varargout{1} = in >= varargout{2};

   case 'hysteresis'
      if length(parameter)~=2
         error('Two values expected as parameter for ''hystersis'' method.')
      end
      varargout{1} = dip_hysteresisthreshold(in,parameter(1),parameter(2));
      varargout{2} = parameter;

   otherwise
      error('Unknown threshold method.');
end


%
% A smooth histogram
%
function [histogram,bins] = smoothhistogram(in,sigma,border,N)
if nargin<4
   N = 200;
end
if nargin<3
   border = 2*sigma;
end
min_val = min(in);
max_val = max(in);
if min_val==max_val
   error('The image is constant.')
end
if strcmp(datatype(in),'uint8')
   interval = 1;
   N = max_val-min_val+1;
else
   interval = (max_val-min_val)/(N-1);
end
max_val = max_val+border*interval;
min_val = min_val-border*interval;
[histogram,bins] = diphist(in,[min_val,max_val],N);
if sigma>0
   histogram = double(gaussf(histogram,sigma));
end


%
% Triangle threshold
%
function value = trianglethreshold(in)

% A smooth histogram
border = 16;
[histogram,bins] = smoothhistogram(in,4,border);

% Find peak
[max_value,max_element] = max(histogram);

% Define: start, peak, stop positions in histogram
sz = length(histogram);
left_bin  = [border,histogram(border)];
right_bin = [sz-border,histogram(sz-border)];
top_bin   = [max_element,max_value];

% Find the location of the maximum distance to the triangle
v1 = top_bin - left_bin;
if any(v1~=0)
   v1 = v1/norm(v1);
end
ii = left_bin(1):top_bin(1);
v2 = [ii'-left_bin(1),histogram(ii)'-left_bin(2)];
distance = abs(v1(1).*v2(:,2)-v1(2).*v2(:,1));
v1 = top_bin - right_bin;
if any(v1~=0)
   v1 = v1/norm(v1);
end
jj = top_bin(1):right_bin(1);
v2 = [jj'-right_bin(1),histogram(jj)'-right_bin(2)];
distance = [distance;abs(v1(1).*v2(:,2)-v1(2).*v2(:,1))];
[max_distance,bin] = max(distance);
ii = [ii,jj];
bin = ii(bin);
value = bins(bin);

% Lucas' old code:
%bin = 0;
%v1 = top_bin - left_bin;
%if v1 ~= 0
%   v1 = v1 / sqrt(v1*v1'); % Normalize the vector
%end
%max_distance = 0;
%for ii = left_bin(1):top_bin(1)
%   pos = [ii, histogram(ii)];
%   v2 = pos - left_bin;
%   D = [v1; v2];
%   distance = sqrt(det(D*D'));
%   if distance > max_distance;
%      max_distance = distance;
%      bin = ii;
%   end
%end
%v1 = top_bin - right_bin;
%v1 = v1 / sqrt(v1*v1'); % Normalize the vector
%for ii = top_bin(1):right_bin(1)
%   pos = [ii, histogram(ii)];
%   v2 = pos - right_bin;
%   D = [v1; v2];
%   distance = sqrt(det(D*D'));
%   if distance > max_distance
%      max_distance = distance;
%      bin = ii;
%   end
%end


%
% Background threshold
%
function value = backgroundthreshold(in,parameter)
% A smooth histogram
[histogram,bins] = smoothhistogram(in,4);

% Find peak
[max_value,max_element] = max(histogram);

% Is the peak on the left or right side of the histogram?
rightpeak = max_element > (length(bins)/2);

% Find the 50% height & the theshold
if rightpeak
   sigma = find(histogram(max_element:end) < (max_value/2));
   if length(sigma) ~= 0
      sigma = sigma(1) - 1;
   else
      sigma = 1;
   end
   value = bins(max_element - sigma*parameter);
else
   sigma = find(histogram(1:max_element) < (max_value/2));
   if length(sigma) ~= 0
      sigma = max_element - sigma(end);
   else
      sigma = 1;
   end
   value = bins(max_element + sigma*parameter);
end


%
% Isodata threshold
% (like dip_isodatathrehsold, but deterministic: doesn't use random initialization)
function value = isodatathreshold(in,num)
[histogram,bins] = smoothhistogram(in,0);
binsize = bins(2)-bins(1);
cumh = cumsum(histogram);
value = zeros(num,1);
for ii=1:num
   jj = find(cumh > ii*cumh(end)/(num+1));
   if isempty(jj)
      value(ii) = length(cumh);
   else
      value(ii) = jj(1);
   end
end
value = [bins(1)-binsize,bins(value),bins(end)+binsize];
oldval = value*inf;
minchange = binsize/10;
while any(abs(value-oldval) > minchange)
   m = zeros(1,num+1);
   for ii=1:num+1
      I = bins>=value(ii) & bins <= value(ii+1);
      m(ii) = sum(bins(I).*histogram(I)) / sum(histogram(I));
   end
   oldval = value;
   value(2:end-1) = (m(1:end-1)+m(2:end))/2;
end
value = value(2:end-1);


%
% Otsu's threshold
%
function value = otsuthreshold(in)
[histogram,bins] = smoothhistogram(in,0);
% w1(t),w2(t) are the probabilities of each of the halfs of the histogram thresholded between bins(t) and bins(t+1)
w1 = cumsum(histogram);
w2 = w1(end)-w1;
% m1(t),m2(t) are the corresponging centers of gravity
m1 = cumsum(histogram.*bins);
m2 = m1(end)-m1;
m1 = m1./w1;
m2 = m2./w2;
% ss(t) is Otsu's measure for inter-class variance
ss = w1.*w2.*(m1-m2).^2;
ss = ss(1:end-1);    % the last one doesn't have any meaning...
I = find(ss==max(ss));
if length(I)~=1
   % Are the indices consecutive?
   if max(I)-min(I) == length(I)-1
      value = (bins(I(1))+bins(I(end)+1))/2;
   else
      error('More than one optimal value found!?!?!?');
   end
else
   value = (bins(I)+bins(I+1))/2; % The found threshold is halfway between two bins.
end


%
% minimal error threshold
%
function value = minerrorthreshold(in)
[histogram,bins] = smoothhistogram(in,0);
% w1(t),w2(t) are the probabilities of each of the halfs of the histogram thresholded between bins(t) and bins(t+1)
w1 = cumsum(histogram);
x = w1(end);
w1 = w1(1:end-1);
w2 = x-w1;
% m1(t),m2(t) are the corresponging centers of gravity
m1 = cumsum(histogram.*bins);
x = m1(end);
m1 = m1(1:end-1);
m2 = x-m1;
m1 = m1./w1;
m2 = m2./w2;
% v1(t),v2(t) are the corresponding variances
v1 = zeros(size(m1));
v2 = v1;
for ii=1:length(v1)
   v1(ii) = sum(histogram(   1:ii ).*(bins(   1:ii )-m1(ii)).^2) / w1(ii);
   v2(ii) = sum(histogram(ii+1:end).*(bins(ii+1:end)-m2(ii)).^2) / w2(ii);
end
% J(t) is the measure for error
J = 1 + w1.*log(v1) + w2.*log(v2) - 2*(w1.*log(w1)+w2.*log(w2));
% b(t) are the corresponding thresholds
b = (bins(1:end-1)+bins(2:end))/2;
while 1
   if isempty(J)
      error('No minimum found in error measure. Histogram is unimodal.')
   end
   I = find(J==min(J));
   % Ignore points at the edges
   while ~isempty(I) & I(1)==1
      I(1) = [];
      J(1) = [];
      b(1) = [];
      I = I-1;
   end
   while ~isempty(I) & I(end)==length(J)
      I(end) = [];
      J(end) = [];
      b(end) = [];
   end
   if isempty(I)
      continue;
   end
   % Make sure there's only one minimum
   if length(I)~=1
      % Are the indices consecutive?
      if max(I)-min(I) ~= length(I)-1
         error('More than one optimal value found!?!?!?');
      end
   end
   value = (b(I(1))+b(I(end)))/2; % If there are more than one sample in the minimum, take the half-way point.
   break;
end
