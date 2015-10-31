%STRETCH   Grey-value stretching
%
% SYNOPSIS:
%  image_out = stretch(image_in, low, high, minimum, maximum)
%  low = lower percentile of image_in
%  high = highest percentile of image_in
%
% DEFAULTS:
%  low = 0    
%  high = 100
%  minimum = 0
%  maximum = 255
%
% NOTE: changed order of input max and min as Nov 2002

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2000.
% Nov 2002, changed order of input parameter + update help
% Apr 2010, changed to support colour images; slightly faster too

function image_out = stretch(varargin)

d = struct('menu','Point',...
  'display','Grey-value stretching',...
  'inparams',struct('name',       {'image_in',   'low','high','maximum','minimum'},...
       'description',{'Input image','Lower percentile','Upper percentile','Minimum','Maximum'},...
       'type',       {'image',      'array',           'array',           'array',     'array'},...
       'dim_check',  {0,            0,                 0,                 0,           0},...
       'range_check',{[],           [0 100],           [0 100],           [],          []},...
       'required',   {1,0,0,0, 0},...
       'default',    {'a',0,100,0,255}...
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
   [image_in,low,high,minimum,maximum] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if low > high
   tmp = low; low = high; high = tmp;
end
tel=prod(imarsize(image_in));  % number of tensor elements;
image_out=image_in;
if maximum ~= minimum
  to_clip=any([low(:)~=0;high(:)~=100]);
  low=repmat(low(:),[tel/length(low),1]);
  high=repmat(high(:),[tel/length(high),1]);
  for ci = 1:tel
    if low(ci) == high(ci)
      continue
    end
    if low(ci) == 0
      low(ci) = min(image_in{ci});
    else
      low(ci) = double(dip_percentile(image_in{ci},[],low(ci),[]));
    end
    if high(ci) == 100
      high(ci) = max(image_in{ci});
    else
      high(ci) = double(dip_percentile(image_in{ci},[],high(ci),[]));
    end
  end
  low = min(low);
  high = max(high);
  if low == high
    for ci = 1:tel
      image_out{ci}(:) = (minimum+maximum)/2;
    end
  else
    sc = (maximum-minimum)/(high-low);
    for ci=1:tel
      if low~=0
        image_out{ci} = image_out{ci}-low;
      end
      if sc~=1
        image_out{ci} = image_out{ci}*sc;
      end
      if minimum~=0
        image_out{ci} = image_out{ci}+minimum;
      end
      if to_clip
        image_out{ci} = dip_clip(image_out{ci},minimum,maximum,'both');
      end
    end
  end
else
  for ci = 1:tel
    image_out{ci}(:) = minimum;
  end
end
