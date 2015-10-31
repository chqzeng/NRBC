%PARAMTYPE_CELLARRAY   Called by PARAMTYPE.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, 16, 18 September 2007.
% Built with code extracted from DIPIMAGE.M and GETPARAMS.M

function varargout = paramtype_cellarray(command,param,varargin)

switch command
   case 'control_create'
      fig = varargin{1};   % figure handle
      h = uicontrol(fig,...
                    'Style','edit',...
                    'String',cell2str(param.default),...
                    'Visible','off',...
                    'HorizontalAlignment','left',...
                    'BackgroundColor',[1,1,1]);
      varargout{1} = h;
   case 'control_value'
      varargout{2} = get(varargin{1},'String');
      if isempty(varargout{2})
         varargout{2} = '{}';
      end
      varargout{1} = evalin('base',varargout{2});
   case 'default_value'
      varargout{1} = param.default;
   case 'definition_test'
      varargout{1} = '';
      if ~iscell(param.default)
         varargout{1} = 'DEFAULT must be a cell array';
      end
   case 'value_test'
      varargout{1} = '';
      value = varargin{1};
      if isempty(value)
         value = {};
      end
      if ~iscell(value)
         varargout{1} = 'cell expected';
      end
      varargout{2} = value;
end
