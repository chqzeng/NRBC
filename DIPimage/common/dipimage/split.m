%SPLIT Split an image into subsampled versions
%
% SYNOPSIS:
%  out = split(in, stepsize)
%
% PARAMETERS:
%  in:       input image
%  stepsize: integer number that divides the image without remainder
%
% SEE ALSO:
%  subsample

% (C) Copyright 1999-2008     Quantitative Imaging Group
%     All rights reserved     Department of Imaging Science and Technology
%                             Delft University of Technology
%                             Lorentzweg 1
%                             2628 CJ Delft
%                             The Netherlands
%
% Bernd Rieger & Lucas van Vliet, Aug 2008.

function out = split(varargin)
d = struct('menu','Manipulation',...
   'display','Split',...
   'inparams',struct('name', {'in','fac'},...
         'description',{'Input image','Step size'},...
         'type',       {'image','array'},...
         'dim_check',  {0,0},...
         'range_check',{[],'N+'},...
         'required',   {1,0},...
         'default',    {'a',2}...
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
   [in,fac] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
sz = size(in);
if any(rem(sz,fac))
   error('Split factor must divide image dimensions without remeinder.');
end

kk=0;
st = fac
sub = sz./st;
out = newim([sub, fac*fac], datatype(in));
for ii=1:fac
   ox=ii-1;
   for jj=1:fac
      oy=jj-1;
      %fprintf('ox %d, oy %d\n',ox,oy);
      [x,y]  = meshgrid(ox:st:sz(1)-1, oy:st:sz(2)-1);
      m = cat(2,x,y);
      m = reshape(m,numel(x),2);
      mask = coord2image(m,sz) ;
      tmp = permute(reshape(in(mask),sub(2),sub(1)),[2,1]);
      out(:,:,kk)= tmp;
      kk=kk+1;
   end
end
