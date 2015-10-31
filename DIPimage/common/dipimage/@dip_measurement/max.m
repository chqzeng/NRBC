%MAX   Finds the maximum value for each measurement.
%   MAX(MSR) returns a row vector with the maximum value for each
%   measurement, and is equivalent to MAX(DOUBLE(MSR)).
%
%   [Y,I] = MAX(MSR) also returns the object ID of the maximum values.
%   This is not the same as [Y,I] = MAX(DOUBLE(MSR)), because object
%   IDs do not have to be consecutive or sorted.
%
%   [Y,I] = MAX(MSR,MSRNAME) computes the maximum values only for
%   the given measurement.

% (C) Copyright 1999-2006               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, September 2006.

function [m,id] = max(in,dim)
if nargin==1
   values = double(in);
else
   if ischar(dim)
      I = find(strcmpi(dim,in.names));
      if isempty(I)
         error('Illegal measurement name');
      else
         values = in.data{I(1)}';
      end
   else
      error('Illegal measurement name');
   end
end
[m,I] = max(values);
if nargout>1
   id = in.id(I);
end
