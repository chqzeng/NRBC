%PERCF_ADAP   Adaptive percentile filtering.
%  
% SYNOPSIS:
%  out = percf_adap(in, parameter_im, filtersize, percentile)
%
% PARAMETERS:
%  parameter_im = ImageArray containing the orientation images
%     2D: angle of the orientation
%     3D: polar coordinate phi, theta for intrinsic 1D structures
%         polar coordinates of two orientations for intrinsic 2D structures
%
% DEFAULTS:
%   filtersize = 7
%   percentile = 50 (median filtering)
%
% LITERATURE: 
%  P. Bakker, Image structure analysis for seismic interpretation, 
%   PhD Thesis, TU Delft, The Netherlands, 2001 
%  L. Haglund, Adaptive Mulitdimensional Filtering,
%   PhD Thesis, Link"oping University, Sweden, 1992
%  W.T. Freeman, Steerable Filters and Local Analysis of Image Structure, 
%   PhD Thesis, MIT, USA, 1992
%
% SEE ALSO: gaussf_adap, gaussf_adap_banana, percf_adap_banana

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2002
% Dec 2002, removed redundant stuff BR

function out = percf_adap(varargin)

d = struct('menu','Adaptive Filters',...
	'display','Adaptive percentile filtering',...
	'inparams',struct('name',{'in','param','fitlersize','perc'},...
   'description',{'Input image','Parameter image','Filter size','Percentile'},...
   'type', 		{'image','image','array','array'},...
   'dim_check',  {0,0,1,0},...
   'range_check',{[],[],'R+','R+'},...
   'required',	{1,1,0,0},...
   'default', 	{'a','p',7,50}...
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
   [in,param,filtersize,perc] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ndims(in)>3
   error('Only supporting <4D images up to now.');
end


out = dip_adaptivepercentile(in,dip_image(param,'sfloat'),filtersize,perc); 

