%RADONCIRCLE   Compute Radon/Hough transform to find circles/spheres
%
% SYNOPSIS:
%  [rt, p, o] = radoncircle(in, radii, sigma, enhance, minval)
%
% OUTPUT: 
%  rt:  Radon transform space (normalized by 1/r)
%       the template is generated with a correction factor; 
%       see eq. (29) ref 1. 
%  p:   Parameters of the found circles as (N, [x y r])
%  o:   Overlay image of input with found circles
%
% PARAMETERS:
%  radii:   Range of radii to search, e.g. [30:5:45]
%           use more radii for higher sensitivity.
%  sigma:   Width of the structures.
%  enhance: Effective peak enhancement in the Radon image
%           by using gradient information.
%           Only for 2D input images.
%  minval:  Minimal height difference between peak and valley
%           in the Radon image; smaller is more sensitive.
%           Give as factor of the dynamic range.
%
% DEFAULTS:
%  radii = [10:20]
%  sigma = 1
%  enhance = 'no'
%  minval = 0.2
%
% NOTE:
%  Works for nD, except overlay ouput. The expected error in the radius 
%  estimation is below 0.1 pixels for radius>10 pixel.
%
% EXAMPLE:
%  aa = gaussianlineclip(rr-30) + gaussianlineclip(rr-50);
%  bb = noise(aa + shift(aa,[10,-30]),'gaussian',0.1)
%  [rt,p,o] =  radoncircle(bb, [24:2:56])
%
% LITERATURE:
%  C.L. Luengo Hendriks, M. van Ginkel, P.W. Verbeek and L.J. van Vliet,
%   The Generalized Radon Transform: Sampling, Accuracy and Memory Considerations,
%   Pattern Recognition, 38(12):2494-2505, 2005.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Oct 2006 (based on code by CL and MvG).
% 19 September 2007: Better input parsing, fixed bug when no maxima in Radon space
% 17 January 2008: Added enhancing of peak, difficult for noisy images
% 03 August 2009: Returns Radon "score" if requested. To keep this backwards
%                 compatible, only available from the command when using
%                 a keywords style invocation (plus you need mtl_parse_keywords)
% 10 May 2010: Change get_subpixel for interp1, as it now give 2 values for 1D array

function varargout = radoncircle(varargin)

d = struct('menu','Transforms',...
           'display','Radon transform (circle/sphere)',...
           'inparams',struct('name',       {'in',   'radii','sigma','enhance','minvalue'},...
                             'description',{'Input image','Radius range [r0:r1]','Sigma','Enhance ','Height difference'},...
                             'type',       {'image',      'array','array','boolean','array'},...
                             'dim_check',  {0,            [1,-1],0,[],0},...
                             'range_check',{[],           'R+','R+','','R+'},...
                             'required',   {1,            0,0,0,0},...
                             'default',    {'a',          [10:20],1,0,0.2}...
                            ),...
           'outparams',struct('name',{'out_radon','para','im_overlay'},...
      'description',{'Radon transform','Circle(s) parameters [r x y (z)]','Overlay'},...
                              'type',{'image','array','image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      varargout{1} = d;
      return
   end
end
if (nargin>2) & (ischar(varargin{2}))
   if isempty(which('mtl_parse_keywords'))
      error('Unexpected string argument (#2)');
   end
   keywords={{'radii','array',d.inparams(2).default},...
             {'sigma','array',d.inparams(3).default},...
             {'enhance','trigger'},...
             {'verbose','trigger'},...
             {'minval','array',d.inparams(5).default},...
             {'score','trigger'}};
   kwd=mtl_parse_keywords(varargin(2:end),keywords);
   in=varargin{1};
   radii=kwd.radii;
   sigma=kwd.sigma;
   enhance=kwd.enhance;
   verbose=kwd.verbose;
   minvalue=kwd.minval;
   score=kwd.score;
else
   score=0;
   try
      [in,radii,sigma,enhance,minvalue] = getparams(d,varargin{:});
   catch
      if ~isempty(paramerror)
         error(paramerror)
      else
         error(firsterr)
      end
   end
   verbose=0;
end

out = newim([size(in),length(radii)],'sfloat');

if enhance
   if ndims(in)~=2
      error('Enhance option only for 2D input.');
   end
   g = gradient(in,sigma);
   gn = norm(g);
   gn(gn==0) = 1;
   g = g./norm(gn); 
   %ori = structuretensor(in, sigma, 4*sigma,{'orientation'});
   %g = newimar(cos(ori),sin(ori));
   out = double(out);
   tmpin = double(in);
   g1 = double(g{1});
   g2 = double(g{2});
   for ii = 1:length(radii)
      out(:,:,ii) = write_add_double(tmpin,radii(ii)*g1,radii(ii)*g2)/radii(ii);
   end
   clear tmpin g1 g2
   out = dip_image(out,'sfloat');
else
   ftin = ft(in);
   d = ndims(in);
   ss = repmat({':'},[1,ndims(in)]);
   jj = 0;
   for ii=radii
      %correct the effective radius, see eq. (29) Luengo et al.
      radius_c = ii/2 + sqrt(ii^2/4 - (d-1)*sigma^2);
      if ~isreal(radius_c)
         radius_c = ii;
         fprintf(' Radius %d is unreliable.\n',ii)
      end
      if verbose
         fprintf(' Processing radius %2.2f\n',radius_c);
      end
      tmp = gaussianlineclip(rr(in)-radius_c, sigma);
      tmp = tmp./sum(tmp);
      ftdisk = ft(tmp);
      %tmp = real(ift(ftin*conj(ftdisk))); %for asymmetric shapes 
      tmp = real(ift(ftin*ftdisk)); 
      out(ss{:},jj) = tmp;
      jj=jj+1;
   end
end
varargout{1}=out;
varargout{2}=[];
varargout{3}=[];
if nargout <2;
   return;
end

minvalue = (max(out)-min(out))*minvalue;
maxima = dip_localminima(-out,[],ndims(out),minvalue,1e9,1);
m = findcoord(maxima);
if isempty(m)
   warning('Could not find any good maxima in the Radon Transform.');
   return;
end
sv = double(out(maxima))';
I = (sv-min(out)) >= minvalue;
sv = sv(I);
m = m(I,:);
if isempty(m)
   warning('Could not find any good maxima in the Radon Transform.');
   return;
end
m = subpixlocation(out,m,'parabolic','maximum');
for ii=1:size(m,1)
   r(ii) = interp1(radii, double(m(ii,end))+1);
end
out2 = m;
out2(:,end) = r;
if score
   out2=[out2,sv];
end
varargout{2} = out2;

if nargout<3;
   return;
end

lab = newim(in,'uint8');
sz = size(in);
for ii=1:size(m,1)
   if ndims(in)==2
      c = (xx(sz,'corner')-out2(ii,1))^2+(yy(sz,'corner')-out2(ii,2))^2< r(ii)^2;
   else
      c =(xx(sz,'corner')-out2(ii,1))^2+(yy(sz,'corner')-out2(ii,2))^2+(zz(sz,'corner')-out2(ii,3))^2< r(ii)^2;
   end
   c = xor(c,bdilation(c));
   lab(c) = ii;
end
varargout{3} = overlay(stretch(in),lab);
