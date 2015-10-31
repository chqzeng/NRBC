%CUT   Cuts/crops an image symmetrically around the center
%
% SYNOPSIS:
%  out = cut(in,newsize,origin)
%
% PARAMETERS:
%  in:       input image
%  newsize:  new image size
%  origin:   origin of crop region
%
% EXAMPLE:
%  a = readim;
%  b = extend(a,[500,500]);
%  c = cut(b,imsize(a));
%  a-c
%
% SEE ALSO:
%  extend

% (C) Copyright 2004-2010      Department of Molecular Biology
%     All rights reserved      Max-Planck-Institute for Biophysical Chemistry
%                              Am Fassberg 11, 37077 G"ottingen
%                              Germany
%
% Bernd Rieger, Sep 2004.
% 9 April 2007, Rewrote to use SUBSREF instead of EVAL. (CL)
% 21 July 2010, Keeping image origin in the correct place. (CL)
% 21 Sept 2010, No reason to not allow tensor images. Added ORIGIN. (CL)

function out = cut(varargin)
d = struct('menu','Manipulation',...
   'display','Cut (cropping)',...
   'inparams',struct('name', {'in','bor','orig'},...
         'description',{'Input image','New image size','Origin of crop region'},...
         'type',       {'image','array','array'},...
         'dim_check',  {0,1,{[],1}},...
         'range_check',{[],'N+','N'},...
         'required',   {1,1,0},...
         'default',    {'a','256',[]}...
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
   [in,bor,orig] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
sz = imsize(in);
N  = length(sz);

if isempty(orig)

   tmp = bor >= sz;
   bor(tmp) = sz(tmp);        % if newsize > oldsize do nothing
   if all(tmp)
      out = in;
      return;
   end

   start = (sz-bor)./2;       % start coord
   for ii=find(mod(start,1))
      if mod(sz(ii),2) % odd size input
         start(ii) = floor(start(ii));
      else             % even size input
         start(ii) = ceil(start(ii));
      end
   end
   stop  = start+bor-1;       % end coord

else

   if any(orig>=sz)
      error('Origin outside of image.')
      % orig >= 0 because of GETPARAMS check.
   end
   start = orig;              % start coord
   stop  = min(start+bor,sz);

   if all(start==0) & all(stop==sz)
      out = in;
      return;
   end
   
   stop = stop - 1;

end

s = substruct('()',{});
for ii = 1:N
   s.subs{ii} = start(ii):stop(ii);
end
out = subsref(in,s);

%%% TEST CODE:
% x = xx(4);
% y = extend(x,5);
% z = extend(x,6);
% if any(cut(y,4) - x), disp('Error!!!'), end
% if any(cut(z,4) - x), disp('Error!!!'), end
% 
% x = xx(3);
% y = extend(x,5);
% z = extend(x,6);
% if any(cut(y,3) - x), disp('Error!!!'), end
% if any(cut(z,3) - x), disp('Error!!!'), end
