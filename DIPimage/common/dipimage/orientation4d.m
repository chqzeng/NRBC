%ORIENTATION4D   Orientation estimation in 4D
% Estimates the orientation in 4D images for line-like structures
%
% SYNOPSIS:
%  out = orientation4d(in, sg, st)
%
%  sg: sigma of the derivative filter
%  st: sigma of the tensor smoothing
%  out: 4d tensor image, which elements are 4D images,
%      the first elements is the x component, ...
%      Out is subsampled by st. See below
%
% DEFAULTS:
%  sg = 1
%  st = [4 4 3 1]
%
% SEE ALSO: dip_image/eig
%
% NOTE: The function is memory optimaized. The computation
%       of the orientation is only possible if the smoothed
%       components of the GST are immediatily subsampled
%       by the factor of the tensor smoothing st.
%
% LITERATURE:
%    G.H. Golub, C.F. Van Loan, Matrix Computations, 1996,
%    John Hopkins University Press

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Nov 2002.
% Nov 2002, small change in GST computation (BR)
% Nov 2002, made GST computation a private subroutine (BR)

function out = orientation4d(varargin)
d = struct('menu','Analysis',...
   'display','Orientation 4D linear structures',...
   'inparams',struct('name',       {'in','sg','st'},...
       'description',{'Input image','Sigma of derivative','Tensor smoothing'},...
       'type',       {'image', 'array','array'},...
       'dim_check',  {0,1,1},...
       'range_check',{[],'R+','R+'},...
       'required',   {1,1,1},...
       'default',    {'a',1,[4 4 3 1]}...
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
   [in,sg,st] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end


if ndims(in) ~=4
   error('Gimme 4D data man.');
end
if ~isreal(in)
   error('Input must be real.');
end
if strcmp('datatype(in)','dfloat')
   in = dip_image(in,'sfloat');
   fpritnf('Converting to sfloat, keep it on the sane side of memory usage.');
end

MB  = prod(size(in))*4;
MB2 = 29*MB/prod(st)/2^20;
MB3 = MB*4/2^20;%gradient + one for subsample + one prod
fprintf(' Additional Memory needed: %4.1f MB\n',max(MB2,MB3));

%fprintf(' Computation of the 10 GST elements.\n');
% save memory by only computing 2 derivatives at a time
% have to do 9 convolutions instead of 4 therefore

G = gst_subsample(in,sg,st);

%fprintf(' Inverting the GST.\n');
%wonder over wonder, invers and det work
Gdet = G{1,4}.^2*G{2,3}.^2 - 2*G{1,3}*G{1,4}*G{2,3}*G{2,4} + ...
       G{1,3}.^2*G{2,4}.^2 - G{1,4}^2*G{2,2}*G{3,3} + ...
       2*G{1,2}*G{1,4}*G{2,4}*G{3,3} - G{1,1}*G{2,4}.^2*G{3,3}+ ...
       2*G{1,3}*G{1,4}*G{2,2}*G{3,4} - 2*G{1,2}*G{1,4}*G{2,3}*G{3,4} -...
       2*G{1,2}*G{1,3}*G{2,4}*G{3,4} + 2*G{1,1}*G{2,3}*G{2,4}*G{3,4} +...
       G{1,2}.^2*G{3,4}.^2 - G{1,1}*G{2,2}*G{3,4}.^2 -...
       G{1,3}.^2*G{2,2}*G{4,4} + 2*G{1,2}*G{1,3}*G{2,3}*G{4,4} - ...
       G{1,1}*G{2,3}.^2*G{4,4} - G{1,2}.^2*G{3,3}*G{4,4} +...
       G{1,1}*G{2,2}*G{3,3}*G{4,4};
Ginv = newimar(4,4);
Ginv{1,1} = -1*G{2,4}.^2*G{3,3} + 2*G{2,3}*G{2,4}*G{3,4} - ...
            G{2,2}*G{3,4}.^2 - G{2,3}.^2*G{4,4} + G{2,2}*G{3,3}*G{4,4};
Ginv{1,2} = G{1,4}*G{2,4}*G{3,3} - G{1,4}*G{2,3}*G{3,4} - ...
            G{1,3}*G{2,4}*G{3,4} + G{1,2}*G{3,4}.^2 + ...
            G{1,3}*G{2,3}*G{4,4} - G{1,2}*G{3,3}*G{4,4};
Ginv{1,3} = -1*G{1,4}*G{2,3}*G{2,4} + G{1,3}*G{2,4}.^2+ ...
            G{1,4}*G{2,2}*G{3,4} - G{1,2}*G{2,4}*G{3,4} - ...
            G{1,3}*G{2,2}*G{4,4} + G{1,2}*G{2,3}*G{4,4};
Ginv{1,4} = G{1,4}*G{2,3}.^2 - G{1,3}*G{2,3}*G{2,4} - ...
            G{1,4}*G{2,2}*G{3,3} + G{1,2}*G{2,4}*G{3,3} + ...
            G{1,3}*G{2,2}*G{3,4} - G{1,2}*G{2,3}*G{3,4};

Ginv{2,2} = -1*G{1,4}.^2*G{3,3} + 2*G{1,3}*G{1,4}*G{3,4} - ...
            G{1,1}*G{3,4}.^2 - G{1,3}.^2*G{4,4} + ...
            G{1,1}*G{3,3}*G{4,4};
Ginv{2,3} = G{1,4}.^2*G{2,3} - G{1,3}*G{1,4}*G{2,4} - ...
            G{1,2}*G{1,4}*G{3,4} + G{1,1}*G{2,4}*G{3,4} + ...
            G{1,2}*G{1,3}*G{4,4} - G{1,1}*G{2,3}*G{4,4};
Ginv{2,4} = -1*G{1,3}*G{1,4}*G{2,3} + G{1,3}.^2*G{2,4} + ...
            G{1,2}*G{1,4}*G{3,3} - G{1,1}*G{2,4}*G{3,3} -...
            G{1,2}*G{1,3}*G{3,4} + G{1,1}*G{2,3}*G{3,4};
Ginv{3,3} = -1*G{1,4}.^2*G{2,2} + 2*G{1,2}*G{1,4}*G{2,4} - ...
            G{1,1}*G{2,4}.^2 - G{1,2}.^2*G{4,4} + ...
            G{1,1}*G{2,2}*G{4,4};
Ginv{3,4} = G{1,3}*G{1,4}*G{2,2} - G{1,2}*G{1,4}*G{2,3} - ...
            G{1,2}*G{1,3}*G{2,4} + G{1,1}*G{2,3}*G{2,4} + ...
            G{1,2}.^2*G{3,4} - G{1,1}*G{2,2}*G{3,4};
Ginv{4,4} = -1*G{1,3}.^2*G{2,2} + 2*G{1,2}*G{1,3}*G{2,3} - ...
            G{1,1}*G{2,3}.^2 - G{1,2}.^2*G{3,3} +...
            G{1,1}*G{2,2}*G{3,3};

clear G
wa = warning;
warning('off');
for ii=1:4
   for jj=ii:4
      Ginv{ii,jj}=Ginv{ii,jj}./Gdet;
   end
end


%fprintf(' Largest eigenvalue by power method\n');
%make initial vector for iteration q=(1,1,1...1)

q = newimar(4);
q{1} = newim(Ginv{1,1})+1;
for ii=2:4
   q{ii} = q{1};
end


tmp = q;
for ii=1:8
%magic parameter when to halt the iteration process, works fine
   tmp{1} = Ginv{1,1}*q{1}+Ginv{1,2}*q{2}+Ginv{1,3}*q{3}+Ginv{1,4}*q{4};
   tmp{2} = Ginv{1,2}*q{1}+Ginv{2,2}*q{2}+Ginv{2,3}*q{3}+Ginv{2,4}*q{4};
   tmp{3} = Ginv{1,3}*q{1}+Ginv{2,3}*q{2}+Ginv{3,3}*q{3}+Ginv{3,4}*q{4};
   tmp{4} = Ginv{1,4}*q{1}+Ginv{2,4}*q{2}+Ginv{3,4}*q{3}+Ginv{4,4}*q{4};
   q = tmp./norm(tmp);
end
%l = q'*(A*q);%eigen value
warning(wa);
out = q;

if 0
   a=newim([128 128 64 21]);
   b=newim([size(a,1) size(a,2) size(a,3)]);
   for ii=1:size(a,4)
      a(:,:,:,ii-1)=gaussianblob(b,[64 64+ii 32],2,255);
   end
   a = noise(a*255,'gaussian',5);
end

