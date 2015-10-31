%CELL2STR   Convert cell array into evaluable string.
%   B = CELL2STR(C) returns a B such that C = EVAL(B), under the
%   following contraits:
%   - C is composed of numeric arrays or strings.
%   - All of the elements of C are of the same type.
%   - C is a row vector, that is, SIZE(C,1) == 1 and NDIMS(C) = 2.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 12 July 2005 - Fixed output for empty cell array

function str = cell2str(c)

if ~iscell(c)

   if ischar(c)
      str = ['''',c,''''];
   elseif isnumeric(c)
      str = mat2str(c);
   else
      error('Illegal array in input.')
   end

else

   N = length(c);
   if N > 0
      if ischar(c{1})
         str = ['{''',c{1},''''];
         for ii=2:N
            if ~ischar(c{ii})
               error('Inconsistent cell array.');
            end
            str = [str,',''',c{ii},''''];
         end
         str = [str,'}'];
      elseif isnumeric(c{1})
         str = ['{',mat2str(c{1})];
         for ii=2:N
            if ~isnumeric(c{ii})
               error('Inconsistent cell array.');
            end
            str = [str,',',mat2str(c{ii})];
         end
         str = [str,'}'];
      end
   else
      str = '{}';
   end

end
