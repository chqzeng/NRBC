%MDHISTOGRAM   Compute a Multi-dimensional histogram
%
% Invocation:
%
% histogram = mdhistogram( image, <channels>(2), <mask>(1), <channelspecs>(3) )
%
% OR
%
% histogram = mdhistogram( tensorimage, <mask>(1), <channelspecs>(2) )
%
% A traditional histogram computes the grey-value distribution of an
% image, the result being a one-dimensional histogram. This function
% extends that notion to multi-valued data.
%
% The reason that there are two invocation styles is that there are ways
% of representing multi-valued data. The first (read proper - MvG) is to
% use extra dimensions. The second way is to use a separate image for each
% channel. In DIPimage these separate images are collectively stored in
% an dip_image_array or tensor image.
%
% Example 1, using extra dimensions. We create a 256x256 image with two
% channels:
%
% mchim=newim([256 256 2]);
% mchim(:,:,0)=xx([256 256],'corner');
% mchim(:,:,1)=100;
% % The histogram is computed as follows:
% histim=mdhistogram(mchim,[0 0 1],...
%    {{'lower',0,'upper',256,'bins',256,'lower_abs','upper_abs'},...
%     {'lower',0,'upper',256,'bins',256,'lower_abs','upper_abs'}});
%
% Never mind the last argument for now. The array [0 0 1] tells the
% routine that the first two dimensions are "normal" spatial dimensions,
% whereas the third dimension is used to store the components of the
% multi-valued data. Multiple dimensions may be used for this purpose.
%
% Now the same using the other representation:
%
% mchim1=xx([256 256],'corner');
% mchim2=0*mchim1+100;
% mchim=newimar(mchim1,mchim2);
% % The histogram is computed as follows:
% histim=mdhistogram(mchim,...
%    {{'lower',0,'upper',256,'bins',256,'lower_abs','upper_abs'},...
%     {'lower',0,'upper',256,'bins',256,'lower_abs','upper_abs'}});
%
% The optional mask determines whether a given pixel contributes to the
% histogram or not. If the mask is binary this is a matter of yes or no,
% otherwise the mask is used to control how much a given pixel contributes.
% In other words, if a pixel is set to "1.5" in the mask, that pixel with
% contribute "1.5" times as much as a pixel with value "1" in the mask.
% The mask should have the same number as spatial dimensions as the image.
%
% The last argument is used to specify the dimensions and amount of bins
% of the histogram. It consists of a cell array. It should contain as much
% elements as there are channels. In the case of a 256x256x2x3 image with
% the last two dimensions used for storing the multi-valued data elements,
% this means that there have to be 6 bin specification elements. One for
% im(:,:,0,0), one for im(:,:,1,0), im(:,:,0,1), etc... For the alternative
% representation there should be one for im{1}, im{2}, etc... One bin
% specification element consists of a cell array. This array consists of
% keyword-value combinations or keywords.
%
% The data range for each multi-valued element should be specified using
% three out of the following four keyword-value combinations:
%
% 'lower'    lower limit value (expressed as a percentile of the data range.
%                               It is a number between 0 and 100).
% 'upper'    upper limit value (also a percentile).
% 'bins'     the number of bins used for quantisation of the data range.
% 'binsize'  the size of these bins.
%
% 'lower_abs'     Changes the meaning of the argument of 'lower'. Instead of
%                 a percentile it is directly interpreted as the lower limit
%                 of the data range. It has nothing to do with your six-pack.
% 'upper_abs'     Same as 'lower_abs', but for 'upper'.
% 'lower_centre'  The lower limit normally specifies the lowest value contained
%                 in the lowest bin. If this option is given, it is used to
%                 specify the value of the middle of the lowest bin.
% 'upper_centre'  Same as 'lower_centre', but for 'upper'.
% 'no_correction' Due to floating point round-off effects, some points
%                 will fall outside the range, which should really fall
%                 inside. If the lower and upper limit are automatically
%                 selected used percentile values '0' and '100' you'd expect
%                 that all points fall within the range, but this is
%                 unfortunately not true. To prevent this the lower limit
%                 is decreased by 1/1000 of the size of a bin, and the upper
%                 limit is increased by the same amount. If you do not want
%                 this correction, specify this flag.
%
% Handling of defaults:
% First of all, except for the input image, any of the parameters may
% be passed an empty (that is: [] or {} or '') to indicate that a default
% should be used. In addition parameters may be left out completely. This
% is where the numbers shown in the invocation come in. If one parameter
% is left out, is assumed to be the mask [hence the label (1)]. If two
% parameters are left out, they are assumed to be the mask and the channels
% parameter in invocation style 1, or the mask and the channelspecs parameter
% in invocation style 2. Omitting a parameter is the same as passing an
% empty. The defaults are:
%
% mask      - i.e. none
% channels  - does not correspond to any choice of channels. It indicates
%             that there is one implicit channel. Think of it as if there
%             were a single singleton dimension present along which the
%             channel is stored. Anyway, the result is a one-dimensional
%             histogram.
% channelspecs - {'lower',0,'upper',100,'bins',100} for each channel
%
% % These are all equivalent:
% a=readim;
% b=mdhistogram(a,[],[],{{'lower',0,'upper',100,'bins',100}})
% c=mdhistogram(a,[],[],[])
% % We can leave out the mask altogether
% d=mdhistogram(a,[],{{'lower',0,'upper',100,'bins',100}})
% % As well as the boolean array
% e=mdhistogram(a,{{'lower',0,'upper',100,'bins',100}})
% % Or everything:
% f=mdhistogram(a)
%
%
% For those familiar with Pattern Recognition. The histogram is in fact
% a feature space. The features are the elements of the multi-valued data.
% Each pixel in the feature space indicates whether the corresponding feature
% vector is present in the data. Since a given feature vector may occur more
% than once, the pixel records the number of occurrences of that feature
% vector.
% Automatic thresholds are often based on performing some (primitive) kind
% of clustering in this space. These methods may work on the feature space
% representation or on the indirect representation: the original image.
% The feature space representation uses binning and may therefore be less
% accurate. The main difference lies in the amount of data to process.
% If the number of features is lower than the number of spatial dimensions,
% then the feature space is a much compacter representation than the
% original image. Conversely, if the number of features is greater than
% the number of spatial dimensions, than the original image is the more
% compact representation.

