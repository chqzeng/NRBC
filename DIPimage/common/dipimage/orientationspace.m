%ORIENTATIONSPACE   Orientation space
%
% SYNOPSIS:
%  image_out = orientationspace(image_in,order,centre,bandwidth)
%
% DESCRIPTION
%    See the paper at
%    http://www.ph.tn.tudelft.nl/~lucas/publications/2001/NVPHBV2001MGLVPV/NVPHBV2001MGLVPV.html
%    for a description.
%
%    The relation between the parameters in the paper (N,fc,bf) and
%    the parameters of this function is as follows:
%
%     N=2*order+1
%    fc=centre
%    bf=bandwidth*centre
%
% DEFAULTS:
%  order = 8
%  centre = 0.2
%  bandwidth = 0.8


% (C) Copyright 2000-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel, October 2000.

function image_out = orientationspace(varargin)

if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      image_out = struct('menu','none');;
      return
   end
end
inp = struct('name', {'image_in', 'order', 'centre', 'bandwidth'},...
              'description',{'Input image','Angular order',...
                             'Centre frequency', 'Bandwidth (%)'},...
              'type',       {'image', 'array', 'array', 'array'},...
              'dim_check',  {0, 0, 0, 0},...
              'range_check',{[],[],[],[]},...
              'required',   {1,0,0,0},...
              'default',    {'a',8,0.2,0.8}...
             );

d = struct('menu','Analysis',...
           'display','Orientation space',...
           'inparams', inp,...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
try
   [image_in,order,centre,bandwidth] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

image_out = dip_orientationspace(image_in,order,1,0,0,centre,bandwidth,[],...
                        {'slices_normal','angular_gauss','spatial'});
