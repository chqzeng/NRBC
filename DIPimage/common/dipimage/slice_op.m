%SLICE_OP   Apply a function to all slices in the last image dimension
%
%  With this function handling operation on time series
%  become much easier, where the operation should only be done
%  per time slice.
%
%  SYNOPSIS:
%   image_out = slice_op('function',image_in, par1, par2,...)
%
%  EXAMPLE:
%   a = threshold(readim('chromo3d'));
%   b = slice_op('bdilation',a,5,-1,0);
%
%  NOTE:
%   This function is useful for operations that intrinsically do
%   not allow a no-op along one dimension, such as BDILATION in the
%   example above. It might also speed up calls to certain functions
%   that do allow operation along selected dimensions but are not
%   separable, such as DILATION with an elliptic structuring element.
%
%  NOTE:
%   This functionality can be done faster by using IM2ARRAY,
%   ITERATE and ARRAY2IM. However, that solution uses a lot more
%   memory:
%      b = im2array(a);
%      b = iterate('bdilation',b,5,-1,0);
%      b = array2im(b);
%
%  NOTE:
%   When using the MATLAB Compiler, make sure to add a %#function
%   pragma to register the function being called by SLICE_OP:
%      %#function bdilation
%      b = slice_op('bdilation',a,5,-1,0);
%
%  SEE ALSO:
%   iterate, imarfun, slice_ex, slice_in, im2array, array2im.

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Aug 2001
% January 2004:   Fixed to allow for functions that return data of different
%                 size and/or dimensionality (must be less, though!). (CL)
% 7 October 2010: Moved out of @dip_image directory. (CL)

function out = slice_op(oper,in,varargin)

% Avoid being in menu
if nargin == 1 & ischar(oper) & strcmp(oper,'DIP_GetParamList')
   out = struct('menu','none');
   return
end
if nargin<2
   error('Wrong input to SLICE_OP.')
end

in = dip_image(in);
sz = imsize(in);
di = length(sz);
N = sz(di);
si = repmat({':'},1,di-1);

%set output type
tmp = dip_image(feval(oper,squeeze(in(si{:},0)),varargin{:}));
osz = imsize(tmp);
sz(1:di-1) = 1;
sz(1:length(osz)) = osz(:);
out = dip_image('zeros',sz,datatype(tmp));
out(si{:},0) = tmp;

for ii = 1:N-1
   tmp = dip_image(feval(oper,squeeze(in(si{:},ii)),varargin{:}));
   out(si{:},ii) = tmp;
end