% Written by Michael van Ginkel some time in 2001.
% 1 February 2013: Fixed bug: MATLAB's case does not fall through. (CL)

function [out,varargout]=mdhistogram(varargin)

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

if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = struct('menu','none');
      return
   end
end

channels=[];
mask=[];
binspecs={};
bins_format='';
args={};
if (nargin>1) & (ischar(varargin{2}))
   if isempty(which('mtl_parse_keywords'))
      error('Unexpected string argument (#2)');
   end
   args=varargin(2:end);
end
if isa(varargin{1},'dip_image_array')
   if isempty(args)
      switch nargin
         case 1
         case 2
            binspecs=varargin{2};
         case 3
            mask=varargin{2};
            binspecs=varargin{3};
         otherwise
            error('Too many arguments');
      end
   end
elseif isa( varargin{1}, 'dip_image' )
   if isempty(args)
      switch nargin
         case 1
         case 2
            binspecs=varargin{2};
         case 3
            channels=varargin{2};
            binspecs=varargin{3};
         case 4
            channels=varargin{2};
            mask=varargin{3};
            binspecs=varargin{4};
         otherwise
            error('Too many arguments');
      end
   end
else
   error('Input must be an image or tensor image');
end
if ~isempty(args)
   keywords={{'channels','array',[]},...
             {'channelspecs','cell',{}},...
             {'mask','image',[]},...
             {'bins_format','string',''}};
   kwd=mtl_parse_keywords(args,keywords);
   channels=kwd.channels;
   binspecs=kwd.channelspecs;
   mask=kwd.mask;
   bins_format=kwd.bins_format;
end

