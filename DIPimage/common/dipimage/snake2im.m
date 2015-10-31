%SNAKE2IM   Creates a binary image based on a snake
%
% SYNOPSIS:
%  image = snake2im(snake,imagesize)
%
% PARAMETERS:
%  snake :     snake, Nx2 double array
%  imagesize : size of output image
%
% DEFAULTS:
%  imagesize = ceil(max(snake))+1
%
% SEE ALSO: im2snake, snakeminimize, snakedraw

% (C) Copyright 2009, All rights reserved.
% Cris Luengo, Uppsala, 18-24 September 2009.

function o = snake2im(varargin)

d = struct('menu','Segmentation',...
           'display','Convert snake to image',...
           'inparams',struct('name',       {'snake',       'imagesize'},...
                             'description',{'Input snake', 'Image size'},...
                             'type',       {'array',       'array'},...
                             'dim_check',  {[-1,2],        {[],[1,2]}},...
                             'range_check',{'R+',          'N+'},...
                             'required',   {1,             0},...
                             'default',    {[],            []}...
                            ),...
           'outparams',struct('name',{'image'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      o = d;
      return
   end
end
try
   [s,imsz] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

x = s(:,1);
y = s(:,2);
if isempty(imsz)
   imsz = ceil(max(s))+1;
else
   x(x>imsz(1)-1) = imsz(1)-1;
   y(y>imsz(2)-1) = imsz(2)-1;
end
x(x<0) = 0;
y(y<0) = 0;

o = newim(imsz,'bin');
strides = [imsz(2);1];
indx = bresenham2([x(end),y(end)],[x(1),y(1)])*strides;
for ii = 2:length(x)
   indx = [indx;bresenham2([x(ii-1),y(ii-1)],[x(ii),y(ii)])*strides];
end
indx = unique(indx);
o(indx) = 1;
o = ~dip_binarypropagation(o&0,~o,1,0,1); % Propagation from border, low connect.


% computes coordinates of points along line from pt1 to pt2
% (copied from @dip_image/convhull.m)
function line = bresenham2(pt1,pt2)
point = pt2-pt1;
N = max(abs(point)); % the number of pixels needed.
if N==0
   line = pt1;
   return;
end
ii = (0:N)';    % this is better than (0:N)/N, because of round-off errors.
x = ii*(point(1)/N)+pt1(1);
y = ii*(point(2)/N)+pt1(2);
line = round([x,y]);

