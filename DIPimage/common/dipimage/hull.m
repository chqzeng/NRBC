%HULL  Generates convex hull of a binary image
%
% SYNOPSIS:
%  image_out = hull(image_in, Fill)
%
% DEFAULTS:
%  Fill = yes
%
% NOTES:
%  HULL uses the qhull algorithm. Under MATLAB 5, only 2D images are
%  supported. Under MATLAB 6, also 3D images can be processed.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Judith Dijk  May 2001

function out = hull(varargin)

d = struct('menu','Binary Filters',...
           'display','Convex hull',...
           'inparams',struct('name',       {'in',         'filli'},...
                             'description',{'Input image','Fill'},...
                             'type',       {'image',      'boolean'},...
                             'dim_check',  {0,            0},...
                             'range_check',{'bin',        []},...
                             'required',   {1,            0},...
                             'default',    {'a',          1}...
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
   [in,filli] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

out = convhull(in,filli);
