%DRAWPOLYGON   Draws a polygon in an image
%
% SYNOPSIS:
%    out = drawpolygon(in,coordinates,intensity,closed);
%
% PARAMETERS:
%    coordinates: matrix containing the coordinates of the corner points
%       of the polygon. It is organised as follows:
%       coordinates=[x1 y1 z1; x2 y2 z2; etc...]
%    intensity: gray value with which to draw the lines
%    closed: 'open': do not connect the last point to the first point
%            'closed': do connect the last point to the first point,
%
% DEFAULTS:
%    intensity = 255
%    closed = 'open'

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel, December 2000.
% 15-07-2008 - MvG - updated to use dip_drawlines() ! Calling dip_drawline()
%                    through matlab is really slow...
% 10 September 2008: added to menu, allowing input color images. (CL)

function out = drawpolygon(varargin)

d = struct('menu','Generation',...
           'display','Add polygon',...
           'inparams',struct('name',       {'in',         'coordinates','intensity','closed'},...
                             'description',{'Input image','Coordinates','Intensity','Connect enpoints?'},...
                             'type',       {'image',      'array',      'array',    'option'},...
                             'dim_check',  {0,            [-1,-1],      -1,          0},...
                             'range_check',{[],           'R',          'R',        {'open','closed'}},...
                             'required',   {1,            1,            0,          0},...
                             'default',    {'a',          [],           255,        'open'}...
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
   [in,cor,inten,closed] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if strcmp(closed,'open')
   openpolygon = 1;
else
   openpolygon = 0;
end

N = prod(imarsize(in));
if N>1 & ~istensor(in)
   error('Input is an array of images of different sizes.');
end
if length(inten)~=N
   if length(inten)==1
      inten = repmat(inten,1,N);
   else
      error('INTENSITY input must be a scalar or a vector with one element per image channel.');
   end
end
nd = length(imsize(in));
if size(cor,2)~=nd
   error('COORDINATES array must have one column per image dimension.');
end
out = in;
k = size(cor,1);
if k<=2
   openpolygon = 0;
end

% Prepare to call dip_drawlines()
lines = reshape(cor',[1,nd,k]);           % along Z-axis
lines = [lines;lines(:,:,[2:end,1])];     % duplicate and shift
if openpolygon
   lines(:,:,end) = [];
end
if k==1
   % In this case, the 3D array LINES will actually only have 2 dimensions...
   lines = dip_image(lines);
   lines = reshape(lines,[2,nd,1]);
end
for ii=1:N
   out{ii} = dip_drawlines(out{ii},lines,inten(ii));%undocumented MvG private code
end
