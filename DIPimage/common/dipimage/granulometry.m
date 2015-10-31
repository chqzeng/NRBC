%GRANULOMETRY   Obtains a particle size distribution.
%
% SYNOPSIS:
%  distr = granulometry(in,widths,minimumFilterSize,maximumFilterSize,...
%                       minimumZoom,maximumZoom,options,polarity)
%
% PARAMETERS:
%  in: input image
%  widths: sample locations; these are the diamters of the disks used as SEs.
%  minimumFilterSize, maximumFilterSize: minimum and maximum filter sizes used
%     when computing the granulometry, if possible according to allowable zoom
%     factors.
%  minimumZoom, maximumZoom: allowable zoom factors. These numbers overrule
%     the maximum and minimum filter sizes.
%  options: cell array containing zero or more of the following strings:
%     'usecenter': set this to use non-symmetric SEs.
%     'usegrey': set this to use grey-value SEs.
%     'usereconstruction': set this to use reconstruction for the second step
%          (instead of an erosion). In this case, 'usegrey' and 'usecenter' still
%          have an influence because of the first step (the dilation).
%     'verbose': set this to see the parameters being used. This is mostly for
%          debugging purposes.
%  polarity: whether to use openings or closings. One of these options:
%     'dark': uses closings and measures dark particles agains a light background.
%     'light': uses openings and measures light particles against a dark background.
%
% DEFAULTS:
%  widths = sqrt(2).^([1:15])
%  minimumFilterSize = 8
%  maximumFilterSize = 64
%  minimumZoom = 1
%  maximumZoom = 1
%  options = {}
%  polarity = 'dark'
%
% RETURNS:
%  distr: An array containing the points in a cumulative volume-weighted
%     distribution at WIDTHS.

% (C) Copyright 1999-2006               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, September 2003 (based on code written between 1999 and 2003).
% 15 July 2006: Added POLARITY parameter.

function distr = granulometry(varargin)

optionarray = struct('name',{'usecenter','usegrey','usereconstruction','verbose'},...
                     'description',{'Use shifted SE','Use grey-value SE','Use reconstruction','Display values being used'});

