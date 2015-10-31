%PARAMTYPE_ANYTYPEARRAY   Called by PARAMTYPE.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, 25 April 2014.
% Copy of PARAMTYPE_ARRAY, but without the conversion to DOUBLE.

function varargout = paramtype_array(command,param,varargin)

switch command
   case 'control_create'
      fig = varargin{1};   % figure handle
      default = param.default;
      if ~ischar(default)
         if prod(size(default)) > 1
            default = mat2str(default);
         end
      end
      h = uicontrol(fig,...
                    'Style','edit',...
                    'String',default,...
                    'Visible','off',...
                    'HorizontalAlignment','left',...
                    'BackgroundColor',[1,1,1]);
      varargout{1} = h;
   case 'control_value'
      varargout{2} = get(varargin{1},'String');
      if isempty(varargout{2})
         varargout{2} = '[]';
      end
      varargout{1} = evalin('base',varargout{2});
      if ~isnumeric(varargout{1})
         varargout{1} = double(varargout{1});
      end
   case 'default_value'
      if ischar(param.default)
         try
            varargout{1} = evalin('base',param.default);
         catch
            error('Default array evaluation failed.')
         end
         if ~isnumeric(varargout{1})
            error('Default array evaluation failed.')
         end
      else
         varargout{1} = param.default;
      end
   case 'definition_test'
      varargout{1} = '';
      params = varargin{1};
      dim_check = dim_check_convert(param.dim_check);
      for ii=1:length(dim_check)
         if isempty(dim_check{ii})
            % OK!
         elseif sum(size(dim_check{ii})>1) > 1 | ~isnumeric(dim_check{ii}) | mod(dim_check{ii},1)
            varargout{1} = 'DIM_CHECK should be an integer vector';
         elseif length(dim_check{ii})==1
            if dim_check{ii} >= length(params) | dim_check{ii} < 1
               varargout{1} = 'DIM_CHECK points to a non-existent parameter';
            elseif ~strcmpi(params(dim_check{ii}).type,'image')
               varargout{1} = 'DIM_CHECK should point to an image parameter';
            end
         else
            if any(dim_check{ii}<1 & dim_check{ii}~=-1)
               varargout{1} = 'DIM_CHECK should be positive integers or -1';
            end
         end
         if ~isempty(varargout{1})
            return
         end
      end
      [range_check,force_int] = range_check_convert(param.range_check);
      if ischar(range_check)
         varargout{1} = 'illegal RANGE_CHECK';
      elseif (~isempty(range_check) & prod(size(range_check)) ~= 2) | ...
          ~isnumeric(range_check)
         varargout{1} = 'illegal RANGE_CHECK';
      elseif ~param.required
         if ~ischar(param.default)
            varargout{1} = paramtype_array('value_test',param,param.default);
            if ~isempty(varargout{1})
               varargout{1} = ['DEFAULT: ',varargout{1}];
            end
         end
      end
   case 'value_test'
      varargout{1} = '';
      varargout{2} = [];
      value = varargin{1};
      if nargout>1
         outargs = varargin{2};
      else
         outargs = [];
      end
      % Check values
      if ~isnumeric(value)
         varargout{1} = 'number(s) expected';
         return
      end
      [range_check,force_int] = range_check_convert(param.range_check);
      if ~isempty(range_check)
         if ~isempty(find(value < range_check(1))) |...
            ~isempty(find(value > range_check(2)))
            varargout{1} = 'out of bounds';
            return
         end
      end
      if force_int & (~isinf(value) & ~isempty(find(mod(value,1))))
         varargout{1} = 'integer expected';
         return
      end
      % Check dimensions
      dim_check = dim_check_convert(param.dim_check);
      for ii=1:length(dim_check)
         [v,msg] = dim_check_value(dim_check{ii},value,outargs,0);
         if isempty(msg) % Take the first one that works!
            varargout{2} = v;
            return
         end
      end
      for ii=1:length(dim_check)
         [v,msg] = dim_check_value(dim_check{ii},value,outargs,1);
         if isempty(msg) % Take the first one that works!
            varargout{2} = v;
            return
         end
      end
      varargout{1} = msg;
end


%
% Parse the range_check parameter
%
function [range_check,force_int] = range_check_convert(range_check)
force_int = 0;
if ~isempty(range_check) & ischar(range_check)
   switch range_check
      case 'N+'
         range_check = [1,Inf];
         force_int = 1;
      case 'N-'
         range_check = [-Inf,-1];
         force_int = 1;
      case 'N'
         range_check = [0,Inf];
         force_int = 1;
      case 'Z'
         range_check = [];
         force_int = 1;
      case 'R'
         range_check = [];
      case 'R+'
         range_check = [0,Inf];
      case 'R-'
         range_check = [-Inf,0];
      otherwise
         range_check = 'Error';
   end
end


%
% Parse the dim_check parameter
%
function dim_check_out = dim_check_convert(dim_check)
if ~iscell(dim_check)
   dim_check = {dim_check};
end
dim_check_out = {};
jj = 1;
for ii=1:prod(size(dim_check))
   if isequal(dim_check{ii},-1)
      dim_check_out{jj} = [];
      jj = jj+1;
      dim_check_out{jj} = [1,-1];
      jj = jj+1;
   elseif isequal(dim_check{ii},0)
      dim_check_out{jj} = [1,1];
      jj = jj+1;
   else
      dim_check_out{jj} = dim_check{ii};
      jj = jj+1;
   end
end


%
% Test the value for dimensionality
%
function [value,msg] = dim_check_value(expectsz,value,outargs,convert)
msg = '';
if isempty(expectsz)
   if ~isempty(value)
      msg = 'empty array expected';
   end
   return
end
if length(expectsz)==1
   if ~isempty(outargs)
      expectsz = ndims(outargs{expectsz}{1});
      % this is already a dip_image: ndims can also be 0 or 1:
      if expectsz == 0
         msg = 'attempting to resize array to 0-D image';
         return
      end
      expectsz = [1,expectsz];
   else
      expectsz = [1,-1]; % we don't know what length it has to be: allow everything.
   end
end
sz = size(value);
if prod(sz)==1 & convert
   % repmat scalar value to needed array
   expectsz(expectsz==-1) = 1;
   value = repmat(value,expectsz);
else
   if length(sz)~=length(expectsz)
      msg = 'incorrect size';
      return
   end
   I = expectsz~=-1;
   if ~isequal(expectsz(I),sz(I))
      if sum(expectsz==1)==(length(expectsz)-1) & convert
         % transpose vector to see if it fits.
         value = value';
         sz = size(value);
      end
      if ~isequal(expectsz(I),sz(I))
         msg = 'incorrect size';
         return
      end
   end
end
