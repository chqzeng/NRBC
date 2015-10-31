%PARAMTYPE_IMAGE   Called by PARAMTYPE.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, 16, 18 September 2007.
% Built with code extracted from DIPIMAGE.M and GETPARAMS.M
% 30 July 2009:    Added options to control the input image type.

function varargout = paramtype_image(command,param,varargin)

switch command
   case 'control_create'
      fig = varargin{1};   % figure handle
      h = uicontrol(fig,...
                    'Style','edit',...
                    'String',param.default,...
                    'Visible','off',...
                    'HorizontalAlignment','left',...
                    'BackgroundColor',[1,1,1]);
      [dt,at] = parse_range_check(param.range_check);
      if ~isempty(at)
         % This difference might not be seen on some earlier versions of MATLAB:
         if strcmp(at,'scalar')
            set(h,'ButtonDownFcn','dipimage(''do_contextmenu'',{''dip_image''})');
         else
            set(h,'ButtonDownFcn','dipimage(''do_contextmenu'',{''dip_image'',''dip_image_array''})');
         end
      end
      cm = uicontextmenu('Parent',fig,'UserData',h);
      set(h,'UserData',struct('contextmenu',cm));
      varargout{1} = h;
   case 'control_value'
      varargout{2} = get(varargin{1},'String');
      if isempty(varargout{2})
         varargout{2} = '[]';
      end
      varargout{1} = evalin('base',varargout{2});
      varargout{1} = dip_image(varargout{1});
   case 'default_value'
      try
         varargout{1} = dip_image(evalin('base',param.default));
      catch
         error('Default image evaluation failed.')
      end
   case 'definition_test'
      varargout{1} = '';
      if isempty(parse_range_check(param.range_check))
         varargout{1} = 'illegal RANGE_CHECK value';
         return
      end
      if isempty(parse_dim_check(param.dim_check))
         varargout{1} = 'illegal DIM_CHECK value';
         return
      end
      if ~param.required
         if ~ischar(param.default)
            varargout{1} = 'DEFAULT image must be a string';
            return
         end
      end
   case 'value_test'
      varargout{1} = '';
      varargout{2} = [];
      value = varargin{1};
      %#function isa
      if ~builtin('isa',value,'dip_image') & ~isnumeric(value) & ~islogical(value)
         varargout{1} = 'image expected';
         return
      end
      value = dip_image(value);
      [dt,at] = parse_range_check(param.range_check);
      switch at
      case 'scalar'
         if ~isscalar(value)
            varargout{1} = 'scalar image expected';
            return
         end
      case 'tensor'
         if ~istensor(value)
            varargout{1} = 'tensor image expected';
            return
         end
      case 'vector'
         if ~isvector(value)
            varargout{1} = 'vector image expected';
            return
         end
      case 'color'
         if ~iscolor(value)
            varargout{1} = 'color image expected';
            return
         end
      end
      for ii=1:prod(imarsize(value))
         if ~any(strcmp(dt,datatype(value{ii})))
            varargout{1} = 'image data type not supported';
            return
         end
      end
      dim = parse_dim_check(param.dim_check);
      for ii=1:prod(imarsize(value))
         d = ndims(value{ii});
         if d<dim(1) | d>dim(2)
            varargout{1} = 'image dimensionality not supported';
            return
         end
      end
      varargout{2} = value;
end

% Parse the RANGE_CHECK parameter, isempty(dt) => error.
function [dt,at] = parse_range_check(range)
alltypes = {'scalar','array','tensor','vector','color'};
dt = ''; % error state!
at = 'tensor'; % default
if ischar(range) & ~isempty(range)
   range = {range};
end
if isempty(range)
   dt = {'any'}; % default
else
   if ~iscellstr(range)
      return; % signals error!
   end
   range = range(:)'; % force row vector
   I = [];
   for ii=1:length(range)
      if any(strcmp(range{ii},alltypes))
         I = [I,ii];
      end
   end
   if length(I)>1
      return; % signals error!
   end
   if ~isempty(I)
      at = range{I};
      range(I) = [];
   end
   if isempty(range)
      dt = {'any'}; % default
   else
      dt = range;
   end
end
dt = unique(dt);
% 'any' = 'complex' + 'bin'
I = find(strcmp(dt,'any'));
if ~isempty(I)
   dt(I) = [];
   dt = unique([dt,{'complex','bin'}]);
end
% 'complex' = 'scomplex' + 'dcomplex' + 'real'
I = find(strcmp(dt,'complex'));
if ~isempty(I)
   dt(I) = [];
   dt = unique([dt,{'scomplex','dcomplex','real'}]);
end
% 'noncomplex' = 'real' + 'bin'
I = find(strcmp(dt,'noncomplex'));
if ~isempty(I)
   dt(I) = [];
   dt = unique([dt,{'real','bin'}]);
end
% 'real' = 'float' + 'integer'
I = find(strcmp(dt,'real'));
if ~isempty(I)
   dt(I) = [];
   dt = unique([dt,{'float','integer'}]);
end
% 'integer' | 'int' = 'signed' + 'unsigned'
I = find( strcmp(dt,'integer') | strcmp(dt,'int') );
if ~isempty(I)
   dt(I) = [];
   dt = unique([dt,{'signed','unsigned'}]);
end
% 'float' = 'sfloat' + 'dfloat'
I = find(strcmp(dt,'float'));
if ~isempty(I)
   dt(I) = [];
   dt = unique([dt,{'sfloat','dfloat'}]);
end
% 'signed' | 'sint' = 'sint8' + 'sint16' + 'sint32'
I = find( strcmp(dt,'signed') | strcmp(dt,'sint') );
if ~isempty(I)
   dt(I) = [];
   dt = unique([dt,{'sint8','sint16','sint32'}]);
end
% 'unsigned' | 'uint' = 'uint8' + 'uint16' + 'uint32'
I = find( strcmp(dt,'unsigned') | strcmp(dt,'uint') );
if ~isempty(I)
   dt(I) = [];
   dt = unique([dt,{'uint8','uint16','uint32'}]);
end

% Parse the DIM_CHECK parameter, isempty(dim) => error.
function dim = parse_dim_check(dim)
if isempty(dim)
   dim = []; % force any empty array to be numeric, we don't want too many errors.
end
if ~isnumeric(dim)
   dim = []; % signals error!
   return;
end
if isempty(dim) | isequal(dim,0)
   dim = [0,Inf];
   return;
end
if prod(size(dim))==1
   dim = [dim,dim];
end
if prod(size(dim))~=2 | any(dim<0)
   dim = [];
   return;
end
dim = sort(dim(:)');
