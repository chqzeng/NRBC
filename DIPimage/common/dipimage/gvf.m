%GVF   Computes an external force using Gradient Vector Flow
%
% SYNOPSIS:
%  f = gvf(edge_image,mu,iterations)
%
% PARAMETERS:
%  edge_image : scalar image that has large values at the locations
%               you want the snake to end up ( e.g.: gradmag(a) )
%  mu :         smoothness parameter
%  iterations : number of iterations computed
%
% DEFAULTS:
%  mu = 0.2
%  iterations = 80
%
% EXAMPLE:
%  a = noise(50+100*gaussf(rr>85,2),'gaussian',20)
%  f = gvf(gradmag(a,8),1);
%  x = 120+50*cos(0:0.1:2*pi); y = 140+60*sin(0:0.1:2*pi);
%  s = [x',y'];
%  snakedraw(s);
%  s = snakeminimize(s,f,0.2,0.4,1,0,60);
%  snakedraw(s);
%
% LITERATURE:
%  C. Xu, J.L. Prince, "Snakes, Shapes and Gradient Vector Flow",
%     IEEE-TIP 7(3):359-369 (1998)
%
% SEE ALSO: snakeminimize, vfc, dip_image/gradient

% (C) Copyright 2009, All rights reserved.
% Cris Luengo, Uppsala, 21 September 2009.

function out = gvf(varargin)

d = struct('menu','Segmentation',...
           'display','Gradient Vector Flow',...
           'inparams',struct('name',       {'edge_image',     'mu',        'iterations'},...
                             'description',{'Input image',    'Smoothness','Iterations'},...
                             'type',       {'image',          'array',     'array'},...
                             'dim_check',  {2,                0,           0},...
                             'range_check',{{'real','scalar'},'R+',        'N+'},...
                             'required',   {1,                0,           0},...
                             'default',    {'a',              0.2,         80}...
                            ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output force image'},...
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
   [edge_image,mu,iterations] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

f = gradient(edge_image);
b = norm(f);
c = b*f;
out = f;
for ii=1:iterations
   out{1} = out{1} + mu*laplace(out{1}) - b*out{1} + c{1};
   out{2} = out{2} + mu*laplace(out{2}) - b*out{2} + c{2};
end
out = out./max(norm(out),1e-10);