d = struct('menu','Analysis',...
           'display','Granulometry',...
           'inparams',struct('name',       {'in',          'widths', 'minimumFilterSize',   'maximumFilterSize',   'minimumZoom',         'maximumZoom',         'options',    'polarity'},...
                             'description',{'Input image', 'Widths', 'Minimum Filter Size', 'Maximum Filter Size', 'Minimum Zoom Factor', 'Maximum Zoom Factor', 'Options',    'Polarity'},...
                             'type',       {'image',       'array',  'array',               'array',               'array',               'array',               'optionarray','option'},...
                             'dim_check',  {0,             -1,       0,                     0,                     0,                     0,                     0,            0},...
                             'range_check',{[],            'R+',     'R+',                  'R+',                  'R+',                  'R+',                  optionarray,  {'dark','light'}},...
                             'required',   {1,             0,        0,                     0,                     0,                     0,                     0,            0},...
                             'default',    {'a',           [],       8,                     64,                    1,                     1,                     {},           'dark'}...
                            ),...
           'outparams',struct('name',{'msr'},...
                              'description',{'Output measurement data'},...
                              'type',{'measurement'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      distr = d;
      return
   end
end
try
   [in,widths,minimumFilterSize,maximumFilterSize,minimumZoom,maximumZoom,options,polarity] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

% Check input
if isa(in,'dip_image_array') | isempty(in)
   error('Scalar input image expected.')
end
in = dip_image(in,'sfloat');
nd = ndims(in);
mask = []; % Not accessible from outside anymore...
if isempty(widths)
   widths = sqrt(2).^([1:15]);
elseif sum(size(widths)>1)>1
   error('WIDTHS must be a vector.')
end
levels = length(widths);
usecenter = 0;
usegrey = 0;
usereconstruction = 0;
verbose = 0;
for ii=1:length(options)
   switch options{ii}
      case 'usecenter'
         usecenter = 1;
      case 'usegrey'
         usegrey = 1;
      case 'usereconstruction'
         usereconstruction = 1;
      case 'verbose'
         verbose = 1;
      otherwise
         error('Unknown option')
   end
end
if minimumFilterSize < 3
   minimumFilterSize = 3;
end
if maximumFilterSize < minimumFilterSize
   maximumFilterSize = minimumFilterSize;
end
%if minimumZoom > 1
%   minimumZoom = 1;
%end
%if maximumZoom < 1
%   maximumZoom = 1;
%end
switch nd
   case 1
      center = 0.25;
   case 2
      center = [0.19,0.31];
   case 3
      center = [0.16,0.24,0.34];
   otherwise
      error('Only images with 1 to 3 dimensions supported.')
end
if strcmp(polarity,'dark')
   polarity = 0;
else
   polarity = 1;
end
if verbose
   if polarity==0
      disp('Using closings')
   else
      disp('Using openings')
   end
   if usegrey
      disp('Using grey-value SEs')
   end
end
if usereconstruction
   if verbose
      disp('Using reconstruction')
   end
   if polarity==0
      in = -in;      % we're using openings instead of closings!
      polarity = 1;
   end
end

% Compute zooming values
zooming = ones(1,levels);
zooming(1) = 2^nextpow2(minimumFilterSize/widths(1));
if zooming(1) > maximumZoom
   zooming(1) = maximumZoom;
elseif zooming(1) < minimumZoom
   zooming(1) = minimumZoom;
end
for ii=2:length(zooming)
   zooming(ii) = zooming(ii-1);
   if zooming(ii)*widths(ii) > maximumFilterSize | (zooming(ii)>1 & zooming(ii)*widths(ii)/2 > minimumFilterSize)
      zooming(ii) = 2^nextpow2(minimumFilterSize/widths(ii));
      if zooming(ii) > maximumZoom
         zooming(ii) = maximumZoom;
      elseif zooming(ii) < minimumZoom
         zooming(ii) = minimumZoom;
      end
   end
end
if verbose
   disp('Zooming factors:')
   disp(num2str(zooming))
   disp('Actual filter sizes:')
   disp(num2str(widths.*zooming))
end

% Prepare radius image to fabricate SEs
sz = floor(max(zooming.*widths)/2)*2+5; % This is always odd in size.
if usecenter
   if verbose
      disp('Using as center:')
      disp(num2str(center))
   end
   switch nd
      case 1
         r = xx(sz)+center;
      case 2
         r = sqrt( (xx(sz,sz)+center(1))^2 + (yy(sz,sz)+center(2))^2 );
      case 3
         r = sqrt( (xx(sz,sz,sz)+center(1))^2 + (yy(sz,sz,sz)+center(2))^2 + (zz(sz,sz,sz)+center(3))^2 );
   end
else
   switch nd
      case 1
         r = xx(sz);
      case 2
         r = sqrt( xx(sz,sz)^2 + yy(sz,sz)^2 );
      case 3
         r = sqrt( xx(sz,sz,sz)^2 + yy(sz,sz,sz)^2 + zz(sz,sz,sz)^2 );
   end
end


% Compute distribution
distr = zeros(1,levels);
if ~isempty(mask)
   maxim = max(in(mask));
   minim = min(in(mask));
   offset = mean(in(mask));
else
   maxim = max(in);
   minim = min(in);
   offset = mean(in);
end
if polarity==0 % this is a closing sieve..
   gain = 1/(maxim-offset);
else % this is an opening sieve...
   gain = 1/(minim-offset);
end
if usegrey <= 1
   range = (maxim - minim) * 1.0233;  % 2 sigma cut-off point
else
   range = (maxim - minim) * usegrey; % useful values are between 1 and 2.
end
currentzoom = 0;
for level=1:levels
   if currentzoom ~= zooming(level)
      currentzoom = zooming(level);
      % To zoom out we no longer use dip_ResamplingFT on the current granule,
      %    since it produces missing local maxima. To best preserve these, we
      %    dilate the input image, and then sub-sample it. We don't care that
      %    much about aliasing, do we? What we want is to keep the local maxima.
      % To zoom in we use dip_Resampling (faster!) on the input
      %    image, which has the best probability of being band-limited.
      % Else we copy the input image.
      if currentzoom < 1
         if level==1
            scaledin = in;
            if ~isempty(mask)
               smask = mask;
            end
         end
         scaledin = dilation(in,1/currentzoom,'rectangular');
         switch nd
            case 1
               scaledin = scaledin(0:1/currentzoom:end);
               if ~isempty(mask)
                  smask = smask(0:1/currentzoom:end);
               end
            case 2
               scaledin = scaledin(0:1/currentzoom:end,0:1/currentzoom:end);
               if ~isempty(mask)
                  smask = smask(0:1/currentzoom:end,0:1/currentzoom:end);
               end
            case 3
               scaledin = scaledin(0:1/currentzoom:end,0:1/currentzoom:end,0:1/currentzoom:end);
               if ~isempty(mask)
                  smask = smask(0:1/currentzoom:end,0:1/currentzoom:end,0:1/currentzoom:end);
               end
         end
      elseif currentzoom > 1
         scaledin = dip_resampling(in,currentzoom*ones(1,nd),zeros(1,nd),'3-cubic');
         scaledin = dip_clip(scaledin,minim,maxim,'both');
         if ~isempty(mask)
            smask = dip_image(dip_resampling(dip_image(mask,'sfloat'),currentzoom*ones(1,nd),zeros(1,nd),'zoh'),'bin');
         end
      else % currentzoom == 1
         scaledin = in;
         if ~isempty(mask)
            smask = mask;
         end
      end
   end
   rad = currentzoom*widths(level);
   newsz = floor(rad/2)*2 + 5;
   skip = (sz-newsz)/2;
   if skip>0
      switch nd
         case 1
            radim = r(skip:skip+newsz-1);
         case 2
            radim = r(skip:skip+newsz-1,skip:skip+newsz-1);
         case 3
            radim = r(skip:skip+newsz-1,skip:skip+newsz-1,skip:skip+newsz-1);
      end
   else
      radim = r;
   end
   if usegrey
      se = range*gaussianedgeclip(rad/2 - radim) - range;
   else
      se = radim <= rad/2;
   end
   if usereconstruction
      tmp = dip_erosion(scaledin,se,zeros(1,nd),'user_defined');
      tmp = dip_morphologicalreconstruction(tmp,scaledin,1);
   elseif polarity==0
      tmp = dip_closing(scaledin,se,zeros(1,nd),'user_defined');
   else
      tmp = dip_opening(scaledin,se,zeros(1,nd),'user_defined');
   end
   if ~isempty(mask)
      tmp = mean(tmp(smask));
   else
      tmp = mean(tmp);
   end
   distr(level) = (tmp-offset)*gain;
end
