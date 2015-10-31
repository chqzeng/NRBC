%CHANGE_XYZ   Change the whitepoint of the XYZ colorspace
%
% SYNOPSIS:
%  image_out = change_xyz(image_in, new_xyz)
%
% DEFAULTS:
%  new_xyz = [0.9505 1 1.0888]  (D65 white)
%
% DESCRIPTION:
%  The whitepoint of the input image is changed into the new value (XYZ_new).
%  This is done by assuming that the values in CIELAB should be the same for
%  the input image with the old reference white and the output image with
%  the new reference white.
%  Note the difference with SET_XYZ. In CHANGE_XYZ the pixel values of the
%  input image are changed due to the change in the white reference, whereas
%  in SET_XYZ only the reference white is changed.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, June 2002.
% 20 October 2007: Moved to toolbox directory. (CL)

function img = change_xyz(img,XYZ_out)
% Avoid being in menu
if nargin == 1 & ischar(img) & strcmp(img,'DIP_GetParamList')
   img = struct('menu','none');
   return
end

if ~isa(img,'dip_image_array') | ~iscolor(img)
   error('Input needs to be a color image.');
end

XYZ_in = img.whitepoint;
if( nargin < 2)
   XYZ_out = [.9505 1 1.0888]; % standard d65-2
else
   if ~isnumeric(XYZ_out) | prod(size(XYZ_out))~=3
      error('The whitepoint value must be a 1x3 numeric array.');
   end
end
if ~isequal(XYZ_in,XYZ_out)
   ori_col = colorspace(img);
   img = colorspace(img,'xyz');
   img{1} = img{1}*(XYZ_out(1)/XYZ_in(1));
   img{2} = img{2}*(XYZ_out(2)/XYZ_in(2));
   img{2} = img{3}*(XYZ_out(3)/XYZ_in(3));
   img.whitepoint = XYZ_out;
   img = colorspace(img,ori_col);
end
