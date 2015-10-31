%RECONSTRUCTION   Morphological reconstruction by dilation
%
% SYNOPSIS:
%  out = reconstruction(marker,mask,connectivity)
%
% PARAMETERS:
%  marker:       seed image for reconstruction
%  mask:         image to be reconstructed
%  connectivity: defines the metric, that is, the shape of the structuring
%     element.
%     * 1 indicates city-block metric, or a diamond-shaped S.E in 2D.
%     * 2 indicates chessboard metric, or a square structuring element in 2D.
%     For 3D images use 1, 2 or 3.
%
% EXAMPLE:
%  a = 255-readim('cermet')
%  b = erosion(a,20)
%  c = reconstruction(b,a)
%  c = b==c
%  b(c) = a(c)
%  c = reconstruction(b,a)
%
% EXAMPLE:
%  a = readim('cermet')<128
%  b = label(bskeleton(a,0,'looseendsaway'))
%  c = reconstruction(b,a*1000)
%
% LITERATURE:
%  K. Robinson and P.F. Whelan: Efficient morphological reconstruction: a downhill filter
%  Pattern Recognition Letters 25 (2004) 1759-1767.
%
% SEE ALSO:
%  bpropagation

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2002.
% April 2002:  Changed name and parameter order (CL)
% 1 July 2008: Changed underlying implementation, added CONNECTIVITY. (CL)
% 2 Sept 2011: Forcing 'mask' to sfloat in some situations, to avoid a limitation in the C code. (CL)
% 6 Sept 2011: Better solution to problem above: removing negative values in 'marker'. (CL)

function out = reconstruction(varargin)

d = struct('menu','Morphology',...
  'display','Reconstruction by dilation',...
  'inparams',struct('name',       {'marker',      'mask',      'connectivity'},...
                    'description',{'Marker image','Mask image','Connectivity'},...
                    'type',       {'image',       'image',     'array'},...
                    'dim_check',  {0,             0,           0},...
                    'range_check',{[],            []           'N+'},...
                    'required',   {1,             1,           0},...
                    'default',    {'a',           'b',         1}...
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
   [marker,mask,connectivity] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

dt = datatype(mask);
if dt(1)=='u'                 % mask is an unsigned type
   dt = datatype(marker);
   if dt(1)~='u'              % marker is not an unsigned type
      marker(marker<0) = 0;   % make sure the marker has no negative values
   end
end

out = dip_morphologicalreconstruction(marker,mask,connectivity);
