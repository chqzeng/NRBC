%LOADOBJ   Converts dip_measurement objects loaded from a MAT-file.
%   Called by MATLAB for each dip_measurement object it loads.

% (C) Copyright 1999-2009, All rights reserved
% Cris Luengo, December 2009.

function obj = loadobj(obj)
if isa(obj,'dip_measurement')
   % The object we are trying to read in contains the same elements as the current
   % definition of the dip_measurement object.
elseif isa(obj,'struct')
   % This case happens when the dip_measurement class changes.
   % In December  2009 we added 'axes' and 'units' elements to the dip_measurement class.
   N = prod(size(obj.data));
   obj.axes = cell(1,N);
   obj.units = cell(1,N);
   for ii=1:N
      M = size(obj.data{ii},1);
      obj.axes{ii} = cell(M,1);
      obj.axes{ii}(:) = {''};
      obj.units{ii} = cell(M,1);
      obj.units{ii}(:) = {'unknown'};
   end
   obj = dip_measurement('trust_me',obj);
else
   % Can this happen???
   warning('This is a very weird dip_measure object you''re loading!')
   % This is the best I can do...
   obj = dip_measure(obj);
end
