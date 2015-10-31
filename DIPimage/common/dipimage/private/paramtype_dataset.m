%PARAMTYPE_DATASET   Called by PARAMTYPE.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, 16, 18 September 2007.
% Built with code extracted from DIPIMAGE.M and GETPARAMS.M

function varargout = paramtype_dataset(command,param,varargin)

switch command
   case 'control_create'
      fig = varargin{1};   % figure handle
      h = uicontrol(fig,...
                    'Style','edit',...
                    'String',param.default,...
                    'Visible','off',...
                    'HorizontalAlignment','left',...
                    'BackgroundColor',[1,1,1],...
                    'ButtonDownFcn','dipimage do_contextmenu dataset');
      cm = uicontextmenu('Parent',fig,'UserData',h);
      set(h,'UserData',struct('contextmenu',cm));
      varargout{1} = h;
   case 'control_value'
      varargout{2} = get(varargin{1},'String');
      if isempty(varargout{2})
         varargout{2} = '[]';
      end
      varargout{1} = evalin('base',varargout{2});
      if ~isa(varargout{1},'dataset')
         varargout{1} = dataset(varargout{1});
      end
   case 'default_value'
      try
         varargout{1} = evalin('base',param.default);
         if ~isa(varargout{1},'dataset')
            varargout{1} = dataset(varargout{1});
         end
      catch
         error('Default dataset evaluation failed.')
      end
   case 'definition_test'
      varargout{1} = '';
      if ~param.required
         if ~ischar(param.default)
            varargout{1} = 'DEFAULT dataset must be a string';
         end
      end
   case 'value_test'
      varargout{1} = '';
      value = varargin{1};
      if ~isa(value,'dataset') & ~isnumeric(value)
         varargout{1} = 'dataset expected';
      elseif nargout>1 & ~isa(value,'dataset')
         value = dataset(value); % Don't do this if it's not necessary.
      end
      varargout{2} = value;
end
