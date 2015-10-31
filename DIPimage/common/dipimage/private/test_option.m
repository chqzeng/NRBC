%TEST_OPTION   Test the option parameter.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, 16 September 2007.
% Code extracted from GETPARAMS.M, and is now shared between various PARAMTYPE... functions.
% 20 August 2009: Outputting VALUE parameter with identical case as in RANGE_CHECK.

function [msg,value] = test_option(value,range_check)
msg = [];
if isstruct(range_check)
   options = {range_check.name};
else
   options = range_check;
end
if ischar(options{1})
   if ischar(value)
      N = find(strcmpi(options,value));
   else
      msg = 'string expected';
      return
   end
else
   if ~ischar(value)
      N = find([options{:}] == value);
   else
      msg = 'number expected';
      return
   end
end
if isempty(N)
   msg = 'option not in list';
   return
end
if ischar(options{1})
   value = options{N}; % update VALUE with string in OPTIONS array, in case they differ in case.
end
