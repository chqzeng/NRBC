%DIPHIST   Displays a histogram
%   DIPHIST(B) displays the histogram for image B, using the
%   default interval, in a new figure window.
%
%   DIPHIST(B,[MIN,MAX]) displays the histogram of the pixels
%   in the range [MIN MAX].
%
%   DIPHIST(B,'all') displays the histogram using the complete
%   interval present in the image. DIPHIST(B,[]) is the same
%   thing.
%
%   DIPHIST(B,...,n) displays the histogram using n bins.
%
%   DIPHIST(B,...,mode) displays the histogram using a different
%   plotting method instead of the default stem plot. MODE can be
%   one of: 'stem' (the default), 'bar', 'line'.
%
%   [HISTOGRAM,BINS] = DIPHIST(B,...) returns the histogram
%   values and bin centers. The histogram is not displayed if
%   an output value is given, unless one of the plot mode
%   strings is also given.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000.
% 2 September 2000:   Added two parameters to the GUI version.
% 28 November 2000:   Removed MASK parameter (useless).
% 14 September 2001:  Fixed small bug.
% 4 December 2001:    Catching dfloat bug in dip_histogram again.
% 9 April 2002 (MvG): Calling dip_mdhistogram() rather than dip_histogram().
% 12 August 2009:     Fixing bin output to actually return bin centers.
% 18 December 2009:   Now with bar and line plots

function [outhist,outbins] = diphist(in,varargin)

DIP_MDH_LOWER               =   0;
DIP_MDH_UPPER               =   1;
DIP_MDH_LOWER_UPPER_BINS    =   2;
DIP_MDH_LOWER_UPPER_BINSIZE =   3;
DIP_MDH_LOWER_PERCENTILE    =   4;
DIP_MDH_LOWER_CENTRE        =   8;
DIP_MDH_UPPER_PERCENTILE    =  16;
DIP_MDH_UPPER_CENTRE        =  32;
DIP_MDH_NO_CORRECTION       =  64;
DIP_MDH_ALL_SET             = 255;

if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   outhist = struct('menu','Statistics',...
                    'display','Histogram',...
                    'inparams',struct('name',       {'image_in','range','bins','mode'},...
                                      'description',{'Input image','Range [min,max]','Number of bins','Display mode'},...
                                      'type',       {'image','array','array','option'},...
                                      'dim_check',  {0,[1,2],0,0},...
                                      'range_check',{{'noncomplex','scalar'},[],'N+',{'stem','bar','line'}},...
                                      'required',   {1,0,0,0},...
                                      'default',    {'a',[0,255],256,'stem'}...
                                     )...
                   );
% 'outparams',[]...
   return
end

% Default values
n = 256;
mini = 0;
maxi = 255;
stretch = 0;
mode = '';

% Parse input
if nargin > 1
   ii = 1;
   while ii<nargin
      arg = varargin{ii};
      if ischar(arg)
         switch lower(arg)
         case 'all'
            stretch = 1;
         case {'stem','bar','line'}
            mode = lower(arg);
         otherwise
            error('Unknown command option.')
         end
      elseif isnumeric(arg)
         arg = double(arg);
         if length(arg)==2
            mini = arg(1);
            maxi = arg(2);
         elseif length(arg)==1
            n = arg;
         elseif length(arg)==0
            stretch = 1;
         else
            error('Error in arguments.')
         end
      else
         error('Error in arguments.')
      end
      ii = ii+1;
   end
end

% Convert input image
if isa(in,'dip_image_array')
   error('Scalar image expected.')
elseif ~isa(in,'dip_image')
   in = dip_image(in);
end
if ~isreal(in), error('Complex images not supported.'); end
if islogical(in)
   % Binary images always generate 2-bin histograms!
   mini = 0; maxi = 1; n = 2;
   stretch = 0;
end

% Fix minimum and maximum values.
if stretch
   mini = 0;
   maxi = 100;
   rtype = DIP_MDH_LOWER_UPPER_BINS+...
           DIP_MDH_LOWER_PERCENTILE+DIP_MDH_UPPER_PERCENTILE;
else
   rtype = DIP_MDH_LOWER_UPPER_BINS;
end
if maxi-mini <= 0
   mini = 0; maxi = 255;
end
if n<2
   n = 2;
end

% Do histogram.
[histogram,bins] = dip_mdhistogram(in,zeros(1,ndims(in)),[],rtype,mini,maxi,n);
bins=double(bins);
bins=(0.5:(bins(3)-0.5))*bins(2)+bins(1);
histogram = double(histogram);

if nargout>0
   % Give output data.
   outhist = histogram;
   outbins = bins;
end

if nargout==0 | ~isempty(mode)
   % Draw it.
   figure;
   switch mode
   case {'','stem'}
      stem(bins,histogram,'b.-');
   case 'bar'
      bar(bins,histogram,1,'b');
   case 'line'
      plot(bins,histogram,'b-');
   end
   dx = (bins(2)-bins(1))/2;
   set(gca,'xlim',[bins(1)-dx,bins(end)+dx]);
end
