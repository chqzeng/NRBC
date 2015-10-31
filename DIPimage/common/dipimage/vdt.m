%VDT   Vector components of Euclidean distance transform
%
% SYNOPSIS:
%  image_out = vdt(image_in,edgeCondition,method)
%
% PARAMETERS:
%  method: 'fast', 'ties', 'true', 'bruteforce'
%
% DEFAULTS:
%  edgeCondition = 1
%  method = 'fast'
%
% EXAMPLE:
%  timg = readim<200;
%  d1 = dt(timg)
%  d2 = vdt(timg)
%  norm(d2)-d1
%
% SEE ALSO:
%  dt, gdt
%  dip_vdt for anisotropically sampled images.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.
% Sep 2004, extended help (BR)

function imar_out = vdt(varargin)

d = struct('menu','Transforms',...
           'display','Vector distance transform',...
           'inparams',struct('name',       {'image_in',            'edgecondition', 'method'},...
                             'description',{'Input image (binary)','Edge Condition','Method'},...
                             'type',       {'image',               'option',        'option'},...
                             'dim_check',  {0,                     0,               0},...
                             'range_check',{[],                    {0,1},           {'fast', 'ties', 'true', 'bruteforce'}},...
                             'required',   {1,                     0,               0},...
                             'default',    {'a',                   1,               'fast'}...
                            ),...
           'outparams',struct('name',{'imar_out'},...
                              'description',{'Output image array'},...
                              'type',{'image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      imar_out = d;
      return
   end
end
try
   [image_in,edgecondition,method] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

imar_out = dip_vdt(image_in,ones(1,ndims(image_in)),edgecondition,method);
