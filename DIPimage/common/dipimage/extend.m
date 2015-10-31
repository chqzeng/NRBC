%EXTEND   Extends/pads an image with values
%
% SYNOPSIS:
%  out = extend(in, newsize, type, value, clip)
%
% PARAMETERS:
%  in:      Input image
%  newsize: New image size
%  type:    The location of the old image within the extended image.
%           Can be one of the following strings: 'symmetric',
%           'topleft', 'topright', 'bottomleft', 'bottomright'
%  value:   Value with which to pad the image. Can also be a string
%           or a cell array with strings specifying one of the
%           boundary extension algorithms in dip_setboundary. The
%           empty string specifies the default method.
%  clip:    Clip images if newsize < oldsize ('no','yes')
%
% DEFAULTS:
%  type: 'symmetric'
%  value: 0
%  clip: 'no' (if newsize smaller than input, do nothing)
%
% EXAMPLE:
%  extend(readim,[300,300])
%  extend(readim,[300,300],'symmetric','periodic')
%  extend(readim('chromo3d'),[100,100,50]'symmetric',30,1)
%
% SEE ALSO:
%  cut

% (C) Copyright 2004-2012      Department of Molecular Biology
%     All rights reserved      Max-Planck-Institute for Biophysical Chemistry
%                              Am Fassberg 11, 37077 G"ottingen
%                              Germany
%
% Bernd Rieger, Sep 2004.
% 9 April 2007, Rewrote to use SUBSASGN instead of EVAL. (CL)
% 20 July 2010, Keeping pixel dimensions. (CL)
% 21 July 2010, Keeping image origin in the correct place. (CL)
%               'leftlow' -> 'leftdown'; 'rightlow' -> 'rightdown'. (CL)
% 21 Sept 2010, No reason to not allow tensor images. (CL)
% 18 May 2011,  Rewritten slightly, added optional call to dip_extendregion.
%               '*down' -> 'bottom*'; '*up' -> 'top*'. (CL)
% 7 February 2012, Avoiding a change of default boundary condition in case
%                  of error. (CL)
% 14 June 2012, Fixed bug introduced 18 May 2011 (thanks Lennard); preserving
%               pixel dimensions. (CL)

function out = extend(varargin)
d = struct('menu','Manipulation',...
   'display','Extend (padding)',...
   'inparams',struct('name',       {'in','newsz','typ','value','clp'},...
                     'description',{'Input image','New image size','Placement flavour','Value','Clipping'},...
                     'type',       {'image','array','option','array','boolean'},...
                     'dim_check',  {0,1,0,0,0},...
                     'range_check',{[],'N+',{'symmetric','topleft','topright','bottomleft','bottomright'},'R',[]},...
                     'required',   {1,1,0,0,0},...
                     'default',    {'a','256','symmetric',0,0}...
                    ),...
   'outparams',struct('name',       {'out'},...
                      'description',{'Output image'},...
                      'type',       {'image'}...
                     )...
  );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = d;
      return
   end
end
% Aliases for 'type' string:
if nargin>=3 & ischar(varargin{3})
   switch varargin{3}
   case 'leftup'
      varargin{3} = 'topleft';
   case 'rightup'
      varargin{3} = 'topright';
   case {'leftlow','leftdown'}
      varargin{3} = 'bottomleft';
   case {'rightlow','rightdown'}
      varargin{3} = 'bottomright';
   end
end
% Optional string as 'value' argument
if nargin>=4 & ( ischar(varargin{4}) | iscellstr(varargin{4}) )
   borderextension = varargin{4};
   varargin{4} = 0;
else
   borderextension = 'value';
end
try
   [in,newsz,typ,value,clp] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

sz = imsize(in);
N = length(sz);
if ~clp
   newsz = max(sz,newsz);
end

% Find origin for old image within new image
switch typ
   case 'symmetric'
      % Because we're now using this function also in CONVOLVE, we need
      % to make sure that the origin is conserved properly:
      start = (newsz-sz)./2;            % start coord
      ii = mod(sz,2)~=0; % odd size input
      start(ii) = ceil(start(ii));
      start(~ii) = floor(start(~ii));
      stop  = start+sz-1;             % end coord
   case 'topleft'
      start = zeros(1,N);
      stop  = sz-1;
   case 'bottomleft'
      if N>2
         error('bottomleft option only up to 2D');
      end
      start = [0,newsz(2)-sz(2)];
      stop  = [sz(1)-1,newsz(2)-1];
   case 'topright'
       if N>2
         error('topright option only up to 2D');
      end
      start = [newsz(1)-sz(1),0];
      stop  = [newsz(1)-1,sz(2)-1];
   case 'bottomright'
      start = newsz - sz;
      stop  = newsz - 1;
   otherwise
      error('Should not happen');
end

% First crop dimensions that we want smaller
k = sz>newsz;
if any(k)
   tmp = min(sz,newsz);
   orig = -start;
   orig(~k) = 0;
   in = cut(in,tmp,orig);
   sz = imsize(in);
   start(k) = 0;
   stop(k) = newsz(k)-1;
end

% Next extend the other dimensions
out = in;
if all(newsz<=sz)
   return;
end
out{:} = newim(newsz,datatype(in{1}));
out.pixelsize = in.pixelsize;
out.pixelunits = in.pixelunits;
if value
   out(:) = value;
end
s = cell(1,N);
for ii = 1:N
   s{ii} = start(ii):stop(ii);
end
out(s{:}) = in;

% Boundary extension
if ~isequal(borderextension,'value')
   if ~isempty(borderextension)
      oldextension = dip_getboundary(1);
      dip_setboundary(borderextension);
   end
   err = '';
   try
      %#function dip_extendregion
      out = iterate('dip_extendregion',out,start,sz,[0,1]);
   catch
      err = lasterr;
   end
   if ~isempty(borderextension)
      dip_setboundary(oldextension);
   end
   error(err);
end
