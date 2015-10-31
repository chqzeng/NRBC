%PARAMTYPE_HANDLE   Called by PARAMTYPE.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, 16, 18 September 2007.
% Built with code extracted from DIPIMAGE.M and GETPARAMS.M
% 22 September 2011 (@11:11): Not giving an error in 'default_value': it will
%                             be overwritten by caller, giving the user a strange
%                             message.
% 12 August 2014: Fix for new graphics in MATLAB 8.4 (R2014b).

function varargout = paramtype_handle(command,param,varargin)

switch command
   case 'control_create'
      fig = varargin{1};   % figure handle
      % Get a list with figure window names
      [figh,strings] = handlelist(param.range_check);
      if isempty(figh)
         strings = {''};
         figh = 0;
      end
      h = uicontrol(fig,...
                    'Style','popupmenu',...
                    'String',strings,...
                    'Value',1,...
                    'Visible','off',...
                    'HorizontalAlignment','left',...
                    'BackgroundColor',[1,1,1],...
                    'UserData',struct('figh',figh));
      cmenu = uicontextmenu('Parent',fig);
      set(h,'UIContextMenu',cmenu);
      if matlabver_ge([8,4])
         uimenu(cmenu,'Label','Reload','Callback',@(x,y)dipimage('do_reloadcontrol',struct(...
                            'type','handle',...
                            'popupmenu',h,...
                            'selection',param.range_check)));
      else
         uimenu(cmenu,'Label','Reload','Callback',['dipimage(''do_reloadcontrol'',struct(',...
                            '''type'',''handle'',',...
                            '''popupmenu'',',handle2str(h),',',...
                            '''selection'',',cell2str(param.range_check),'))']);
      end
      varargout{1} = h;
   case 'control_value'
      figh = get(varargin{1},'UserData');
      figh = figh.figh;
      indx = get(varargin{1},'Value');
      varargout{1} = figh(indx);
      varargout{2} = num2str(varargout{1});
   case 'default_value'
      varargout{1} = get(0,'CurrentFigure');
   case 'definition_test'
      varargout{1} = '';
      if ~isempty(param.range_check) & ~ischar(param.range_check) & ~iscellstr(param.range_check)
         varargout{1} = 'RANGE_CHECK must be a cell array of strings for handle';
      end
   case 'value_test'
      varargout{1} = '';
      varargout{2} = [];
      try
         value = getfigh(varargin{1});
      catch
         varargout{1} = 'handle expected';
         return
      end
      if ~isempty(param.range_check)
         h = handlelist(param.range_check);
         if ~any(h==value)
            varargout{1} = 'figure window not of expected type';
         end
      end
      varargout{2} = value;
end
