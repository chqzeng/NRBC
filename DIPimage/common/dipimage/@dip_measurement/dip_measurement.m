%DIP_MEASUREMENT   Constructor method.
%   DIP_MEASUREMENT(B) converts the array or structure B to a
%   dip_measurement object.
%
%   If B is a struct, it must have this form:
%      B(ii).id       = Label (numeric) for object ii.
%      B(ii).msrname1 = Result of measurement 1 on object ii.
%      B(ii).msrname2 = Result of measurement 2 on object ii.
%      B(ii).msrname3 = ...
%          ...
%   If 'id' is missing, 1:N is assumed.
%
%   DIP_MEASUREMENT(ID,'MSRNAME1',MSR1,'MSRNAME2',MSR2,...)
%   creates a dip_measurement structure containing the id's in
%   ID, and the measurements 'MSRNAME1', 'MSRNAME2', etc. with
%   associated data MSR1, MSR2, etc. If the measurement names
%   are missing, 'data1', 'data2', etc. are assumed. If ID is
%   missing, 1:N is assumed, but only if a measurement name
%   is the first parameter (else there is no way of knowing
%   what the first parameter is). Finally, ID, MSR1, MSR2, etc.
%   must have the same number of columns; a column is a vector
%   representing the measurement result on one object.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 26 March 2001:     Added multiple-parameter input modes.
% 21 April 2001:     Fixed inconsistency: 'data' and 'names' now always
%                    are row cell arrays.
% 5 February 2002:   Measurement names are not case-sensitive any more.
% 13 February 2002:  Improved creation of dip_measurement objects by
%                    the dip_measure function.
% 18 December 2009:  Added 'axes' and 'units' elements.
% 29 April 2014:     Fixed wrong in 'axes' and 'units' element when creating
%                    an object from a numeric array.


% Undocumented syntax (used by dip_measure):
%    DIP_MEASUREMENT('TRUST_ME',B) converts the struct B to a
%    dip_measurement object. No conversion is done, but some
%    checking is. B must be in the form of a dip_meas object:
%
% dip_measurement objects contain these elements:             size:
% 'id'        Array with the object IDs.                      (1,L)
% 'data'      Cell array with the data arrays.                (1,N)with(M,L)
% 'names'     Cell array with the names for the measurements. (1,N)
% 'axes'      Cell array with cell arrays with names.         (1,N)with(M,1)
% 'units'     Cell array with cell arrays with units.         (1,N)with(M,1)
%
% L: number of objects
% N: number of measurements
% M: number of values for a specific measurement
%
%    ID     names{1}     names{1}     names{2}
%           axes{1}{1}   axes{1}{2}   axes{2}{1}
%           units{1}{1}  units{1}{2}  units{2}{1}
% --------------------------------------------------
%    id(1)  data{1}(1,1) data{1}(2,1) data{2}(1,1)
%    id{2}  data{1}(1,2) data{1}(2,2) data{2}(1,2)
%    id{3}  data{1}(1,3) data{1}(2,3) data{2}(1,3)
%
% How would we obtain these new elements from outside the object?
% For the moment, this data is only for display.


