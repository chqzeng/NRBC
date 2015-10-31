%MAPPG   maximum a-posteriori probablity restoration
%        for poisson statistics and Gaussian prior
%
% SYNOPSIS:
%  image_out = mappg(image_in, psf, estimation, const_bg, reg_param, numb_iter, stopcrit)
%
% PARMETERS:
%  estimation: inital guess
%  cons_bg:    background offset
%  reg_param:  regularization parameters
%  numb_iter:  Number of iterations
%  stopcrit:   stop if relative change in image_out is smaller than this
%
% DEFAULTS:
%  estimation: input image
%  cons_bg:    minimum of the input image
%  reg_param:  autmatically computed
%  numb_iter:  100
%  stopcrit:   1e-5
%
% SEE ALSO:
%  tikhonovmiller, wiener
%
% LITERATURE:
%  P.J. Verveer, T.M. Jovin, Efficient Superrsolution Restoration Algorithms using
%  Maximum a Posteriori estimations with applications to fluorescent microscopy,
%  Journal of the Optical Society of America A 14:1696-1706, 1997

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bart Vermolen & Bernd Rieger Oct 2007

function out = mappg(varargin)

d = struct('menu','Restoration',...
           'display','MAP restoration',...
           'inparams',struct('name',       {'in','h','est','constBack','rp','numbIter','stop_eps'},...
          'description',{'3D image','PSF','Inital estimation image','background constant',...
            'Regularization parameter','Number of Iterations', 'Stop criteria'},...
          'type',       {'image','image','image','array','array','array','array'},...
          'dim_check',  {0,0,0,0,0,0,0},...
          'range_check',{[],[],[],'R+','R+','N+','R+'},...
          'required',   {1,1,0,0,0,0,0},...
          'default',    {'in','psf','[]',0,0,100,1e-5}...
         ),...
           'outparams',struct('name',{'out'},...
                              'description',{'Restorated image'},...
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
   [in,h,est,constBack,rp,numIter,stop_eps] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if nargin <3 | isempty(est)
   est = in;
end
if nargin <4
   constBack = min(in);
end
if nargin <5
   rp = find_lambda(in,h)/8;%factor 8 is magic
end

SN = 3;
alpha = 0.0;
beta = 0.0;
restart = 1;
rtr = 1.0;
% Calculate the first value of the I-diverence

est = abs(est);
e = est;
estBlurred = convolve(est,h);

if (constBack > 0.0)
   estBlurred = estBlurred + constBack;
end

est = sqrt(est);
tmp = e * e;
f1 = sum(tmp);
f2 = sum(estBlurred);
f3 = in * log(estBlurred);
f3 = sum(f3);
fu = f2 - f3 + rp * f1;
f0 = fu;
fp = fu;

% Iterations begin here

for ii = 1:1:numIter
   dBlurred = in / estBlurred;
   dBlurred = dBlurred - 1;

   if (rp > 0.0)
      dBlurred = convolve(dBlurred,h);
      e = dBlurred - 2 * rp * e;
   else
      e = convolve(dBlurred,h);
   end

   e = 2 * e * est;
   tmp = e * e;
   rr = sum(tmp);

   if (restart > 0)
      restart = 0;
      beta = 0.0;
      d = e;
   else
      beta = rr / rtr;
      d = beta * d + e;
   end

   rtr = rr;
   e = d * d;

   if (rp > 0.0)
      tmp = e * e;
      p = sum(tmp);
      tmp = e * est * est;
      r = sum(tmp);
      r = 6.0 * r;
      tmp = e * d * est;
      q = sum(tmp);
      q = 4.0 * q;
   end

   dBlurred = convolve(e,h);
   e = d * est;

   if (rp > 0.0)
      tmp = e * est * est;
      s = sum(tmp);
      s = 4.0 * s;
   end

   destBlurred = convolve(e,h);
   a= alpha;
   for jj=1:1:SN
      t1 = estBlurred + 2.0 * a * destBlurred + a * a * dBlurred;
      t2 = destBlurred + a * dBlurred;
      t3 = (1.0 - in / t1);
      f1 = 2.0 * t2 * t3;
      f2 = 2.0 * dBlurred * t3 + 4.0 * in * t2 * t2 / t1 / t1;
        f1 = sum(f1);
      f2 = sum(f2);
      if (rp > 0.0);
f1 = f1 + rp * (4.0 * p * a * a * a + 3.0 * q * a * a + 2.0 * r * a + s);
f2 = f2 + rp * (12.0 * p * a * a + 6.0 * q * a + 2.0 * r);
      end
      f1 = f1 / f2;
      a = a - f1;

      if (a < 0.0)
         a = -a;
      end

   end
   alpha = a;
   est = est + alpha * d;
   estBlurred = estBlurred + alpha * alpha * dBlurred;
   estBlurred = estBlurred + 2 * alpha * destBlurred;
   e = est * est;
   tmp = e * e;
   f1 = sum(tmp);
   f2 = sum(estBlurred);
   f3 = in * log(estBlurred);
   f3 = sum(f3);
   fu = f2 - f3 + rp * f1;
   if (fu > fp)
      restart = 1;
   end

   fp = (fp - fu) / abs(fu);
   if (abs(fp) < stop_eps)
        out = est * est;
      return;
   end
   fp = fu;
end
out = est * est;

