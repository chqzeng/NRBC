%CURVATURE   Curvature in grey value images in nD
%
% SYNOPSIS:
%  out = curvature(in, dimen, sg, st)
%
%  dimen: 'line' assuming a line-like structure
%                being 1D, one curvaure is returned
%         'surface' assuming a plan-like structure
%                being (n-1)D, (n-1) principal curvatures are returned
%  sg: sigma of the gradient derivative
%  st: sigma of the tensor smoothing
%
% DEFAULTS:
% dimen = 'line'
%  sg = 1
%  st = 4
%
% LINES:
%  out: curvature (1/bending radius)
%       in 2D: x-axis runs from - to +, and gives a sign to the curvature
%       in 3D or higher: curvature is always positive
%  EXAMPLE:
%  a = sin(rr/3)
%  b = curvature(a,'line',1,4)
%
% SURFACES:
%  out: magnitude of the principal curvatures (1/bending radius)
%  EXAMPLE:
%  Curvature of a 3D ball with curvature 0.066 (radius 15)
%  a = testobject(newim([50 50 50]),'ellipsoid',1,15,[1 1 1],0,0,2,0);
%  k = curvature(a,'surface',1,4);
%  dipshow(1,a,'lin');
%  dipshow(2,k{1},'lin');
%  dipshow(3,k{2},'lin');
%  diplink(1,[2 3]);
%  dipmapping(1,'slice',25);
%
% NOTE: This algorithms works for edge and ridge-like structures.
%       For 4D and higher the output will be subsampled by st.
%
% SEE ALSO:
%  isophote_curvature, orientation4d, curvature_thirion
%
% LITERATURE: Lines
%  M. van Ginkel, J. van de Weijer, P.W. Verbeek, and L.J. van
%   Vliet.  Curvature estimation from orientation fields.  In B.K.
%   Ersboll and P. Johansen, editors, SCIA'99, Proc. 11th Scandi-
%   navian Conf. on Image Analysis (Kangerlussuaq, Greenland),
%   p. 545-551. Pattern Recognition Society of Denmark, June 7-11 1999.
%
%  B.Rieger, L.J. van Vliet, Curvature of n-dimensional space
%   curves in grey-value images, IEEE Transactions on Image
%   Processing, 11(7):738-745, 2002
%
% LITERATURE: Surfaces
%  B. Rieger, F.J. Timmermans, van L.J. Vliet and P.W. Verbeek,
%  On curvature estimation of surfaces in 3D grey-value images and
%  the computation of shape descriptors, IEEE Transactions on Pattern
%  Analysis and Machine Intelligence, 26(8), p.1088-1094, 2004

%
% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2002.
% Nov, 2002, added nD code
% Dec, 2002, added surface curvatures
% Dec, 2002, removed bug in 3D line code, after release arghs
% Jan, 2003, replaced ./ by .*(1/)
% Apr, 2003, replaced norm(DM*T) by dedicated routine to save memory
% May, 2003, extended help file
% 10 October 2007: Calling DERIVATIVE instead of DIP_GAUSS directly. (CL)

