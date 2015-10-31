%SIZE   Returns the size of the measurement structure.
%   SIZE(MSR,1) returns the number of label IDs.
%   SIZE(MSR,2) returns the number of measurement values for each ID.
%   SIZE(MSR) returns the number of label IDs and the number of measurement
%   values for each ID as the first and second elements, respectively, of a
%   1-by-2 array.
%   [N,M] = SIZE(MSR) returns the same values separately in N and M.
%   SIZE(MSR,MSRNAME) returns the number of MSRNAME measurement values
%   for each ID. For example, SIZE(MSR,'center') returns 2 if MSR was
%   obtained on a 2D image.

% (C) Copyright 1999-2006               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 14 October 2005 - Improved help, reorganized code a tiny bit.

function varargout = size(in,dim)
if nargin == 1
   if nargout > 2
      error('Too many output arguments.');
   end
   sz = totalsize(in);
   varargout = cell(1,nargout);
   if nargout == 2
      varargout{1} = length(in.id);
      varargout{2} = totalsize(in);
   else
      varargout{1} = [length(in.id),totalsize(in)];
   end
else
   if nargout > 1
      error('Too many output arguments.');
   end
   if ischar(dim)
      I = find(strcmpi(dim,in.names));
      if isempty(I)
         error('Illegal measurement name');
      else
         varargout = {size(in.data{I(1)},1)};
      end
   elseif isnumeric(dim) & length(dim)==1
      if dim==1
         varargout = {length(in.id)};
      elseif dim==2
         varargout = {totalsize(in)};
      else
         error('Illegal dimension.')
      end
   else
      error('Illegal dimension.')
   end
end

function sz = totalsize(in);
sz = 0;
for ii=1:length(in.data)
   sz = sz+size(in.data{ii},1);
end