function out = dip_measurement(varargin)
data = struct('id',[],'data',[],'names',[],'axes',[],'units',[]);
data.data = cell(0);
data.names = cell(0);
data.axes = cell(0);
data.units = cell(0);
if nargin == 1
   in = varargin{1};
   if isa(in,'dip_measurement')
      out = in;
      return
   elseif isa(in,'struct')
      % Backwards-compatability: measurement structure
      % (resulting from the STRUCT function)
      in = in(:);
      if length(in)<1
         error('Illegal input.')
      end
      data.names = fieldnames(in)';
      N = length(data.names);
      I = strcmpi(data.names,'ID');
      if ~any(I)
         data.id = 1:length(in);
      else
         I = find(I); I = I(1);
         data.id = eval(['[in.',data.names{I},']']);
         if length(data.id) ~= length(in) | length(unique(data.id)) ~= length(data.id)
            error('Object ID array in input structure is not OK.')
         end
         N = N-1;
         data.names(I) = [];
      end
      if N<1
         error('Illegal input.')
      end
      data.data = cell(1,N);
      data.axes = cell(1,N);
      data.units = cell(1,N);
      for ii=1:N
         data.data{ii} = full(double(eval(['[in.',data.names{ii},']'])));
         M = size(data.data{ii},1);
         data.axes{ii} = cell(M,1);
         for jj=1:M
            data.axes{ii}{jj} = sprintf('%s%d',data.names{ii},jj);
         end
         data.units{ii} = cell(M,1);
         data.units{ii}(:) = {'unknown'};
      end
   elseif isnumeric(in)
      if isempty(in) | ~isnumeric(in) | ndims(in)~=2
         error('Illegal input.')
      else
         [M,L] = size(in);
         data.data = {full(double(in))};
         data.id = 1:L;
         data.names = {'data'};
         data.axes = {cell(M,1)};
         for jj=1:M
            data.axes{1}{jj} = sprintf('data%d',jj);
         end
         data.units = {cell(M,1)};
         data.units{1}(:) = {'unknown'};
      end
   else
      error(['Conversion to dip_measurement from ',class(in),' is not possible.'])
   end
elseif nargin > 1
   if nargin == 2 & ischar(varargin{1}) & strcmpi(varargin{1},'trust_me')
      % Undocumented feature: used by dip_measure
      data = varargin{2};
      if ~isstruct(data) | length(data)~=1
         error('Creating dip_measurement object: Expected structure as input.')
      end
      if ~isequal(fieldnames(data),{'id';'data';'names';'axes';'units'})
         error('Creating dip_measurement object: Received illegal structure as input (1).')
      end
      N = prod(size(data.data));
      if prod(size(data.names)) ~= N | prod(size(data.axes)) ~= N | prod(size(data.units)) ~= N
         error('Creating dip_measurement object: Received illegal structure as input (2).')
      end
      L = prod(size(data.id));
      for ii=1:N
         if size(data.data{ii},2) ~= L
            error('Creating dip_measurement object: Received illegal structure as input (3).')
         end
         M = size(data.data{ii},1);
         if size(data.axes{ii},1) ~= M | size(data.units{ii},1) ~= M
            error('Creating dip_measurement object: Received illegal structure as input (4).')
         end
      end
   else
      % Advanced syntax!
      if ~ischar(varargin{1})
         jj = 2;
         if ~isnumeric(varargin{1})
            error('Expected numeric data in argument 1.');
         end
         L = prod(size(varargin{1}));
         data.id = reshape(varargin{1},1,L);
      else
         jj = 1;
         data.id = [];
         L = 0;
      end
      ii = 1;
      while jj<=nargin
         if ischar(varargin{jj})
            data.names{ii} = varargin{jj};
            jj = jj+1;
         else
            data.names{ii} = ['data',num2str(ii)];
         end
         if any(strcmpi(data.names{ii},data.names(1:ii-1)))
            error('Repeated names for measurements.');
         end
         if jj>nargin
            error('Unexpected end of parameter list.');
         end
         if ~isnumeric(varargin{jj})
            error(['Expected numeric data in argument ',num2str(jj),'.']);
         else
            data.data{ii} =  full(double(varargin{jj}));
            if L == 0
               L = size(data.data{ii},2);
               data.id = 1:L;
            else
               if L ~= size(data.data{ii},2)
                  error(['Wrong number of data points in in argument ',num2str(jj),'.']);
               end
            end
            M = size(data.data{ii},1);
            data.axes{ii} = cell(M,1);
            data.axes{ii}(:) = {''};
            data.units{ii} = cell(M,1);
            data.units{ii}(:) = {'unknown'};
         end
         ii = ii+1;
         jj = jj+1;
      end
   end
else
   % Create empty object.
end
out = class(data,'dip_measurement');
