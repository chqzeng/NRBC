%CONVOLVE   General convolution filter
%
% SYNOPSIS:
%  image_out = convolve(image_in,kernel)
%
%  If KERNEL is separable, the convolution is computed in the spatial
%  domain using NDIMS(IMAGE_IN) one-dimensional convolutions. If not,
%  the convolution is computed through the Fourier Domain. In either
%  case, the output is the same size as the input image

% (C) Copyright 1999-2014 by Lucas van Vliet, Bernd Rieger, Cris Luengo.
%
% Lucas van Vliet, May 2000.
% 24 October 2001: convolve(a,b) == convolve(b,a). (CL)
%                  Made dimensionality-independent. (CL)
% January 2006:    Output can be complex now. (BR)
% July 2009:       For real inputs the output is now forced to be real. (BR) 
% July 2010:       If the kernel is separable, don't use the FT. (CL)
%                  Cropping the output of the FT convolution to the input size. (CL)
% 26 June 2012:    Fixed bug with 1D image and filter. (CL)
% 14 October 2014: Made separability test a little bit more efficient. (CL)

function out = convolve(varargin)

d = struct('menu','Filters',...
           'display','General convolution',...
           'inparams',struct('name',       {'in',         'h'},...
                             'description',{'Input image','Kernel image'},...
                             'type',       {'image',      'image'},...
                             'dim_check',  {0,            0},...
                             'range_check',{[],           []},...
                             'required',   {1,            1},...
                             'default',    {'a',          'b'}...
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
   [in,h] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

nd = ndims(in);
if nd < ndims(h)
   error('Dimensionalities do not match')
else
   h = expanddim(h,nd);
end

separable = 0;
if isreal(h) % dip_separableconvolution() doesn't do complex filters...
   if nd<2
      h1 = {double(h)};
      separable = 1;
   else
      try
         h1 = decompose_kernel(dip_array(h)); % ... even though decompose_kernel() does!
         separable = 1;
      end
   end
end


if separable
   ps = ones(1,nd);
   f = struct('filter',h1);
   if nd>=2
      f = f([2,1,3:end]); % DIPimage ordering
   end
   for ii=1:length(f)   
      if length(f(ii).filter)==1
         ps(ii) = 0;
      end
   end
   if isreal(in)
      out = dip_separableconvolution(in,f,ps);
   else
      out = dip_separableconvolution(imag(in),f,ps);
      out = complex(dip_separableconvolution(real(in),f,ps),out);
   end
else
   insz = size(in);
   hsz = size(h);
   if insz ~= hsz
      sz = max(insz,hsz);
      in = extend(in,sz);
      h = extend(h,sz);
   end
   out = dip_convolveft(in,h,'spatial','spatial','spatial');
   if isreal(in) & isreal(h)
      out = real(out); % return real, throw away the small round-off erros
   end
   out = cut(out,insz);
end


function h1 = decompose_kernel(h)
n = ndims(h);
h1 = cell(1,n);
s = size(h);
for ii=n:-1:3
   h = reshape(h,[],s(end));       % collapse all dims except last one
   [h,h1{ii}] = decompose_2D(h);
   s = s(1:end-1);
   h = reshape(h,s);               % restore original shape with 1 fewer dim
   h1{ii} = shiftdim(h1{ii},2-ii); % the 1D kernel must be in the right shape
end
[h1{1},h1{2}] = decompose_2D(h);
h1{1} = double(h1{1});

function [h1,h2] = decompose_2D(h)
% This is very similar to the code in the FILTER2
% function in the standard MATLAB toolbox.
[ms,ns] = size(h);
if (ms == 1)
   h1 = 1;
   h2 = double(h);
elseif (ns == 1)
   h1 = h;
   h2 = 1;
else
   separable = false;
   if all(isfinite(h(:)))
      % Check rank (separability) of kernel
      [u,s,v] = svd(h);
      %s = diag(s);
      %tol = length(h) * eps(max(s));
      %rank = sum(s > tol);   
      %separable = rank==1;
      tol = length(h) * eps(s(1,1));
      separable = s(2,2) < tol;
   end
   if ~separable
      error('Sorry, kernel is not separable.');
   end
   h1 = u(:,1)*s(1,1);
   h2 = v(:,1)';
   % Try to normalize h2 -- this is totally unneeded, but kinda cool
   k = sum(h2);
   tol = length(h2)*eps(max(abs(h2)));
   if abs(k) <= tol
      k = sum(abs(h2));  % normalization for zero-sum kernel
      if abs(k) <= tol
         k = 1;          % weird?
      end
   end
   h2 = double(h2/k);
   h1 = h1*k;
end
