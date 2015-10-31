%CROPIM   Crop an image
%
% SYNOPSIS:
%  image_out = cropim(image_in, [origin,] cropsize)
%
% PARAMETERS:
%    origin:   (optional) the origin of the crop region, if not explicitly
%              given: origin=floor(0.5*(size(image_in)-cropsize))
%    cropsize: size of the crop region
%
% SEE ALSO:
%  cut, extend

% Copyright 2007-2010, Michael van Ginkel, Cris Luengo.
% July 2010: Added parameter checking & more gentle error recovery,
%            Using SUBSREF instead of DIP_CROP for better speed &
%            conservation of pixel dimensions. (CL)
% Sept 2010: There's no difference with CUT any more. (CL)

function imo = cropim(imi,origin,cropsize)

if nargin==1 & ischar(imi) & strcmp(imi,'DIP_GetParamList')
   imo = struct('menu','none');
   return;
end

if nargin<2
   error('CROPSIZE must be given.');
elseif nargin==2
   cropsize = origin;
   origin = [];
end

imo = cut(imi,cropsize,origin);
