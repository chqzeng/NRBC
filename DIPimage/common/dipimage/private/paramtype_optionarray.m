%PARAMTYPE_OPTIONARRAY   Called by PARAMTYPE.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, 16, 18 September 2007.
% Built with code extracted from DIPIMAGE.M and GETPARAMS.M
% 12 August 2014: Fix for new graphics in MATLAB 8.4 (R2014b).

function varargout = paramtype_optionarray(command,param,varargin)

switch command
   case 'control_create'
      fig = varargin{1};   % figure handle
      default = param.default;
      if iscell(default) & isempty(default)
         default = '{}';
      end
      bh = uicontrol(fig,...
                     'Style','pushbutton',...
                     'String','Select...',...
                     'Visible','off',...
                     'HorizontalAlignment','center',...
                     'BusyAction','cancel',...
                     'Interruptible','off',...
                     'UserData',struct('options',param.range_check));
      eh = uicontrol(fig,...
                     'Style','edit',...
                     'String',default,...
                     'Visible','off',...
                     'HorizontalAlignment','left',...
                     'BackgroundColor',[1,1,1]);
      if matlabver_ge([8,4])
         set(bh,'Callback',@(x,y)dipimage('do_select',struct(...
                            'title',param.description,...
                            'editbox',eh)));
      else
         set(bh,'Callback',['dipimage(''do_select'',struct(',...
                            '''title'',''',param.description,''',',...
                            '''editbox'',',handle2str(eh),'))']);
      end
      varargout{1} = [eh,bh];
   case 'control_value'
      varargout{2} = get(varargin{1},'String');
      if isempty(varargout{2})
         varargout{2} = '[]';
      end
      if (iscell(param.range_check) & ~ischar(param.range_check{1})) | ...
         (isstruct(param.range_check) & ~ischar(param.range_check(1).name))
         varargout{1} = evalin('base',varargout{2});
      else
         try
            varargout{1} = evalin('base',varargout{2});
         catch
            varargout{1} = varargout{2};
            varargout{2} = mat2str(varargout{2});
         end
      end
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
         % default value can be cell array with 0 or more elements,
         %   depending on 'dim_check'.
         if ~isnumeric(param.dim_check) | ...
               (param.dim_check~=0 & param.dim_check~=1)
            msg = 'DIM_CHECK must be 0 or 1';
         end
         if ~iscell(param.default)
            defaultcell = {param.default};
         else
            defaultcell = param.default;
         end
         if param.dim_check==1
            if isempty(defaultcell)
               msg = 'DEFAULT is not allowed to be empty when DIM_CHECK=1';
            end
         end
      end
      if isempty(msg)
         for jj = 1:length(defaultcell)
            if ischar(defaultcell{jj})
               if ~iscellstr(options)
                  msg = 'DEFAULT and RANGE_CHECK do not match';
               else
                  N = find(strcmpi(options,defaultcell{jj}));
               end
            else
               if ~isnumeric(defaultcell{jj})
                  msg = 'options must be either strings or numerical values';
               elseif ~all(cellfun('isclass',options,'double'))
                  msg = 'DEFAULT and RANGE_CHECK do not match';
               else
                  N = find([options{:}] == defaultcell{jj});
               end
            end
            if isempty(msg) & isempty(N)
               msg = 'option not in list';
            end
            if ~isempty(msg)
               break;
            end
         end
      end
      varargout{1} = msg;
   case 'value_test'
      varargout{1} = '';
      value = varargin{1};
      if isempty(value)
         value = {};
      end
      if iscell(value)
         if param.dim_check==1 & length(value) < 1
            varargout{1} = 'option expected';
         else
            for ii=1:length(value)
               [varargout{1},value{ii}] = test_option(value{ii},param.range_check);
               if ~isempty(varargout{1})
                  break
               end
            end
         end
      else
         [varargout{1},value] = test_option(value,param.range_check);
      end
      varargout{2} = value;
end
