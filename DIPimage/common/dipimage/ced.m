%CED   Coherence enhancing (anisotropic) diffusion
%
% SYNOPSIS:
%  out = ced(in, sg, st, iter, coef, flavour, resample)
%
% DESCRIPTION:
%   I_t = div( D nabla(I) )
%   with D the diffusion tensor: D = {{a, b},{b, c}}
%
% PARAMETERS:
%  sg = sigma first derivative
%  st = sigma of GradientStructureTensor, regularisation
%  iter = number of iterations
%  coef = 'const' : the coeffient a,b,c in the diffusion
%                   equation are taken constant,
%                   out = in + a dxx(in) + b dxy(in) + c dyy(in)
%         'variable' : the coeffient are taken into the
%                   derivative,
%                   out = in + dx(a dx(in)) + ...
%  flavour = 'all': all eigenvectors of the GST are taken
%                   into account to compute the coeffiecents
%            'first': only the first eigenvalue of the GST
%                   is used
%  resample = 'yes': OUT is resampled to the same size as IN.
%             'no' : OUT is twice the size of IN.
%             The input image must be resampled to be able to
%             steer the diffusion with a sigma of 0.5.
%
% DEFAULTS:
%  sg = 1
%  st = 3
%  iter = 1
%  coef = 'variable'
%  flavour = 'first'
%  resample = 'yes'
%
% LITERATURE:
%  J. Weickert, Anisotropic diffusion in image processing, Teubner (Stuttgart), 1998.
%  page 95 and 127
%
% NOTE: only implemented for 2D
%
% SEE ALSO: aniso, cpf, mcd, pmd


% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, Bernd Rieger, Feb 2002
% May 2002, changed steering by first eigenvalue to more sophisticated
%           methode (BR)
% May 2002, changed name from gsdif to ced (tribute to Weickert)
%           sh=0.5 const. no parameter any longer (BR)

function out = ced(varargin)

d = struct('menu','Diffusion',...
   'display','Coherence enhancing diffusion',...
   'inparams',struct('name',{'in','sg','st','iter','coef','flavour','res'},...
   'description',{'Input image','Sigma of derivative','Sigma of tensor',...
      'Iterations','Coefficient','Flavour','Resample'},...
   'type',     {'image','array','array','array','option','option','boolean'},...
   'dim_check',  {0,1,1,1,0,0,0},...
   'range_check',{[],'R+','R+','R+',{'variable','const'},{'all','first'},[]},...
   'required', {1,0,0,0,0,0,0},...
   'default',  {'a',1,3,1,'variable','first','yes'}...
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
   [in,sg,st,iter,coef,flavour,res] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ndims(in)~=2
   error('Only support for 2D images up to now.');
end

sh = 1;%sigma of 0.5 on orginal images -> must resample by 2
sg = 2*sg;
st = 2*st;
tmp = resample(in,2,0,'linear');

for ii =1:iter
    switch flavour
       case  'all'
        g = gradient(tmp, sg);
        t = g * g';
        %#function gaussf
        t = iterate('gaussf', t, st);
        t = t./trace(t);
        aa =  t{2,2};
        bb = -t{2,1};
        cc =  t{1,1};

       case  'first'
        [arg_v, conf, mu_1, mu_2] = ...
               structuretensor(tmp, sg, st, {'orientation','anisotropy','l1','l2'});

        % c_par = double( dip_percentile(mu_1^2,[],99.0,[1 1])/100 )
        % Weickert introduces c_par (C) as a magic number.
        % Van Vliet proposes to relate c_par (C) to the noise in the image.
        % For all points where (mu_1 < 2 * mu_2), l_2 < 0.6
        alpha = 0.01;
        c_par = 1; % see below
        m_par = 1;

        c_par = 1 * double( dip_percentile(mu_2^2,[],50.0,[1 1]) );
        l_1 = alpha;
        l_2 = (conf > 0.01) * ( alpha + (1.0 - alpha)*exp(-c_par/(mu_1 - mu_2)^(2*m_par)) ) + ...
              ~(conf > 0.01) * ( alpha );

        aa = l_1 * cos(arg_v)^2 + l_2 * sin(arg_v)^2;
        bb = sin(arg_v) * cos(arg_v) * (l_1 - l_2);
        cc = l_2 * cos(arg_v)^2 + l_1 * sin(arg_v)^2;

       otherwise
        error('Unkown flavour.');
    end

    switch coef
       case 'variable'
         tmp = dx(aa*dx(tmp,sh),sh) + ...
               dx(bb*dy(tmp,sh),sh) + ...
               dy(bb*dx(tmp,sh),sh) + ...
               dy(cc*dy(tmp,sh),sh) + ...
               tmp;
       case 'const'
         tmp = aa*dxx(tmp,sh) + 2*bb*dxy(tmp,sh) + cc*dyy(tmp,sh) + tmp;
       otherwise
          error('Unkown coeffient choice.');
   end
end

if res
   out = resample(tmp,.5,0);
else
   out = tmp;
end
