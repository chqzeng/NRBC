%OVERLAY_VECTOR  Overlay a grey-value image with a vector image
%
% SYNOPSIS:
%  out = overlay_vector(in, vector, subsample, scaling)
%
% PARAMETERS:
%  vector: an image array
%  subsampling: subsampling for ploting the vectors
%  scaling: factor to stretch the gradients
%
% DEFAULTS:
%  subsampling = 4
%  scaling = 4
%
% EXAMPLE:
%  a = readim('trui')
%  overlay_vector(a,gradient(a))
%
% Green means the vector is pointing up, red down.
% Only for points where the gradient is larger than the 
%  average gradient we plot lines. 

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Dec 2002

function out=overlay_vector(varargin)

d = struct('menu','Display',...
  'display','Overlay image with vector field',...
  'inparams',struct('name',{'a','g','ss','scale'},...
         'description',{'Grey  image','Vector image','Subsampling','Scaling'},...
         'type',       {'image','image','array','array'},...
         'dim_check',  {0,0,0,0},...
         'range_check',{[],[],'R+','R+'},...
         'required',   {1,1,0,0},...
         'default',    {'','',4,4}...
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
   [a,g,ss,scale] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ndims(a) >2
   error('Only 2D images.');
end
if ~isvector(g)
   error('vector field no image array');
end

%a = readim('/data/huge/biology/wood/wood')
%g = gradient(a);
%ss = 5;
%scale = 5;
ng = norm(g);
mg = max(ng);
g = g./mg;


sz =  size(a);
sz2 = sz./2;
m1 = mod(xx(a)+sz2(1),ss)<1;
m2 = mod(yy(a)+sz2(2),ss)<1;

m = m1 & m2 & (ng > mean(ng));
ng =ng/mean(ng);
ang_m = atan2(g{2},g{1})>0;
mr = m & ang_m;
mg = m & ~ang_m;

sc = findcoord(mr);
b1 = scale*ng(mr)*g{1}(mr);
b2 = scale*ng(mr)*g{2}(mr);
b3 = double([b1; b2]);
ec = sc + double(b3)';
ec(ec < 0) =0;
tmp = repmat(size(a),size(ec,1),1);
ec = min(ec,tmp);
ec = round(ec);
rot = newim(sz);
for ii = 1:length(sc)
   rot = drawline(rot,sc(ii,:),ec(ii,:));
end

sc = findcoord(mg);
b1 = scale*ng(mg)*g{1}(mg);
b2 = scale*ng(mg)*g{2}(mg);
b3 = double([b1; b2]);
ec = sc + double(b3)';
ec(ec < 0) =0;
tmp = repmat(size(a),size(ec,1),1);
ec = min(ec,tmp);
ec = round(ec);
gru = newim(sz);
for ii = 1:length(sc)
   gru = drawline(gru,sc(ii,:),ec(ii,:));
end

out = newimar(a,a,a);
out{1}(rot>1) = 255;
out{2}(gru>1) = 255;
out = colorspace(out,'RGB');
