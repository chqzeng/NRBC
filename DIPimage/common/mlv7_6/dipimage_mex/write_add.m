%WRITE_ADD   image transformation
% performancs the operation: out(x+sv_x, y+sv_y) += in(x,y) 
%
% SYNOPSIS:
%  out = write_add(in, sv, method)
%
% PARAMETERS:
%  in:     2D image
%  sv:     2D shift vector per pixel as a dip_image_array
%  method: interpolation method (not used at the moment, i.e. zoh)
%
% NOTE:
%  only implemented for 2D
%
% SEE ALSO:
%  radoncircle

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger


function out = write_add(in, s, method)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

out = write_add_double(double(in), double(s{1}), double(s{2}));
out = dip_image(out);
