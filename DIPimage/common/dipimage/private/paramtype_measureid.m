%PARAMTYPE_MEASUREID   Called by PARAMTYPE.

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
%                 Fixed another bug too!

function varargout = paramtype_measureid(command,param,varargin)

switch command
   case 'control_create'
      fig = varargin{1};   % figure handle
      h = uicontrol(fig,...
                    'Style','popupmenu',...
                    'String',{''},...
                    'Value',1,...
                    'Visible','off',...
                    'HorizontalAlignment','left',...
                    'BackgroundColor',[1,1,1]);
      mh = findobj(fig,'Type','uicontrol','Tag',['control',num2str(param.dim_check)]);
      if matlabver_ge([8,4])
         set(mh,'Callback',@(x,y)dipimage('do_reloadcontrol',struct(...
                            'type','measureid',...
                            'popupmenu',h,...
                            'num',num2str(param.dim_check))));
      else
         set(mh,'Callback',['dipimage(''do_reloadcontrol'',struct(',...
                            '''type'',''measureid'',',...
                            '''popupmenu'',',handle2str(h),',',...
                            '''num'',',num2str(param.dim_check),'))']);
      end
      varargout{1} = h;
   case 'control_value'
      options = get(varargin{1},'String');
      indx = get(varargin{1},'Value');
      varargout{1} = options{indx};
      varargout{2} = mat2str(varargout{1});
   case 'default_value'
      varargout{1} = '';
   case 'definition_test'
      varargout{1} = [];
      params = varargin{1};
      if prod(size(param.dim_check)) ~= 1 | ~isnumeric(param.dim_check) | ...
         mod(param.dim_check,1)
         varargout{1} = 'DIM_CHECK should be a scalar integer';
      elseif param.dim_check >= length(params) | param.dim_check < 1
         varargout{1} = 'DIM_CHECK points to a non-existent parameter';
      elseif ~strcmpi(params(param.dim_check).type,'measurement')
         varargout{1} = 'DIM_CHECK should point to a measurement parameter';
      end
   case 'value_test'
      if ~(nargout>1)
         error('CANNOT HAPPEN') % This is always called with the 3-input, 2-output syntax.
      end
      varargout{1} = '';
      value = varargin{1};
      outargs = varargin{2};
      options = fieldnames(outargs{param.dim_check});
      default = options{1};
      if isempty(value)
         value = default;
      end
      if ~ischar(value)
         varargout{1} = 'string expected';
      else
         [varargout{1},value] = test_option(value,options);
      end
      varargout{2} = value;
end
