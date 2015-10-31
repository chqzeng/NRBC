%STRUCTURETENSOR3D   Computes Structure Tensor on 3D images
%
% SYNOPSIS:
%  [l1,phi1,theta1,l2,phi2,theta2,l3,phi3,theta3,energy,cylindrical,...
%           planar] = structuretensor3d(image_in,dsigma,tsigma,outputs)
%
% PARAMETERS:
%  outputs: which outputs to produce. Cell array containing one or more
%           of these values:
%           'l1', 'phi1', 'theta1', 'l2', 'phi2', 'theta2', 'l3',
%           'phi3', 'theta3', 'energy', 'cylindrical' or 'planar'.
%
% DEFAULTS:
%  dsigma = 1
%  tsigma = 5

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, January 2001.
% 2 May 2001, Cris Luengo: Improved output argument handling

function varargout = structuretensor3d(varargin)

outputs={'l1','phi1','theta1','l2','phi2','theta2','l3','phi3','theta3',...
         'energy','cylindrical','planar'};
d=struct('name',       {'image_in','dsigma','tsigma'},...
         'description',{'Input image','Gradient sigma','Tensor sigma'},...
         'type',       {'image','array','array'},...
         'dim_check',  {0,1,1},...
         'range_check',{[],[],[]},...
         'required',   {1,0,0},...
         'default',    {'a',1,5}...
          );
o=struct('name',       outputs,...
         'description',{'Largest eigenvalue','Phi1','Theta1',...
                        'Middle eigenvalue','Phi2','Theta2',...
                        'Smallest eigenvalue','Phi3','Theta3',...
                        'Energy','Cylindricality','Planarity'},...
         'type',       {'image','image','image','image','image','image',...
                        'image','image','image','image','image','image'}...
        );
s=struct('menu','Analysis',...
         'display','Structure tensor 3D',...
         'inparams',d,...
         'outparams',o,...
         'output_select',1 ...
         );

if nargin == 1
   if ischar(varargin{1}) & strcmp(varargin{1},'DIP_GetParamList')
      varargout{1} = s;
      return
   end
end

try
   [image_in,dsigma,tsigma,outputs] = getparams(s,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
N = nargout; if N<1, N=1; end
varargout = cell(N,1);
if length(outputs) > N
   warning(['Too few output arguments: Only generating the first ',num2str(N),' images.'])
   outputs = outputs(1:N);
end
[varargout{:}] = dip_structuretensor3d(image_in,'firgauss',dsigma,...
                                       'iirgauss',tsigma,outputs);
