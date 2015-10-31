% FORMATVALUE   Substitute for NUM2STR or SPRINTF
%    STR = FORMATVALUE(P) writes the numeric scalar P to the string STR.
%    Exponents won't have all these zeros in them.
%
%       num2str(1e6,'%.4g') -> '1e+006'
%
%       formatvalue(1e6)    -> '1e6'

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, September 2001.
% 3 October 2001: Correctly printing NaN and Inf.

function str = formatvalue(p)
if ~isnumeric(p) | prod(size(p))~=1
   error('Expected numeric argument.')
end
if isreal(p)
   str = formatrealvalue(p);
else
   if imag(p)>=0
      str = [formatrealvalue(real(p)),'+',formatrealvalue(imag(p)),'i'];
   else
      str = [formatrealvalue(real(p)),formatrealvalue(imag(p)),'i']; % '-' added automatically.
   end
end

function str = formatrealvalue(p)
if p==0
   str = '0';
elseif isinf(p)
   if p<0
      str = '-Inf';
   else
      str = 'Inf';
   end
elseif isnan(p)
   str = 'NaN';
else
   N = log10(abs(p));
   N = floor(round(N*4)/4); % LOG10 is not accurate enough: log10(1e6)<6 !
   nd = 4; % number of decimal digits (there are always nd+1 significant digits).
   if N < -2
      p = p/(10^N);
   elseif N > 3
      p = p/(10^N);
   else
      nd = nd-N;
      N = 0;
   end
   if p==fix(p)
      str = sprintf('%d',p);
   else
      fmt = sprintf('%%.%df',nd);
      str = sprintf(fmt,p);
      %str = sprintf(['%.',num2str(nd),'f'],p);
      % remove trailing zeros
      I = find(str~='0'); I = I(end);
      if str(I)=='.'
         I = I-1;
      end
      str = str(1:I);
   end
   if N
      str = [str,'e',sprintf('%d',N)];
   end
end
