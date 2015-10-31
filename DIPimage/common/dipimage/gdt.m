%GDT   Grey-weighted distance transform
%
% SYNOPSIS:
%  [out, distance] = gdt(image_seed,image_weight,chamfer)
%
% PARAMETERS:
%  chamfer: Chamfer distance of 1, 3 or 5.
%           1: Only the 6 (8) direct neighbors in a 3x3 (3x3x3) neighbourhood are used.
%              Metric is 1.
%           3: All neighbors in in a 3x3 (3x3x3) neighbouhood are used.
%              2D Metric is 0.9481 for direct neighbors and 1.3408 for diagonals
%              3D Metric is .8940 for direct neighbors and 1.3409 and
%              1.5879 for the diagonals.
%           5: A neighborhood of (5x5) or (5x5x5) is used.
%              2D Metric is .9801 for direct neighbors and 1.4060 for diagonals
%              and 2.2044 for 'horse vault' offsets.
%              3D Metric is 0.9556, 1.3956, 1.7257, 2.1830, 2.3885 and 2.9540.
%  out:      Integrated grey-value over least-resistance path
%  distance: Metric distance over least-resistance path
%
% WARNING
%  The algorithm produces incomplete results in a 2-pixel thick border at the
%  edges of the image (4 for chamfer distance 5). Extend the image with a
%  dummy border if this is a problem for you. However, do make sure that this
%  border added has non-zero weights to avoid unexpected results.
%
% DEFAULTS:
%  chamfer = 3
%
% LITERATURE:
%  B.J.H. Verwer, P.W. Verbeek, S.T. Dekker, An efficient uniform cost algorithm applied to distance transforms,
%  IEEE Transactions PAMI, 11(4):425-429, 1989
%
%  P.W. Verbeek and B.J.H. Verwer, Shading from shape; the eikonal equation solved by grey-weighted
%  distance transform, Pattern Recognition Letters,11(10):681-690, 1990
%
%  B.J.H. Verwer, Local distances for distance transformations in two and three dimensions,
%  Pattern Recognition Letters, 12(11):671-682, 1991
%
% SEE ALSO:
%  dt, vdt
%  dip_gdt for custom chamfer metrics.
%  dip_growregionsweighted for anisotropically sampled images.

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.
% Changed parameter order: Cris Luengo, 12 June 2001.
% Sept 2004, added literature + extended help file (BR)
% Nov 2004, fixed help bug (BR, FF)

function [image_out, image_dist] = gdt(varargin)

d = struct('menu','Transforms',...
           'display','Grey-weighted distance transform',...
           'inparams',struct('name',       {'image_in',            'image_weight','chamfer'},...
                             'description',{'Input image (binary)','Weight image','Chamfer Size'},...
                             'type',       {'image',               'image',       'option'},...
                             'dim_check',  {0,                     0,             0},...
                             'range_check',{[],                    [],            {1,3,5}},...
                             'required',   {1,                     1,             0},...
                             'default',    {'a',                   'b',           3}...
                            ),...
           'outparams',struct('name',       {'image_out','image_dist'},...
                              'description',{'Output image','Distance Image'},...
                              'type',       {'image','image'}...
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
   [image_in,image_weight,chamfer] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if nargout > 1
   [image_out,image_dist] = dip_gdt(image_weight,image_in,chamfer,[],[]);
else
   image_out = dip_gdt(image_weight,image_in,chamfer,[],[]);
end
