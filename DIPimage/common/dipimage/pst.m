%PST  Parametric Structure Tensor
%       Curvature and confidence in grey-value
%       images in 2/3D for lines and surfaces
%
% SYNOPSIS 2D:
%  out = pst(in, model, sg, st)
%
%  model: 'parabolic', 'circular'
%  out{1} curvature
%  out{2} confidence
%
% DEFAULTS:
%  model: 'circular'
%
% SYNOPSIS 3D:
%  out = pst(in, dimen, sg, st)
%
%  Computations are done within 2*st saftey margins.
%  The margin are filled with NaN.
%
%  dimen: 'line' assuming a line-like structure
%                being 1D, one curvaure is returned
%                out{1} curvature
%                out{2} corrected confidence
%         'surface' assuming a plane-like structure
%                2 principal curvatures are returned
%                out{1} first principal curvature
%                out{2} second principal curvature
%                out{3} confidence for first curvature
%                out{4} confidence for second curvature
%  sg: sigma of the gradient derivative
%  st: sigma of the tensor smoothing
%
% DEFAULTS:
%  dimen = 'line'
%  sg = 1
%  st = 4
%
% EXAMPLE 2D:
%  a = noise( cos(rr/2) * (rr<103),'gaussian',0.01,0)
%  p = pst(a,'parabolic',1.5,5);
%  c = pst(a,'circular',1.5,5);
%  dipshow(10, in, 'lin');
%  dipshow(12, 1000* abs(p{1})), 'log'); % curvature parabolic
%  dipshow(13, 1000* abs(c{1})), 'log'); % curvature circular
%  dipshow(14, p{2}, 'lin'); % confidence
%  dipshow(15, c{2}, 'lin'); % confidence
%
% EXAMPLE 3D:
%  a = testobject(newim([50 50 50]),'ellipsoid',1,15,[1 1 1],0,0,1,0);
%  pb = pst(a,'surface',1,3);
%  dipshow(1,pb{1},'lin');
%  dipshow(2,pb{2},'lin');
%  dipshow(3,pb{3},'lin');
%  dipshow(4,pb{4},'lin');
%  diplink(1,[2 3 4]);
%  dipmapping(1,'slice',25);
%
% SEE ALSO:
%  dip_pgst3dline, dip_pgst3dsurface, curvature, isophote_curvature
%
% LITERATURE: 2D
%  P.W. Verbeek, L.J. van Vliet and J. van de Weijer
%  Improved Curvature and Anisotropy Estimation for Curved Line Bundles
%  ICPR'98, Proc. 14th Int. Conference on Pattern Recognition, p.528-533, August 1998.
%
%  J. van de Weijer, L.J. van Vliet, P.W. Verbeek and M. van Ginkel
%  Curvature estimation in oriented patterns using curvilinear models
%  applied to gradient vector fields,
%  IEEE Transactions on Pattern Analysis and Machine Intelligence 23(9):1035-1042,2001
%
% LITERATURE: 3D
%  P. Bakker, P.W. Verbeek and L.J. van Vliet
%  Confidence and curvature estimation of curvilinear structures in 3-D
%  ICCV'01 (Vancouver, Canada), p. 139-144, July 9-12 2001.
%
%  P. Bakker, Image structure analysis for seismic interpretation
%  PhD. thesis, Delft University of Technology, 2002.

% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% 2D code from LvV
% 3D lowlevel code ported from PB
% Bernd Rieger, Dec 2003.



function out = pst(varargin)
d = struct('menu','Analysis',...
  'display','Parametric structure tensor',...
  'inparams',struct('name',{'in','opt','sg','st'},...
  'description',{'Input image','Option','Sigma of Derivative', 'Sigma of Tensor'},...
   'type',       {'image','option','array','array'},...
   'dim_check',  {0,0,1,1},...
   'range_check',{[],{'parabolic','circular','line','surface'},'R+','R+'},...
   'required',   {1,0,0,0},...
   'default',    {'a','circular',1,4}...
  ),...
  'outparams',struct('name',{'out'},...
   'description',{'Output image array'},...
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
   [in,opt,sg,st] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

N = ndims(in);

switch N
   case 2
      out = newimar(2);
      %LvV code in private
      switch opt
         case 'circular'
            [o1 o2 o3] = curvature_circular(in, sg(1), st(1));
            out{1}= o2;  % curvature
            out{2}= o3;  % confidence
            %out{3}= o1; %orientation_im,

         case 'parabolic'
            [o1 o2 o3] = curvature_parabolic(in, sg(1), st(1));
            out{1}= o2;  % curvature
            out{2}= o3;  % confidence
            %out{3}= o1; %orientation_im,
         otherwise
           error('Unkown model.');
      end
   case 3
   % only curvature within 2*st safty boundary
      if nargin ==1
         opt = 'line';
      end
      switch opt
         case 'line'
            out = newimar(2);
            [p1,t1,l2,l3,p3,t3] = ...
              structuretensor3d(in,sg,st,{'phi1','theta1','l2','l3','phi3','theta3'});
            g = dip_image(gradient(in,sg),'sfloat');
            mask = newim(in,'bin') | 1;   %do whole image, but keep masking
                                          %possibility of low-level function
            p1a = dip_image(newimar(p1,t1),'sfloat');
            p3a = dip_image(newimar(p3,t3),'sfloat');
            pout = dip_pgst3dline(mask,p1a,p3a,g,st);
            clear p1 t1 p3 t3 g mask
            %a = out{1};b = out{2};c = out{3};d = out{4};e = out{5};
            %see Peter Bakker thesis p.64/65
            wa = warning;
            warning('off');%lost of zeros due to margins
            tmp = pout{1}*pout{3} - pout{2}*pout{2};
            k1 = (pout{2}*pout{5} - pout{3}*pout{4})/tmp;
            k2 = (pout{1}*pout{4} - pout{1}*pout{5})/tmp;
            %curvature
            out{1} = sqrt(k1^2+k2^2);
            % confidence
            K = pout{1}*k1*k1 + pout{2}*k1*k2 + pout{3}*k2*k2;
            clear pout
            out{2} = (l2-l3+K)/(l2+l3+K);

            warning(wa);
         case 'surface'
            out = newimar(4);
            [l1,p1,t1,l2,p2,t2] = ...
             structuretensor3d(in,sg,st,{'l1','phi1','theta1','l2','phi2','theta2'});
            g = dip_image(gradient(in,sg),'sfloat');
            p1a = dip_image(newimar(p1,t1),'sfloat');
            p2a = dip_image(newimar(p2,t2),'sfloat');
            pout = dip_pgst3dsurface(p1a,p2a,g,st);
            clear p1 t1 p2 t2 g
            %a = pout{1};b = pout{2};c = pout{3};d = pout{4};
            %see Peter Bakker thesis p.44/45
            wa = warning;
            warning('off');%lost of zeros due to margins
            out{1} = pout{2}/pout{1}; %curvature 1
            out{2} = pout{4}/pout{3}; %curvature 2
            out{3} = (l1-l2 + (pout{2}^2/pout{1}))/ ...
                     (l1+l2 - (pout{2}^2/pout{1})); %confidence 1
            out{4} = (l1-l2 + (pout{4}^2/pout{3}))/ ...
                     (l1+l2 - (pout{4}^2/pout{3})); %confidence 2

            warning(wa);
         otherwise
            error('Unkown dimen.');
      end
   otherwise
      error('Only supported for 2 and 3D images.');
end