rtype=[];
rarg1=[];
rarg2=[];
rarg3=[];
% Let's parse the bloody thing
if ~isempty(binspecs)
   rtype=[0];
   rarg1=[0];
   rarg2=[0];
   rarg3=[0];
   if ~isa(binspecs,'cell')
      error('Bin specification must be a cell array')
   end
   if (length(size(binspecs))~=2) | (min(size(binspecs))~=1)
      error('Bin specification element must be a cell array with one dimension')
   end
   for ii=1:length(binspecs)
      if ~isempty(binspecs{ii})
         if ~isa(binspecs{ii},'cell')
            error('Bin specification element must be a cell array')
         end
         if (length(size(binspecs{ii}))~=2) | (min(size(binspecs{ii}))~=1)
            error('Bin specification element must be a cell array with one dimension')
         end
      end
      rtype(ii)=0;
      lwabs=0;
      upabs=0;
      lwcntr=0;
      upcntr=0;
      nocorr=0;
      if isempty(binspecs{ii})
         speclen=0;
      else
         speclen=length(binspecs{ii});
      end
      skip=0;
      for jj=1:speclen
         if skip
            skip=0;
         else
            switch binspecs{ii}{jj}
               case 'lower'
                  rtype(ii)=bitor(rtype(ii),1);
                  if (jj+1)>speclen
                     error('Missing argument to "lower"');
                  end
                  lower=binspecs{ii}{jj+1};
                  skip=1;
               case 'upper'
                  rtype(ii)=bitor(rtype(ii),2);
                  if (jj+1)>speclen
                     error('Missing argument to "upper"');
                  end
                  upper=binspecs{ii}{jj+1};
                  skip=1;
               case 'bins'
                  rtype(ii)=bitor(rtype(ii),4);
                  if (jj+1)>speclen
                     error('Missing argument to "bins"');
                  end
                  bins=binspecs{ii}{jj+1};
                  skip=1;
               case 'binsize'
                  rtype(ii)=bitor(rtype(ii),8);
                  if (jj+1)>speclen
                     error('Missing argument to "binsize"');
                  end
                  binsize=binspecs{ii}{jj+1};
                  skip=1;
               case 'lower_abs'
                  lwabs=1;
               case 'upper_abs'
                  upabs=1;
               case 'lower_centre'
                  lwcntr=1;
               case 'upper_centre'
                  upcntr=1;
               case 'no_correction'
                  nocorr=1;
               otherwise
                  error('Unknown option');
            end
         end
      end
      switch rtype(ii)
         case 0
            rtype(ii)=DIP_MDH_LOWER_UPPER_BINS;
            rarg1(ii)=0;
            rarg2(ii)=100;
            rarg3(ii)=100;
         case 7
            rtype(ii)=DIP_MDH_LOWER_UPPER_BINS;
            rarg1(ii)=lower;
            rarg2(ii)=upper;
            rarg3(ii)=bins;
         case 13
            rtype(ii)=DIP_MDH_LOWER;
            rarg1(ii)=lower;
            rarg2(ii)=binsize;
            rarg3(ii)=bins;
         case 14
            rtype(ii)=DIP_MDH_UPPER;
            rarg1(ii)=upper;
            rarg2(ii)=binsize;
            rarg3(ii)=bins;
         case 11
            rtype(ii)=DIP_MDH_LOWER_UPPER_BINSIZE;
            rarg1(ii)=lower;
            rarg2(ii)=upper;
            rarg3(ii)=binsize;
         otherwise
            error('Illegal combination of "lower", "upper", "bins" and "binsize"');
      end
      rtype(ii)=rtype(ii)+DIP_MDH_LOWER_PERCENTILE+DIP_MDH_UPPER_PERCENTILE;
      if lwabs
         rtype(ii)=bitand(rtype(ii),DIP_MDH_ALL_SET-DIP_MDH_LOWER_PERCENTILE);
      end
      if upabs
         rtype(ii)=bitand(rtype(ii),DIP_MDH_ALL_SET-DIP_MDH_UPPER_PERCENTILE);
      end
      if lwcntr
         rtype(ii)=bitor(rtype(ii),DIP_MDH_LOWER_CENTRE);
      end
      if upcntr
         rtype(ii)=bitor(rtype(ii),DIP_MDH_UPPER_CENTRE);
      end
      if nocorr
         rtype(ii)=bitor(rtype(ii),DIP_MDH_NO_CORRECTION);
      end
   end
end

if isa(varargin{1},'dip_image_array')
   [out,obinspecs]=dip_armdhistogram(varargin{1},mask,rtype,rarg1,rarg2,rarg3);
else
   [out,obinspecs]=dip_mdhistogram(...
                        varargin{1},channels,mask,rtype,rarg1,rarg2,rarg3);
end

if nargout>2
   error('Too many output arguments');
end
if nargout>1
   obinspecs=double(obinspecs);
   switch bins_format
      case {'','left'}
         off=0;
      case {'centre','center'}
         off=0.5;
      case 'right'
         off=1;
      otherwise
         error('Unsupported format for the bins');
   end
   if size(obinspecs,1)==1
      obinspecs=((0:(obinspecs(3)-1))+off)*obinspecs(2)+obinspecs(1);
   else
      tbinspecs={};
      for ii=1:size(obinspecs,1)
         tbinspecs{ii}=((0:(obinspecs(ii,3)-1))+off)*obinspecs(ii,2)+obinspecs(ii,1);
      end
      obinspecs=tbinspecs;
   end
   varargout{1}=obinspecs;
end
