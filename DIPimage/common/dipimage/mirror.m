%MIRROR   Mirror an image
%
% Mirrors an image, i.e the pixels in those dimensions of image
%  specified.
%
% SYNOPSIS:
%  image_out = mirror(image_in, mirror_type, mirror_parameters)
%
% PARAMETERS:
%  mirror_type = 'x-axis','y-axis','z-axis','point','user'
%                 for dimensions > 3 use the 'user' option and specify
%                 the axes other than x,y,z by for example [0 0 0 1]
%                 mirror at x,y,z and point work for all dimensions
%  mirror_parameter = for mirror_type 'user':
%                     1 x N boolean array containing the mirror axes
%                     e.g. [1 1 1] 3D point mirroring
%
% DEFAULT:
%  mirror_type = 'point'

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, May 2001.
% ??18 November 2001 (CL): 'mirror_parameters' works now.
% 30 Oct 2001 (BR): fix 'mirror_parameters' changes from CL

function out = mirror(varargin)
d = struct('menu','Manipulation',...
           'display','Mirror',...
           'inparams',struct('name',       {'in',         'mir',         'para'},...
                             'description',{'Input image','Mirror type', 'Mirror parameter'},...
                             'type',       {'image',      'option',      'array'},...
                             'dim_check',  {0,            0,             1},...
                             'range_check',{[],           {'x-axis','y-axis','z-axis','point','user'},'N'},...
                             'required',   {1,            0,             0},...
                             'default',    {'a',          'point',       1}...
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
   [in,mir,para] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

di = ndims(in);
mir_para = repmat(0,1,di);
switch mir
case 'x-axis'
    mir_para(1) = 1;
case 'y-axis'
    if di>=2
        mir_para(2) = 1;
    end
case 'z-axis'
    if di>=3
        mir_para(3) = 1;
    end
case 'point'
    mir_para(:) = 1;
case 'user'
    mir_para = para;
end
out = dip_mirror(in,mir_para);
