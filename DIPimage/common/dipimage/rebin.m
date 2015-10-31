%REBIN   Rebinning of an image
%
% SYNOPSIS:
%  out = rebin(in, binning)
%
% PARAMETERS:
%  in:  input image
%  binning: integer numbers (array) that divides the image without remainder
%
% SEE ALSO:
%  resample, subsample

% (C) Copyright 1999-2010     Quantitative Imaging Group
%     All rights reserved     Department of Imaging Science and Technology
%                             Delft University of Technology
%                             Lorentzweg 1
%                             2628 CJ Delft
%                             The Netherlands
%
% Bernd Rieger, Feb 2007.
% 27 September 2010: Rewritten to use SUBSREF instead of EVAL. (CL)

function out = rebin(varargin)
d = struct('menu','Manipulation',...
   'display','Rebinning',...
   'inparams',struct('name', {'in','bin'},...
         'description',{'Input image','Binning'},...
         'type',       {'image','array'},...
         'dim_check',  {0,1},...
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
   [in,bin] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

szI = imsize(in);
if any(rem(szI,bin))
   error('Binning must be divider of all image dimensions.');
end
N = length(szI);
szI = szI-1;
for ii=1:N
   s = substruct('()',repmat({':'},[1,N]));
   s.subs{ii} = 0:bin(ii):szI(ii);
   out = subsref(in,s);
   for jj=1:bin(ii)-1
      s.subs{ii} = jj:bin(ii):szI(ii);
      out = out + subsref(in,s);
   end
   in = out;
end
