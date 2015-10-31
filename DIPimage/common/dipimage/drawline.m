%DRAWLINE   Draws a line in an image
%
% SYNOPSIS:
%  image_out = drawline(image_in, start, end, intensity)
%
%  start:     array containing the start position(s) of the line(s)
%  end:       array containing the end position(s) of the line(s)
%  intensity: intensity of the line(s), either one or one per line
%
% DEFAULTS:
%  intensity = 255;
%
% EXAMPLE:
%  drawline(newim,[100 100; 0 200],[200 200; 200 0],255)

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Apr 2001
% July 2007, extended to use for multiple lines (BR)
% 10 September 2008: changed parameter struct, simplified function. (CL)

function out = drawline(varargin)

d = struct('menu','Generation',...
           'display','Add line',...
           'inparams',struct('name',       {'in',         'start',            'end',            'intensity'},...
                             'description',{'Input image','Start Coordinates','End Coordinates','Intensity'},...
                             'type',       {'image',      'array',            'array',          'array',},...
                             'dim_check',  {0,            [-1,-1],            [-1,-1],          -1, },...
                             'range_check',{[],           'R',                'R',              'R'},...
                             'required',   {1,            1,                  1,                0},...
                             'default',    {'a',          [0 0],              [255 255],        255}...
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
   [in,st,ed,inten] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if any(size(st)~=size(ed))
   error('Must have the same number of start and end points.');
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
if size(st,2)~=nd
   error('START and END arrays must have one column per image dimension.');
end
out = in;
k = size(st,1);
if k==1
   % one line
   for ii=1:N
      out{ii} = dip_drawline(out{ii},st,ed,inten(ii));
   end
else
   % several lines
   st = reshape(st',[1,nd,k]);
   ed = reshape(ed',[1,nd,k]);
   coI = [st;ed];
   for ii=1:N
      out{ii} = dip_drawlines(out{ii},coI,inten(ii));%undocumented MvG private code
   end
end
