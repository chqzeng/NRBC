%TESTOBJECT   Creates bandlimited test objects
%
% SYNOPSIS:
%  image_out = testobject(image_in, object, height, radius, relrad, scalrad, scalamp, sigblur, subshift)
%
% PARAMETER:
%  object:   'ellipsoid','box','ellipsoidshell','boxshell'
%  height:   intensity of the object
%  radius:   object size
%  relrad:   relative radii in the different dimension, e.g. [1 1 1] for a 3D sphere
%  scalrad:  inner radius; scale of the shell
%  scalamp:  inner amplitude; scale of the shell
%  sigblur:  Gaussian blurring of the object
%  subshift: 'no', 'yes'
%            sub-pixel random shift around the center, to average out dicretization
%            effects over several instances of the same generated object
% DEFAULTS:
%  object   = 'ellipsoid'
%  height   = 255
%  radius   = 30
%  relrad   = 1     % equivalent to [1,1] for a 2D image, or [1,1,1] for a 3D image
%  scalrad  = 0
%  scalamp  = 0
%  sigblur  = 0     % no blurring
%  subshift = 'no'

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Apr 2001

function out = testobject(varargin)

d = struct('menu','Generation',...
           'display','Create bandlimited test object',...
           'inparams',struct('name',       {'image','object','height','radius','relrad','scalrad','scalamp','sigblur','subshift'},...
                             'description',{'Input image','Test object','Object height','Object radius',...
                                            'Rel. radius in each dimension','Scale radius','Scale amplitude',...
                                            'Sigma of Gaussian','Random subpixel shift'},...
                             'type',       {'image','option','array','array','array','array','array','array','boolean'},...
                             'dim_check',  {[],0,0,0,1,0,0,0,0},...
                             'range_check',{{'scalar','noncomplex'},{'ellipsoid','box','ellipsoidshell','boxshell'},'R','R+','R+','R+','R+','R+',[]},...
                             'required',   {1,0,0,0,0,0,0,0,0},...
                             'default',    {'a','ellipsoid',255,30,1,0,0,0,'no'}...
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
   [in,object,height,radius,relrad,scalrad,scalamp,sigblur,subshift] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

out = dip_testobjectcreate(in,object,height,radius,relrad,scalrad,scalamp,sigblur,subshift);
