%AFM_FLATTEN  Subtract background and artifacts from AFM/SPM images
%
% SYNOPSIS:
%  [out, off, backplane, seg] = afm_flatten(image_in, stripping, overlay, bp_order1, bp_order2, method)
%
% PARAMETERS:
%  stripping: remove the stripping due to scanning?
%  overlay:   overlay the found background with the input?
%  backplane order1: order of the backplane polynomial to fit initally
%                    higher orders do not improve generally
%  backplane order2: order of the backplane polynomial to fit on the background only
%  method:           how to solve the polynomial fit: 'svd','partitioning'
%
% DEFAULTS:
%  stripping:        0
%  overlay:          0
%  backplane order1: [2 2]
%  backplane order2: [2 2]
%  method:           'partitioning'
%
% LITERATURE:
%  J.P.P. Starink and T.M. Jovin,
%  Background correction in scanning probe microscope recordings of macromolecules,
%  Surface Science, 359:291-305, 1996.

% (C) Copyright 1999-2006               Quantitative Imaging Group
%     All rights reserved               Faculty of Applied Sciences
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger & Frank Faas, November 2006.
function varargout = afm_flatten(varargin)
d = struct('menu','Restoration',...
           'display','AFM flattening',...
           'inparams',struct('name',       {'in','rmst','ov','poly_p1','poly2_p2','method'},...
                             'description',{'Input image','Remove Stripping','Overlay with background','Polynomial order (initial)','Polynomial order (refinement)','Backplane fit method'},...
                             'type',       {'image','boolean','boolean','array','array','option'},...
                             'dim_check',  {0,0,0,1,1,0},...
                             'range_check',{[],[],[],'N+','N+',{'svd','partitioning'}},...
                             'required',   {1,0,0,0,0,0},...
                             'default',    {'a',0,0,[2 2],[2 2],'partitioning'}...
                            ),...
           'outparams',struct('name',{'in_flat','off','bg_plane','In_seg'},...
                              'description',{'Flattened image','Line offset','Backplane','Background mask'},...
                              'type',{'image','image','image','image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      varargout{1} = d;
      return
   end
end
try
   [in,rmst,ov,poly_p1, poly_p2, method] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if rmst
   %remove all horizontal stripping by cutting out the strip in FD
   %(is also done by the Nanoscope software)
   f=ft(in);
   d = size(f)./2;
   f(d(1),[0:d(2)-1, d(2)+1:end])=0;
   in = real(ift(f));
end

%in=readim('/home/rieger/matlab/Project/AFM_Starink/img4');
n=poly_p1(1);m=poly_p1(2);
Nparam = (n+1)*(m+1)-1;
N = size(in,1); % x,
M = size(in,2); % y, number of scan lines

A = gen_designmatrix([N M],[n m]);
[offset, backplane,a] = solve_designmatrix(A,flatten(in),[N M],[n m],method);
background = offset+backplane;
in_cor = in-(background);
bg_bin = in_cor<0;

%---------seems not to work better than the above in_cor<0---
% chapter 2.2 Background refinement
if 0
  %subtract mean per line (offset on the noise) based isodatathreshold
  in2 = medif(in_cor,3);
  off = zeros(size(in,1),2);
  mask = newim(in,'bin');
  for ii=0:size(in,1)-1
     tmp = squeeze(in2(:,ii));
     [tmpm,v] = threshold(tmp);
     tmpm = ~tmpm;
     off(ii+1,:)= [mean(tmp(tmpm)) var(tmp(tmpm))];
  end
  o2 = squeeze(off(:,1)) + sqrt(mean(squeeze(off(:,2))));
  offim = dip_image(repmat(o2,1,size(in,2)));
  bg_bin=in_cor<offim;
end

%--------refine fit on background only-----------
n2 = poly_p2(1);
m2 = poly_p2(2); %could use a higher order polynomial here according to Starink
Mask = flatten(bg_bin);
A = gen_designmatrix([N M],[n2 m2]);
A2 = A(find(Mask),:);
clear A
B = flatten(in);
B2 = B(find(Mask));clear B
[offset, backplane, a] = solve_designmatrix(A2,B2,[N M],[n2 m2],method);
background = offset+backplane;
varargout{1} = in-(background);

if ov
   overlay(in_cor,bg_bin)
end
if rmst
   tmp = medif(varargout{1},[0 3],'rectangular');
   varargout{1}(bg_bin) = tmp(bg_bin);
  %perpendicular to scan line median filtering
end

if nargout >1;varargout{2}=offset;end
if nargout >2;varargout{3}=backplane;end
if nargout >3;varargout{4}=bg_bin;end


%-------------------------------------------------------------------
function A = gen_designmatrix(S,s)
N = S(1);M = S(2);n = s(1);m = s(2);Nparam = (n+1)*(m+1)-1;
A = zeros(N*M,N+Nparam);
einser = ones(1,M);
st = 1;
for ii=1:N
   ed = st + M-1;
   %fprintf('ind %d:%d\n',st,ed);
   A(st:ed,Nparam+ii) = einser';
   st = ed +1;
end
x1 = reshape(repmat(0:N-1,[M,1]),[1 M*N]);
x2 = repmat(x1',1,Nparam);
y1 = repmat([0:M-1]',N,1);
y2 = repmat(y1,1,Nparam);
Ex = [1:n repmat(0:n,1,m) ];
Ex = repmat(Ex,N*M,1);
Ey = repmat(0,1,n);
for ii=1:m
   Ey = [Ey repmat(ii,1,n+1)];
end
Ey = repmat(Ey,N*M,1);
tmp = (x2.^Ex) .* (y2.^Ey);
A(:,1:Nparam) = tmp; %design matrix
clear tmp x1 x2 y1 y2 Ex Ey


function [offset, backplane, a] = solve_designmatrix(A,B,S,s,method)
N = S(1);M = S(2);n = s(1);m = s(2);Nparam = (n+1)*(m+1)-1;
switch method
   case 'svd'
     [U,W,V] = svd(A,'econ');
     clear A
     a = V*pinv(W)*U' *B; %coefficients
     clear U W V
   case 'partitioning'
     tmp = A'*A;
     sz=size(tmp);
     P = tmp( 1:(n+1)*(m+1)-1, 1:(n+1)*(m+1)-1);%square
     S = tmp( (n+1)*(m+1):end, (n+1)*(m+1):end); %should be size MxM
     Q = tmp( 1:(n+1)*(m+1)-1, (n+1)*(m+1):end);
     R = tmp( (n+1)*(m+1):end, 1:(n+1)*(m+1)-1);
     clear tmp

     Si = inv(S);clear S
     [U,W,V] = svd(P-Q*Si*R,'econ');
     tmp = V*pinv(W)*U';
     clear U V W
     Pt = tmp;
     Qt = -tmp*(Q*Si);
     Rt = -(Si*R)*tmp;
     St = Si + (Si*R)*tmp*(Q*Si);
     clear P Q R tmp

     tmp = zeros(sz);
     tmp(1:size(Pt,1), 1:size(Pt,2)) = Pt;
     tmp(1:size(Qt,1), size(Pt,2)+1:end) = Qt;
     tmp(size(Pt,1)+1:end, 1:size(Rt,2)) = Rt;
     tmp(size(Qt,1)+1:end, size(Rt,2)+1:end) = St;
     clear Pt St Qt Rt
     a = tmp*A'*B;
     clear A B tmp
   otherwise
      error('Unknown solving method.');
end
offset = a(Nparam+1:end);
offset = dip_image(repmat(offset,1,M));
x = xx([N M],'corner');
y = yy([N M],'corner');
if n==2 & m==2
   backplane = a(1)*y + a(2)*y.^2 + a(3)*x + a(4)*x*y +...
            a(5)*y.^2*x + a(6)*x.^2 + a(7)*y*x.^2 + a(8)*x.^2*y.^2;
else
   backplane = newim(x);
   for ii=1:n
      %fprintf('a(%d)=%d\n',ii,a(ii));
      backplane = backplane + a(ii)*y.^ii;
   end
   kk=n;
   for jj=1:m
      for ii=0:n
         kk=kk+1;
         %fprintf('a(%d)=%d, y^%d x^%d\n',kk,a(kk), ii,jj);
         backplane = backplane + a(kk)*y.^ii *x.^jj;
      end
   end
end




function out=flatten(in,mask);
if nargin ==2 & ~isempty(mask)
   if ~islogical(mask)
         error('Mask image must be binary')
   end
   N = sum(mask);
   out = double(reshape(in(mask),1,N));
else
   out = double(reshape(in,1,prod(size(in))));
end
