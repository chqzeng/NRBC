%HORZCAT   Overloaded operator for [a b] or [a,b].
%   [A,B] joins two measurement objects with the same label IDs,
%   but different measurements. If some measurements are repeated,
%   or if the label IDs don't match, an error is generated.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 21 April 2001:     Fixed inconsistency: 'data' and 'names' now always
%                    are row cell arrays.
% 5 February 2002:   Measurement names are not case-sensitive any more.
% 18 December 2009:  Added 'axes' and 'units' elements.

function out = horzcat(varargin)
for ii=1:nargin
   if ~isa(varargin{ii},'dip_measurement')
      varargin{ii} = dip_measurement(varargin{ii});
   end
end
% We sort the indices of all the measurement structures,
% so that they will overlap.
out = varargin{1};
[out.id,I] = sort(out.id);
for jj=1:length(out.data)
   out.data{jj} = out.data{jj}(:,I);
end
for ii=2:nargin
   % The names may not be repeated
   if ~isempty(intersect(lower(out.names),lower(varargin{ii}.names)))
      error('Measurement objects contain repeated measurements.')
   end
   % The IDs should be identical
   [varargin{ii}.id,I] = sort(varargin{ii}.id);
   if ~isequal(out.id,varargin{ii}.id)
      error('Measurement objects do not contain same label IDs.')
   end
   % Keep data in same order as IDs!
   for jj=1:length(varargin{ii}.data)
      varargin{ii}.data{jj} = varargin{ii}.data{jj}(:,I);
   end
   % Join
   out.names = [out.names,varargin{ii}.names];
   out.data = [out.data,varargin{ii}.data];
   out.axes = [out.axes,varargin{ii}.axes];
   out.units = [out.units,varargin{ii}.units];
end
