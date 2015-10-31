%DIPPREFERENCESS   Stores user preferences for the DIPimage toolbox
%   dippreferences('defaults')        -> get factory defaults (in struct)
%   dippreferences('list')            -> get current settings (in struct)
%   dippreferences('get',name)        -> get value
%   dippreferences('set',name,value)  -> set value
%   dippreferences('unload')          -> unlock m-file

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, 12 March 2008.
%   This is the 2nd version of dippreferences. The first version was a MEX-file.
%   This one is simpler, shorter and easier to maintain.
% 14 April 2008: Added 'ConflictingPixelSize' and 'InconsistentPixelSize' properties.
% 24 March 2009: Added 'UserManualLocation' property. Increased ComputationLimit default.
% 26 March 2009: Added 'CurrentImageSaveDir' property for DIPSHOW.
% 14 July 2011:  Added 'BinaryDisplayColor' preference for DIPSHOW.
% 12 March 2013: Added 'FFTtype' preference for FT and IFT. (BR)
% 2 Dec 2013:    Added 'KeepDataType' preference. (BR)

% To make changes:
% - There is one large block at the begining of the main function that lists
%   all of the preferences, the type and the default value. This block does
%   not need to be sorted, but it looks prettier if it is!
% - If your preference data is stored in DIPlib, edit the setdiplib and
%   getdiplib sub-functions at the end of this file.
% - If you need additional checking of preference values, edit the checkvalue
%   function towards the end of this file.
%
% Data is stored in this way:
% - settings.SettingName.value is the value for preference 'SettingName'.
% - settings.SettingName.type is a string defining the type. Currently it can be:
%     - 'string'   : a string
%     - 'boolean'  : a boolean value (on/off)
%     - 'integer'  : a scalar integer value
%     - 'float'    : a scalar float value
%     - 'integer*N': a Nx1 integer array
%     - 'float*N'  : a Nx1 float array
%
% Some error messages in this function are somewhat silly. Those are the ones
% we never expect to occur as long as this function is called through DIPGETPREF
% and DIPSETPREF.

function out = dippreferencess(varargin)

persistent settings;
persistent factory;
if isempty(factory)
   % Initialize
   factory = struct(...
      'BinaryDisplayColor',      struct('type','float*3','value',[1,0,0]     ),...
      'BoundaryCondition',       struct('type','string', 'value',''          ),...
      'BringToFrontOnDisplay',   struct('type','boolean','value',logical(1)  ),...
      'CommandFilePath',         struct('type','string', 'value',''          ),...
      'ComplexMappingDisplay',   struct('type','string', 'value','x+iy'      ),...
      'ComputationLimit',        struct('type','integer','value',64*1024^2   ),...
      'ConflictingPixelSize',    struct('type','string', 'value','first'     ),...
      'CurrentImageFileDir',     struct('type','string', 'value',''          ),...
      'CurrentImageSaveDir',     struct('type','string', 'value',''          ),...
      'DebugMode',               struct('type','boolean','value',logical(0)  ),...
      'DefaultActionState',      struct('type','string', 'value','diptest'   ),...
      'DefaultColorMap',         struct('type','string', 'value','grey'      ),...
      'DefaultComplexMapping',   struct('type','string', 'value','abs'       ),...
      'DefaultFigureHeight',     struct('type','integer','value',256         ),...
      'DefaultFigureWidth',      struct('type','integer','value',256         ),...
      'DefaultGlobalStretch',    struct('type','boolean','value',logical(0)  ),...
      'DefaultMappingMode',      struct('type','string', 'value','normal'    ),...
      'DefaultSlicing',          struct('type','string', 'value','xy'        ),...
      'DerivativeFlavour',       struct('type','string', 'value','best'      ),...
      'DisplayToFigure',         struct('type','boolean','value',logical(1)  ),...
      'EnableKeyboard',          struct('type','boolean','value',logical(1)  ),...
      'FileWriteWarning',        struct('type','boolean','value',logical(1)  ),...
      'FFTtype',                 struct('type','string', 'value','diplib'    ),...
      'Gamma',                   struct('type','float*3','value',[1,1,1]     ),...
      'GammaGrey',               struct('type','float',  'value',1           ),...
      'ImageFilePath',           struct('type','string', 'value',''          ),...
      'ImageSizeLimit',          struct('type','integer','value',4096        ),...
      'InconsistentPixelSize',   struct('type','string', 'value','pixel'     ),...
      'KeepDataType',            struct('type','boolean','value',logical(0)  ),...
      'MorphologicalFlavour',    struct('type','integer','value',0           ),...
      'NumberOfThreads',         struct('type','integer','value',1           ),...
      'PutInCommandWindow',      struct('type','boolean','value',logical(1)  ),...
      'RespectVisibility',       struct('type','boolean','value',logical(0)  ),...
      'TrueSize',                struct('type','boolean','value',logical(1)  ),...
      'Truncation',              struct('type','integer','value',3           ),...
      'UserManualLocation',      struct('type','string','value','ftp://ftp.tudelft.nl/pub/DIPimage/latest/docs/dipimage_user_manual.pdf'));
   factory.BoundaryCondition.value = getdiplib('BoundaryCondition');
   factory.NumberOfThreads.value = getdiplib('NumberOfThreads');
   factory.Truncation.value = getdiplib('Truncation');
   settings = factory;
   mlock;
