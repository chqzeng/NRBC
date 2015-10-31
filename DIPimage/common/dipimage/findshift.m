%FINDSHIFT  Finds shift between two images
%
% SYNOPSIS:
%  shiftvector = findshift(in1, in2, method, parameter, maxshift)
%
% PARAMETERS:
%  method = 'integer': find integer shift only (nD)
%           'ffts'   : normalized cross-correlation (2D only)
%           'grs'    : gradient based (first order Taylor, 1D-3D)
%           'iter'   : very accurate (iterative 'grs', 1D-3D)
%           'proj'   : fast, good for high SNR ('iter' on projections, nD)
%           All 'ffts','grs','iter','proj' first correct for the integer shift.
%  para = scalar parameter:
%           for 'integer': ignored
%           for 'ffts'   : Sets the amount of frequencies used in this estimation.
%                          The maximum value that makes sense is sqrt(1/2). Choose
%                          smaller values to ignore more high frequencies. The
%                          default value is 0.2.
%           for 'grs','iter','proj': Sigma for the Gaussian smoothing. Defaults to 1.
%  maxshift = array, for the integer shift estimation only shifts up to this range 
%             are considered. Values can be larger when using subpixel refinement. 
%             Useful for periodic structures
%
% DEFAULTS:
%  method = 'integer'
%  parameter = 0 (meaning use the default value for the method)
%  maxshift: 0 (meaning no range limitation)
%
% EXAMPLE:
%  a = readim;
%  b = shift(a,[-1.4 3.75]);
%  sv1 = findshift(a,b)
%  sv2 = findshift(a,b,'iter')
%  sb = shift(b,sv2);
%  joinchannels('RGB',a,b)
%  joinchannels('RGB',a,sb)
%
% LITERATURE:
%   T.Q. Pham, M. Bezuijen, L.J. van Vliet, K. Schutte, and C.L. Luengo Hendriks,
%   Performance of optimal registration estimators, in: Z. Rahman, R.A. Schowengerdt,
%   S.E. Reichenbach (eds.), Visual Information Processing XIV (Orlando, USA),
%   Proc. SPIE, vol. 5817, 2005, p.133-144.

% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2002.
% 16 April 2004: added some comments to the help. (CL)
% 12 July 2004: added method 'iter' and 'proj'. (TP)
% 26 July 2004: added example to help file (BR)
% 09 January 2007: added maximum shift (BR)
% 27 September 2010: Rewritten to use SUBSREF instead of EVAL. (CL)
% 16 February 2011: Limited max shift (BR)

function out = findshift(varargin)

d = struct('menu','Analysis',...
  'display','Find shift',...
  'inparams',struct('name',{'in1', 'in2',  'method','para','ms'},...
       'description',{'Input image 1','Input image 2','Method','Parameter','Maximum shift'},...
       'type',       {'image','image','option', 'array','array'},...
       'dim_check',  {0,0,0,0,1},...
       'range_check',{[],[],{'integer','ffts','grs','iter','proj'},'R','N'},...
       'required',   {1,1,0,0,0},...
       'default',    {'a', 'b','integer',0,0}...
      ),...
  'outparams',struct('name',{'out'},...
      'description',{'Shift'},...
      'type',{'array'}...
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
   [in1,in2, method, para,ms] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if all(ms==0)
   mask = [];
else
   % generate mask image with 1 around image center for nD case
   sz = ceil(imsize(in1)./2);
   sz1 = sz-1;
   ms(ms>sz1) = sz1(ms>sz1); %limit the max shift to the image size
   nd = length(sz);
   mask = newim(in1,'bin');
   ss = substruct('()',cell(1,nd));
   for ii=1:nd
      ss.subs{ii} = sz(ii)-ms(ii):sz(ii)+ms(ii);
   end
   mask = subsasgn(mask,ss,1);
end

out = dip_findshift(in1,in2,method,para,mask);
