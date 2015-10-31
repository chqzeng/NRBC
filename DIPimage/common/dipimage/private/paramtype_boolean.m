%PARAMTYPE_BOOLEAN   Called by PARAMTYPE.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, 16, 18 September 2007.
% Built with code extracted from DIPIMAGE.M and GETPARAMS.M

function varargout = paramtype_boolean(command,param,varargin)

switch command
   case 'control_create'
      fig = varargin{1};   % figure handle
      default = evalbool(param.default)+1; % 1 or 2
      h = uicontrol(fig,...
                    'Style','popupmenu',...
                    'String',{'no','yes'},...
                    'Value',default,...
                    'Visible','off',...
                    'HorizontalAlignment','left',...
                    'BackgroundColor',[1,1,1]);
      varargout{1} = h;
   case 'control_value'
      indx = get(varargin{1},'Value');
      varargout{1} = indx-1;         % first element is NO, second YES.
      varargout{2} = num2str(varargout{1});
   case 'default_value'
      varargout{1} = evalbool(param.default);
   case 'definition_test'
      varargout{1} = '';
      try
         evalbool(param.default);
      catch
         varargout{1} = 'DEFAULT boolean should be ''yes'',''no'', 1 or 0';
      end
   case 'value_test'
      varargout{1} = '';
      varargout{2} = [];
      try
         varargout{2} = evalbool(varargin{1});
      catch
         varargout{1} = 'boolean expected';
      end
end


%
% Parse a boolean value
%
function bool = evalbool(string)
if ischar(string)
   switch lower(string)
      case {'y','yes','t','true'}
         bool = 1;
      case {'n','no','f','false'}
         bool  = 0;
      otherwise
         error('Boolean value expected.')
   end
elseif ( isnumeric(string) | islogical(string) ) & prod(size(string))==1
   if string
      bool = 1;
   else
      bool = 0;
   end
else
   error('Boolean value expected.')
end
