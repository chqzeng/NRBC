%DT   Euclidean distance transform
%
% SYNOPSIS:
%  image_out = dt(image_in,edgeCondition,method)
%
% PARAMETERS:
%  method: 'fast', 'ties', 'true', 'bruteforce'
%
% DEFAULTS:
%  edgeCondition = 1
%  method = 'fast'
%
% LITERATURE:
%  P.E. Danielsson, Euclidean distance mapping,
%  Computer Graphics and Image Processing 14: 227-248, 1980
%
%  J.C. Mullikin, The vector distance transform in two and three dimensions,
%   CVGIP: Graphical Models and Image Processing 54(6): 526-535, 1992
%
% SEE ALSO:
%  vdt, gdt
%  dip_edt for anisotropically sampled images.
  
% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.
% Sept 2004, added literature (BR)

function image_out = dt(varargin)

d = struct('menu','Transforms',...
           'display','Euclidean distance transform',...
           'inparams',struct('name',       {'image_in',            'edgecondition', 'method'},...
                             'description',{'Input image (binary)','Edge Condition','Method'},...
                             'type',       {'image',               'option',        'option'},...
                             'dim_check',  {0,                     0,               0},...
                             'range_check',{[],                    {0,1},           {'fast', 'ties', 'true', 'bruteforce'}},...
                             'required',   {1,                     0,               0},...
                             'default',    {'a',                   1,               'fast'}...
                            ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      image_out = d;
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

image_out = dip_edt(image_in,ones(1,ndims(image_in)),edgecondition,method);
