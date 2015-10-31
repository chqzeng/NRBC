%QUADRATURETENSOR   Computes Quadrature Tensor on 2D images
%
% SYNOPSIS:
%  [l1,phi1,l2,phi2] = quadraturetensor(image_in,sigma,outputs)
%
% PARAMETERS:
%  outputs: which outputs to produce. Cell array containing one
%           or more of these values: 'l1','phi1','l2','phi2'.
%
% DEFAULTS:
%  sigma = 1
%
% Literature:
%  H. Knutsson, Representing Local Structure Using Tensors, The 6th
%  Scandinavian Conference in Image Analysis, June 19-22,244-251,
%  Oulu, Finland

% (C) Copyright 1999-2006               Quantitative Imaging Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Frank Faas december 2006

function varargout = quadraturetensor(varargin)
outputs={'l1','phi1','l2','phi2'};

d=struct('name',       {'image_in','sigma'},...
         'description',{'Input image','Sigma'},...
         'type',       {'image','array'},...
         'dim_check',  {0,0},...
         'range_check',{[],[]},...
         'required',   {1,0},...
         'default',    {'a',1}...
	 );

o=struct('name',       outputs,...
         'description',{'l1','phi1','l2','phi2'},...
         'type',       {'image','image','image','image'});

s=struct('menu','Analysis',...
         'display','Quadrature tensor 2D',...
         'inparams',d,...
         'outparams',o,...
         'output_select',1);

if nargin == 1
  if ischar(varargin{1}) & strcmp(varargin{1},'DIP_GetParamList')
    varargout{1} = s;
    return
  end
end

try
  [image_in,sigma,outputs] = getparams(s,varargin{:});
catch
  if ~isempty(paramerror)
    error(paramerror)
  else
    error(firsterr)
  end
end

N = nargout; if N<1, N=1; end
varargout = cell(N,1);

if length(size(image_in))~=2
  error('DIPImage Error : Dimensionality not supported')
end

if length(outputs) > N
  warning(['Too few output arguments: Only generating the first ',num2str(N),' images.'])
  outputs = outputs(1:N);
end

p=pi/3*[0:2];
sigmaf=100;
T11=[];T12=[];T22=[];
x=yy(image_in);
y=xx(image_in);
r=rr(image_in);
for ii=1:3
  u=cos(p(ii))*x-sin(p(ii))*y;
  v=sin(p(ii))*x+cos(p(ii))*y;
  f{ii}=exp(-r.^2/(2*sigmaf^2))*u*(u>0)*cos(atan2(v,u));
  q{ii}=abs(ift(ft(image_in)*f{ii}));
  cosii=cos(p(ii));
  sinii=sin(p(ii));
  if ii==1
    T11=(cosii^2    -1)*q{ii};
    T12=(cosii*sinii  )*q{ii};
    T22=(sinii^2    -1)*q{ii};
  else
    T11=T11+(cosii^2    -1)*q{ii};
    T12=T12+(cosii*sinii  )*q{ii};
    T22=T22+(sinii^2    -1)*q{ii};
  end
end

[varargout{:}]=dip_symmetriceigensystem2(T11, T12, T22,outputs);

