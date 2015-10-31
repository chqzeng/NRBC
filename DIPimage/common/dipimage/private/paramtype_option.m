%PARAMTYPE_OPTION   Called by PARAMTYPE.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, 16, 18 September 2007.
% Built with code extracted from DIPIMAGE.M and GETPARAMS.M

function varargout = paramtype_option(command,param,varargin)

switch command
   case 'control_create'
      fig = varargin{1};   % figure handle
      % Create a list of possible values and a list for display
      data = param.range_check;
      if isstruct(data)
         h = uicontrol(fig,'Style','text','String',' ','Visible','off');
         extent = get(h,'Extent');
         spw = extent(3);
         set(h,'String','  ');
         extent = get(h,'Extent');
         spw = extent(3) - spw; % This is the width added by a single space
         displist = {data.name};
         set(h,'String',displist);
         extent = get(h,'Extent');
         namew = extent(3) + spw; % This is the width of the widest name
         for ii=1:length(data)
            set(h,'String',data(ii).name);
            extent = get(h,'Extent');
            nspaces = round((namew - extent(3))/spw);
            displist{ii} = [data(ii).name,repmat(' ',1,nspaces),'- ',data(ii).description];
         end
         delete(h);
         data = {data.name};
      else
         displist = data;
      end
      % Find the index for the default value
      default = param.default;
      if (isempty(default))
         default = 1;
      else
         if ischar(default)
            default = find(strcmpi(data,default));
         else
            default = find([data{:}]==default);
            for ii=1:length(data);
               data{ii} = mat2str(data{ii});
            end
         end
      end
      h = uicontrol(fig,...
                    'Style','popupmenu',...
                    'String',displist,...
                    'Value',default,...
                    'Visible','off',...
                    'HorizontalAlignment','left',...
                    'BackgroundColor',[1,1,1]);
      varargout{1} = h;
   case 'control_value'
      indx = get(varargin{1},'Value');
      if iscell(param.range_check)
         varargout{1} = param.range_check{indx};
      else %isstruct(param.range_check)
         varargout{1} = param.range_check(indx).name;
      end
      varargout{2} = mat2str(varargout{1});
   case 'default_value'
      varargout{1} = param.default;
   case 'definition_test'
      msg = '';
      if isempty(param.range_check)
         msg = 'RANGE_CHECK can not be empty for option';
      elseif iscell(param.range_check)
         options = param.range_check;
      else
         if isstruct(param.range_check)
            if isfield(param.range_check,'name') & isfield(param.range_check,'description')
               options = {param.range_check.name};
            else
               msg = 'RANGE_CHECK must contain a ''name'' and a ''description'' field';
            end
         else
            msg = 'RANGE_CHECK must be a cell for option';
         end
      end
      if isempty(msg)
         default = param.default;
         if ischar(default)
            if ~iscellstr(options)
               msg = 'DEFAULT and RANGE_CHECK do not match';
            else
               N = find(strcmpi(options,default));
            end
         else
            if ~isnumeric(default)
               msg = 'options must be either strings or numerical values';
            elseif ~all(cellfun('isclass',options,'double'))
               msg = 'DEFAULT and RANGE_CHECK do not match';
            else
               N = find([options{:}] == default);
            end
         end
         if isempty(msg) & isempty(N)
            msg = 'option not in list';
         end
      end
      varargout{1} = msg;
   case 'value_test'
      [varargout{1},varargout{2}] = test_option(varargin{1},param.range_check);
end
