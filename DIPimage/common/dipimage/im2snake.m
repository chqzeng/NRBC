%IM2SNAKE   Creates a snake based on a binary image
%
% SYNOPSIS:
%  snake = im2snake(image)
%
% PARAMETERS:
%  image :   binary or labelled image. If it is a labelled
%            image, only object with id=1 is considered.
%
% NOTE:
%  Only the first (top-left) contiguous group of pixels is
%  used to create the snake. If you want to control which
%  group is used, label the image and select an id:
%
%     snake = im2snake(label(img)==3)
%
% SEE ALSO: snake2im, snakeminimize, snakedraw

% (C) Copyright 2010, All rights reserved.
% Cris Luengo, Uppsala, 4 March 2010.

function snake = im2snake(varargin)

d = struct('menu','Segmentation',...
           'display','Convert image to snake',...
           'inparams',struct('name',       {'image'},...
                             'description',{'Input image'},...
                             'type',       {'image'},...
                             'dim_check',  {2},...
                             'range_check',{'bin'},...
                             'required',   {1},...
                             'default',    {'a'}...
                            ),...
           'outparams',struct('name',{'snake'},...
                              'description',{'Output snake'},...
                              'type',{'snake'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      snake = d;
      return
   end
end
try
   [img] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

data = dip_imagechaincode(+img,2,1);
xc = [ 1; 1; 0;-1;-1;-1; 0; 1];
yc = [ 0;-1;-1;-1; 0; 1; 1; 1];
cc = data.chain(1:end-1)+1;
x = cumsum([data.start(1);xc(cc)]);
y = cumsum([data.start(2);yc(cc)]);
snake = [x,y];
