%VERTCAT   Overloaded operator for [a;b].
%   [A;B] joins two measurement objects with the same measurements,
%   on different label IDs. If some IDs are repeated, or if the
%   measurements don't match, an error is generated.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 29 October 2001:   Sorting meaurements in b to match a.
% 5 February 2002:   Measurement names are not case-sensitive any more.
% 18 December 2009:  Added 'axes' and 'units' elements.

function out = vertcat(varargin)
for ii=1:nargin
   if ~isa(varargin{ii},'dip_measurement')
      varargin{ii} = dip_measurement(varargin{ii});
   end
end
out = varargin{1};
N = length(out.names);
for ii=2:nargin
   % The IDs may not be repeated
   if ~isempty(intersect(out.id,varargin{ii}.id))
      error('Measurement objects contain repeated label IDs.')
   end
   % The measurements should be identical
   if length(intersect(lower(varargin{ii}.names),lower(out.names))) ~= N
      error('Measurement objects do not contain same measurements.')
   end
   I = 1:N;
   for jj=1:N
      %??? What happens here when there is more than one match? (which shouldn't happen, of course)
      I(jj) = find(strcmpi(out.names{jj},varargin{ii}.names));
   end
   varargin{ii}.names = varargin{ii}.names(I);
   % Keep data in same order as names!
   varargin{ii}.data = varargin{ii}.data(I);
   varargin{ii}.axes = varargin{ii}.axes(I);
   varargin{ii}.units = varargin{ii}.units(I);
   % Join
   out.id = [out.id,varargin{ii}.id];
   for jj=1:length(out.names)
      out.data{jj} = [out.data{jj},varargin{ii}.data{jj}];
      out.axes{jj} = [out.axes{jj},varargin{ii}.axes{jj}];
      out.units{jj} = [out.units{jj},varargin{ii}.units{jj}];
   end
end
