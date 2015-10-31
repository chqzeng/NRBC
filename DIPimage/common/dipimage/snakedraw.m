%SNAKEDRAW   Draws a snake over an image
%
% SYNOPSIS:
%  handle_out = snakedraw(snake,handle_in)
%
% PARAMETERS:
%  snake :      snake, Nx2 double array
%  handle_in :  handle of image figure, or handle of line to replace
%
% OUTPUT:
%  handle_out : handle of line created, use as input to move the snake
%
% DEFAULTS:
%  handle = gcf
%
% EXAMPLE:
%  See the example in SNAKEMINIMIZE
%
% SEE ALSO: snakeminimize, snake2im

% (C) Copyright 2009, All rights reserved.
% Cris Luengo, Uppsala, 18-24 September 2009.

function oh = snakedraw(s,h)

d = struct('menu','Segmentation',...
           'display','Draw snake on image',...
           'inparams',struct('name',       {'snake',       'handle'},...
                             'description',{'Input snake', 'Image'},...
                             'type',       {'array',       'handle'},...
                             'dim_check',  {[-1,2],        []},...
                             'range_check',{'R+',          {'2D'}},...
                             'required',   {1,             0},...
                             'default',    {[],            []}...
                            ),...
           'outparams',struct('name',{'h'},...
                              'description',{'Snake handle'},...
                              'type',{'handle'}...
                              )...
          );
if nargin == 1
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      oh = d;
      return
   end
end

if nargin<1
   error('Snake input required.');
end
if ~isnumeric(s) | size(s,2)~=2
   error('Input array not valid as snake.');
end
x = s(:,1);
y = s(:,2);

if nargin<2
   h = gcf;
end
if ~ishandle(h)
   error('Figure does not exist!')
end
if strcmp(get(h,'type'),'line')
   lh = h;
   set(lh,'xdata',[x;x(1)],'ydata',[y;y(1)]);
else
   if ~strcmp(get(h,'type'),'image')
      h = findobj(h,'type','image');
      if length(h)~=1
         error('Cannot find an image in the figure.')
      end
   end
   h = get(h,'parent'); % axes handle
   os = get(h,'nextplot');
   set(h,'nextplot','add');
   lh = line([x;x(1)],[y;y(1)],'color',[0,0.8,0],'parent',h,'linewidth',1);
   set(h,'nextplot',os);
end
drawnow
if nargout>0
   oh = lh;
end