end
if isempty(settings)
   % Shouldn't happen?
   settings = factory;
end

if nargin<1 | ~ischar(varargin{1})
   error('Nothing to do!');
end
switch varargin{1}

   % dippreferences('defaults')
   case 'defaults'
      out = simplify(factory);

   % dippreferences('list')
   case 'list'
      snames = fieldnames(settings);
      for ii=1:length(snames)
         tmp = getdiplib(snames{ii});
         if ~isempty(tmp)
            indx = substruct('.',snames{ii});
            data = subsref(settings,indx);
            data.value = tmp;
            settings = subsasgn(settings,indx,data);
         end
      end
      out = simplify(settings);

   % dippreferences('get',name)
   case 'get'
      if nargin~=2 | ~ischar(varargin{2})
         error('Get what???')
      end
      name = varargin{2};
      snames = fieldnames(settings);
      I = find(strcmpi(name,snames));
      if isempty(I)
         error(['Unknown preference name: ',name,'.']);
      end
      name = snames{I(1)};
      data = subsref(settings,substruct('.',name));
      out = getdiplib(name);
      if isempty(out)
         out = data.value;
      end

   % dippreferences('set',name,value)
   case 'set'
      if nargin~=3 | ~ischar(varargin{2})
         error('Set what???')
      end
      name = varargin{2};
      value = varargin{3};
      snames = fieldnames(settings);
      I = find(strcmpi(name,snames));
      if isempty(I)
         error(['Unknown preference name: ',name,'.']);
      end
      name = snames{I(1)};
      indx = substruct('.',name);
      data = subsref(settings,indx);
      type = data.type;
      I = find(type=='*');
      if isempty(I)
         N = 1;
      else
         N = str2double(type(I(1)+1:end));
         type = type(1:I(1)-1);
      end
      switch type
         case 'string'
            if ~ischar(value)
               error(['String expected for preference ',name,'.'])
            end
            data.value = value;
         case 'boolean'
            if islogical(value) | isnumeric(value)
               data.value = logical(value(1));
            elseif ischar(value)
               if any(strcmpi({'on','yes'},value))
                  data.value = logical(1);
               elseif any(strcmpi({'off','no'},value))
                  data.value = logical(0);
               else
                  error(['String expected for preference ',name,'.'])
               end
            else
               error(['String expected for preference ',name,'.'])
            end
         case 'integer'
            if ~isnumeric(value) | any(mod(value,1))
               error(['Integer value expected for preference ',name,'.'])
            end
            if prod(size(value))~=N
               error([num2str(N),' values expected for preference ',name,'.'])
            end
            data.value = value(:)';
         case 'float'
            if ~isnumeric(value)
               error(['Numeric value expected for preference ',name,'.'])
            end
            if prod(size(value))~=N
               error([num2str(N),' values expected for preference ',name,'.'])
            end
            data.value = value(:)';
         otherwise
            error('This preference has a weird data type!')
      end
      data = checkvalue(name,data,subsref(factory,indx));
      settings = subsasgn(settings,indx,data);
      setdiplib(name,data.value);

   % dippreferences('unload')
   case 'unload'
      munlock;
      factory = [];
      settings = [];

   otherwise
      error('I don''t understand you.')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function settings = simplify(settings)
snames = fieldnames(settings);
for ii=1:length(snames)
   indx = substruct('.',snames{ii});
   data = subsref(settings,indx);
   settings = subsasgn(settings,indx,data.value);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data = checkvalue(name,data,defdata)
switch name
   case {'ComputationLimit','DefaultFigureHeight','DefaultFigureWidth'}
      if data.value<1
         data.value = defdata.value;
      end
   case 'ImageSizeLimit'
      data.value = max(0,data.value);
   case {'Gamma','GammaGrey'}
      data.value = max(0.01,data.value);
      data.value = min(100,data.value);
   case 'BinaryDisplayColor'
      data.value = max(0,min(1,data.value));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function val = getdiplib(name)
switch name
   case 'BoundaryCondition'
      try
         val = dip_getboundary(1);
         val = val{1};
      catch
         val = 'symmetric';
      end
   case 'NumberOfThreads'
      try
         val = dip_getnumberofthreads;
      catch
         val = 1;
      end
   case 'Truncation'
      try
         val = dip_gettruncation;
      catch
         val = 3;
      end
   otherwise
      val = [];
end

function setdiplib(name,val)
switch name
   case 'BoundaryCondition'
      dip_setboundary(val);
   case 'NumberOfThreads'
      dip_setnumberofthreads(val);
   case 'Truncation'
      dip_settruncation(val);
end
