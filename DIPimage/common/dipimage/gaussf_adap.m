%GAUSSF_ADAP   Adaptive Gaussian filtering.
%  
% SYNOPSIS:
%  out = gaussf_adap(in, parameter_im, sigmas, order, expo)
%
% PARAMETERS:
%  parameter_im = ImageArray containing the orientation images
%     2D: angle of the orientation
%     3D: polar coordinate phi, theta for intrinsic 1D structures
%         polar coordinates of two orientations for intrinsic 2D structures
%  sigmas = Array containing the sigmas of the derivatives
%     2D: For intrinsic 1D structures, the first value is along the contour, 
%         the second perpendicular to it.
%     3D: For intrinsic 2D structures, usage: [0 sg1 sg2]
%         For intrinsic 1D structures, usage: [0 0 sg]
%     For sigma 0 no convolution is done is this direction.
%  order = Derivative order
%  expo  = Moments 
%
% DEFAULTS:
%  parameter_im = [] means comptued orientation along a line
%  order = 0
%  expo  = 0
%
% EXAMPLE:
%  a = readim;
%  p = structuretensor(a,1,3,{'orientation'});
%  b = gaussf_adap(a,p,[2 0])
%
% EXAMPLE:
%  Smoothing along a 1D line-like object in a 3D image
%  a = readim('chromo3d');
%  [p3,t3] = structuretensor3d(a,1,[3 3 1],{'phi3','theta3'});
%  p = newimar(p3,t3);
%  b = gaussf_adap(a,p,[0 0 2])
%
%  Smoothing in a 2D plane in 3D
%  [p2,t2,p3,t3]=structuretensor3d(a,1,[3 3 1],{'phi2','theta2','phi3','theta3'});
%  p = newimar(p2,t2,p3,t3);
%  b = gaussf_adap(a,p,[0 2 2])
%
% LITERATURE: 
%  P. Bakker, Image structure analysis for seismic interpretation, 
%   PhD Thesis, TU Delft, The Netherlands, 2001 
%  L. Haglund, Adaptive Mulitdimensional Filtering,
%   PhD Thesis, Link"oping University, Sweden, 1992
%  W.T. Freeman, Steerable Filters and Local Analysis of Image Structure, 
%   PhD Thesis, MIT, USA, 1992
%
% SEE ALSO: gaussf_adap_banana, percf_adap, percf_adap_banana


% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2002
% April 2002, changed help (BR)
% May 2002,  changed truncation to 3 sigma (BR)
% June 2002, change 2D plane like smoothing, sigma input is now
%            consitent (BR)
% July 2003, added moments computation after request by LvV (BR) 
% June 2004, added default computation of parameter image (BR)
% July 2008, bug fix for default 3D computation (BR)

function out = gaussf_adap(varargin)

d = struct('menu','Adaptive Filters',...
	'display','Adaptive Gaussian filtering',...
	'inparams',struct('name',{'in','param','sigma','order','expo',},...
   'description',{'Input image','Parameter image',...
      'Sigmas of derivative','Derivatives order','Moments'},...
   'type', 		{'image','image','array','array','array'},...
   'dim_check',  {0,0,1,1,1},...
   'range_check',{[],[],'R+','R+','N'},...
   'required',	{1,1,1,0,0},...
   'default', 	{'a','[]',[2 0],0,0}...
	),...
   'outparams',struct('name',{'out'},...
   	  'description',{'Output'},...
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
   [in,param,sigma,order,expo] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if isempty(param)
   switch ndims(in)
      case 2
         param = structuretensor(in,1,3,{'orientation'});
      case 3
         [p3,t3] = structuretensor3d(in,1,[3 3 1],{'phi3','theta3'});
         param = newimar(p3,t3);
      otherwise
         error('Only supporting <4D images up to now.');
   end
end

if ndims(in)>3
   error('Only supporting <4D images up to now.');
elseif ndims(in)==3 & length(param)==4
%added for convenint sigma in high level routine
   sigma(1) =sigma(2); 
   sigma(2) =sigma(3);
   sigma(3) =0; 
end 

out = dip_adaptivegauss(in,dip_image(param,'sfloat'),sigma,order,3,expo); 

