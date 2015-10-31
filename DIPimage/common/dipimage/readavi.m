%READAVI   Reads AVI movie into a 3D image
%  Reads an AVI movie file into a 3D grey-value image, where the z-direction
%  is the time component (only Matlab 6).
%
% SYNOPSIS:
%  out = readavi(filename, frame index)
%
% PARAMETERS:
%  filename:    string with name of file, optionally with path and extension.
%  frame index: array containing the frames to read (possible 1:10, 1:2:10,..)
%               0, the whole movie is read 
%
% DEFAULTS:
%  frame index: read whole movie
%
% CHANGES:
%  color avi's are now returned as a color image

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, May 2001.
% September 2004, support for color avi reading 

function out = readavi(varargin)
d = struct('menu','File I/O',...
    'display','Read AVI',...
    'inparams',struct('name',       {'filename','frameindex'},...
                      'description',{'Filename','Frame Index'},...
                      'type',       {'infile','array'},...
                      'dim_check',  {0,-1},...
                      'range_check',{'*.avi','R+'},...
                      'required',   {1,0},...
                      'default',    {'',[]}...
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
   [filename,frameindex] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if isempty(frameindex)
   a = aviread(filename);
else
   a = aviread(filename,frameindex);
end
x = dip_image(cat(4,a.cdata));

clear a

if ndims(x)==3
   x = reshape(x,[size(x),1]);
elseif ndims(x)==2
   x = reshape(x,[size(x),1,1]);
end

if size(x,3)==3
   %color avi
   out = newimar(3);
   out{1} = squeeze(x(:,:,0,:));
   out{2} = squeeze(x(:,:,1,:));
   out{3} = squeeze(x(:,:,2,:));
   out = colorspace(out,'RGB');
else
   out = squeeze(x(:,:,0,:));
end
