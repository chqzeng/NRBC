%HANDLE2STR   Convert single handle into evaluable string.
%   S = HANDLE2STR(H) returns a S such that H == EVAL(S), under the
%   following contraits:
%   - PROD(SIZE(H))==1
%   - ISHANDLE(H)==1

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 12 August 2014: Fix for new graphics in MATLAB 8.4 (R2014b).

function str = handle2str(h)

if prod(size(h))~=1 | ~ishandle(h)
   error('H is not a single handle.')
end

if matlabver_ge([8,4])
   error('This function is only useful in versions of MATLAB prior to R2014b (8.4).')
end

str = num2str(h,'%.16g');