function out = curvature(varargin)
d = struct('menu','Analysis',...
  'display','Curvature',...
  'inparams',struct('name',       {'in',   'opt','sg','st'},...
  'description',{'Input image','','Sigma of Derivative', 'Sigma of Tensor'},...
   'type',       {'image','option','array','array'},...
   'dim_check',  {0,0,1,1},...
   'range_check',{[],{'line','surface'},'R+','R+'},...
   'required',   {1,0,0,0},...
   'default',    {'a','line',1,4}...
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
   [in,opt,sg,st] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

N = ndims(in);

switch opt
   case 'line'
      switch N
         case 2
            %use MvG code
            %phi=structuretensor(in,sg,st,{'orientation'});
            %phimap=exp(2j*phi);
            %phicnj=conj(phimap);
            %phidx=0.5*imag(phicnj*(dx(real(phimap),1)+j*dx(imag(phimap),1)));
            %phidy=0.5*imag(phicnj*(dy(real(phimap),1)+j*dy(imag(phimap),1)));
            %out=-sin(phi)*phidx+cos(phi)*phidy;
            % 5 Sep 2005 - MvG - Use the new structure tensor feature instead
            out=structuretensor(in,sg,st,1,{'curvature'});
         case 3
            %use BR code
            %use analytic solution for GST and 5D Knutsson mapping
            [phi,theta]=structuretensor3d(in,sg,st,{'phi3','theta3'});
            Knut_T = newimar(5);
            Knut_T{1} = (sin(theta))^2*cos(2*phi);
            Knut_T{2} = (sin(theta))^2*sin(2*phi);
            Knut_T{3} = sin(2*theta)*cos(phi);
            Knut_T{4} = sin(2*theta)*sin(phi);
            Knut_T{5} = sqrt(3)*((cos(theta))^2-1/3);
            DM = newimar(5,3);
            sk = 1;
            for ii= 1:5
               DM{ii,1}=dx(Knut_T{ii},sk);
               DM{ii,2}=dy(Knut_T{ii},sk);
               DM{ii,3}=dz(Knut_T{ii},sk);
            end
            clear Knut_T
            T = newimar(3);
            T{1} = cos(phi)*sin(theta);
            T{2} = sin(phi)*sin(theta);
            T{3} = cos(theta);
            clear phi theta
            out = 0.5 *proj(DM,T);
         otherwise
            if N==4 %faster implementation
               T = orientation4d(in,sg,st);
            else
               G = gst_subsample(in,sg,st);
               [ew,TT]=jacobi(G);
               clear G ew
               T=TT{:,N};%smallest eigenvalue/vector
               clear TT
             end
             M = T*T';
             DM = newimar(N*N,N);
             sigma = ones(N,1);
             order = zeros(N,1);
             for ii= 1:N*N
             for jj =1:N
               order(jj) = 1;
               DM{ii,jj} = derivative(M{ii},sigma,order);
               order(jj) = 0;
             end
             end
             clear M
             out = proj(DM,T).*(1/sqrt(2));
         end
   case 'surface'
      if N < 3
         error('Input image should be at least 3D.');
      end
      out = newimar(N-1);
      switch N
         case 3
            sk=1;
            %3D code, fast eig analysis + 5d Knutsson mapping
            g = gradient(in ,sg);
            %G = smooth(g*g',st);
            G = newimar(3,3);
            G{1,1} = gaussf(g{1}*g{1},st);
            G{2,2} = gaussf(g{2}*g{2},st);
            G{3,3} = gaussf(g{3}*g{3},st);
            G{1,2} = gaussf(g{1}*g{2},st);
            G{1,3} = gaussf(g{1}*g{3},st);
            G{2,3} = gaussf(g{2}*g{3},st);
            clear g
            [v1 v2 v3]=dip_symmetriceigensystem3(G{1,1},G{1,2},G{1,3},G{2,2},...
               G{2,3},G{3,3},{'v1','v2','v3'});
            clear G
            T = newimar(5);%map normal vector
            T{1} = v1{1}^2-v1{2}^2;
            T{2} = 2*v1{1}*v1{2};
            T{3} = 2*v1{1}*v1{3};
            T{4} = 2*v1{2}*v1{3};
            T{5} =  1/sqrt(3)*(2*v1{3}^2-v1{1}^2-v1{2}^2);
            clear v1
            DM = newimar(5,3);
            for jj= 1:5
               DM{jj,1}=dx(T{jj},sk);
               DM{jj,2}=dy(T{jj},sk);
               DM{jj,3}=dz(T{jj},sk);
            end
            clear T
            out{1} = proj(DM,v2)*0.5;
            clear v2
            out{2} = proj(DM,v3)*0.5;
         otherwise
            %nD code
            G = gst_subsample(in,st,sg);
            [ew,l] = jacobi(G);
            clear G ew
            M=l{:,1}*l{:,1}';%surface normal
            DM = newimar(N*N,N);
            sigma = ones(N,1);
            order = zeros(N,1);
            for ii= 1:N*N
            for jj =1:N
               order(jj) = 1;
               DM{ii,jj} = derivative(M{ii},sigma,order);
               order(jj) = 0;
            end
            end
            clear M

            for ii=1:N-1
               out{ii} = proj(DM,l{:,ii+1}).*(1/sqrt(2));
            end
         end
      otherwise
         error('Unkown option.');
end

function out = proj(m,v)
% compute norm(m*v) memory efficient
out = newim(v{1});
for ii=1:size(m,1)
   tmp = newim(v{1});
   for jj=1:length(v)
      tmp = tmp + m{ii,jj}*v{jj};
   end
   out = out + tmp.^2;
   clear tmp
end
out = sqrt(out);
