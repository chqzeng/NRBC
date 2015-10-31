%PARAMTYPE_STRING   Called by PARAMTYPE.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, 16, 18 September 2007.
% Built with code extracted from DIPIMAGE.M and GETPARAMS.M

function varargout = paramtype_string(command,param,varargin)

switch command
   case 'control_create'
      fig = varargin{1};   % figure handle
      h = uicontrol(fig,...
                    'Style','edit',...
                    'String',param.default,...
                    'Visible','off',...
                    'HorizontalAlignment','left',...
                    'BackgroundColor',[1,1,1]);
      varargout{1} = h;
   case 'control_value'
      varargout{2} = get(varargin{1},'String');
      varargout{1} = varargout{2};
      varargout{2} = mat2str(varargout{2});
   case 'default_value'
      varargout{1} = param.default;
   case 'definition_test'
      varargout{1} = '';
      if ~ischar(param.default)
         varargout{1} = 'DEFAULT string must be a string';
      end
   case 'value_test'
      varargout{1} = '';
      if ~ischar(varargin{1})
         varargout{1} = 'string expected';
      end
      varargout{2} = varargin{1};
end
