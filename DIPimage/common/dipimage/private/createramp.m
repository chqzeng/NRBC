%OUT = CREATERAMP(SZ,DIM,ORIGIN)
%    Basis function for XX, YY, ZZ, RR, PHIPHI, and RAMP.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2001.
% 26 April 2001:   Added 'frequency' option.
% 8 November 2001: Removed 'frequency' option, and replaced it by
%                  'freq' and 'radfreq'. (MvG)
% 27 April 2002:   Added 'mleft', 'mright', etc... (MvG)
% 14 August 2008:  Fixed error message when sz(dim)==1.
% 20 August 2009:  More elegant SWITCH statement, easier to maintain.
% 2  August 2012:  fixed typo in switch (BR)

function out = createramp(sz,dim,origin)

if nargin ~= 3
   error('Wrong input.')
end

if isempty(origin)
   origin = 'right'; % like DIPlib's FFT.
elseif strcmpi(origin,'math')
   origin = 'mright';
end

if origin(1) == 'm' & dim ~= 2
   % >= 'mleft'->'left' etc, if not along Y-axis...
   origin = origin(2:end);
end

if isempty(sz) | prod(sz) == 0
   out = dip_image([],'single');
else
   if length(sz)>=dim & sz(dim)>1
      x = sz(dim)-1;
      switch origin
         case 'left' % To the left
            x = -floor(x/2):floor((x+1)/2);
         case 'right' % To the right
            x = -floor((x+1)/2):floor(x/2);
         case 'true' % Use floating point values
            x = -x/2:x/2;
         case 'corner' % First pixel
            x = 0:x;
         case 'freq' % Use true frequency domain coordinates
            q = floor((x+1)/2);
            x = -q:floor(x/2); % (zero to the right of the center)
            if q~=0
               x = x*(0.5/q);
            end
         case 'radfreq' % Use radial frequency domain coordinates
            q = floor((x+1)/2);
            x = -q:floor(x/2); % (zero to the right of the center)
            if q~=0
               x = x*(pi/q);
            end
         case 'mleft' % To the left
            x = -(-floor(x/2):floor((x+1)/2));
         case 'mright' % To the right
            x = -(-floor((x+1)/2):floor(x/2));
         case 'mtrue' % Use floating point values
            x = -(-x/2:x/2);
         case 'mcorner' % First pixel
            x = x:-1:0;
         case 'mfreq' % Use true frequency domain coordinates
            q = floor((x+1)/2);
            x = -(-q:floor(x/2)); % (zero to the right of the center)
            if q~=0
               x = x*(0.5/q);
            end
         case {'mradfrq','mradfreq'} % Use radial frequency domain coordinates
            q = floor((x+1)/2);
            x = -(-q:floor(x/2)); % (zero to the right of the center)
            if q~=0
               x = x*(pi/q);
            end
         otherwise
            error('Illegal ORIGIN option.')
      end
      sz(dim) = 1;
      xsz = ones(size(sz));
      xsz(dim) = length(x);
      x = dip_image(x,'single');
      x = reshape(x,xsz);
   else
      x = dip_image(0,'single');
   end
   out = repmat(x,sz);
end
