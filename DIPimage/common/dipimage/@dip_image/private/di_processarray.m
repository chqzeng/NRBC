%DI_PROCESSARRAY   Creates a process array.
%   P = DI_PROCESSARRAY(ND,DIM) returns an array P with ND
%   elements. P(DIM) is one. If DIM is ommitted, all elements of P
%   are one.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 18 January 2001: Removed IN parameter, added ND parameter. Changed
%                  all calls to this function accordingly.

function process = di_processarray(nd,d)
if nargin < 1
   error('Not enough input arguments.');
elseif nargin < 2
   process = ones(1,nd);
else
   if ~isnumeric(d) | isempty(d) | any(mod(d,1)) | any(d<1) | any(d>nd)
      error('Invalid dimension.')
   end
   process = zeros(1,nd);
   process(d) = 1;
end
