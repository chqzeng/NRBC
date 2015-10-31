%UMBRA   umbra of an image
%
% SYNOPSIS:
%  [image_out, offset] = umbra(image_in)
%
% LITERATURE:
%  H.J.A.M. Heijmans, A note on the umbra transform in gray-scale morphology
%  Pattern Recognition Letters, 14(11):877-881, 1993
 
% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, September 2008

function [out,offset]=umbra(in)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if ~isa(in,'dip_image')
   error('Input image is not scalar.');
end
d = ndims(in);
intin = round(in);
maxin = max(intin); 
offset = min(intin); 
range = maxin-offset; 

ind = ones(1,d+1);
ind(d+1) = range+1;
out = repmat(intin,ind);
ram  = ramp(out,d+1,'corner');
out = (out-ram) > offset;

