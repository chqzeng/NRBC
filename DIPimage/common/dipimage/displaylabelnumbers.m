%DISPLAYLABELNUMBERS   Overlay the label numbers on a figure window
%
% SYNOPSIS:
%    displaylabelnumbers( figure_handle, label_image);
%
% PARAMETERS:
%    figure_handle: handle of the figure window to draw in
%    label_image:   image containing the labels
%
% EXAMPLE
%    a=label(readim('cermet')<128);
%    figure_handle=dipshow(a,'labels');
%    displaylabelnumbers(figure_handle,a);

% (C) Copyright 2006                    Michael van Ginkel
%
% Michael van Ginkel, March 2006.
% 23 March 2006:     Wasting time by making this thing shorter (CL).
% 20 September 2006: Removed annoying changing of current figure (CL).
% 18 September 2007 - MvG: handle empty label image

function out=displaylabelnumbers( fh, imlabels, varargin )

% Avoid being in menu
if nargin == 1
   if ischar(fh) & strcmp(fh,'DIP_GetParamList')
      out = struct('menu','none');
      return
   end
end

if ~isinteger(imlabels)
   error('Only label images supported');
end

img=[];
msrwhat={};
nvargs=nargin-2;
ai=1;
while ai<=nvargs
   switch varargin{ai}
      case 'grey'
         if (ai+1)>nvargs
            error('No argument to option "grey"');
         end
         img=varargin{ai+1};
         ai=ai+1;
      case 'measure'
         if (ai+1)>nvargs
            error('No argument to option "measure"');
         end
         msrwhat=varargin{ai+1};
         ai=ai+1;
      otherwise
         error(['Unknown option: ',varargin{ai}]);
   end
   ai=ai+1;
end

if isempty(msrwhat)
   msr=measure(imlabels,[],{'center'},[],1,0,0);
   msrwhat='id';
else
   msr=measure(imlabels,img,{'center',msrwhat},[],1,0,0);
end

tlabels=cell(size(msr,1),1);
for ii=1:length(tlabels)
   tlabels{ii} = num2str(getfield(msr(msr.ID(ii)),msrwhat));
end
%%% tlabels=cellstr(num2str(msr.id'); % simpler, but adds whitespace - don't know how to do this without a loop.
if nargout>0
   if isempty(msr)
      out={};
      return;
   end
   out={{'text',msr.center(1,:),msr.center(2,:),tlabels},...
        {'option','FontUnits','pixels'},...
        {'option','FontSize',8},...
        {'option','horizontalalignment','center'},...
        {'option','verticalalignment','middle'},...
        {'option','backgroundcolor','white'},...
        {'option','edgecolor','black'},...
        {'option','margin',1}};
end
if fh>0
   if ~isfigh(fh)
      error('First argument must be a figure handle')
   end
   if isempty(msr)
      return;
   end
   th = text(msr.center(1,:),msr.center(2,:),tlabels,'parent',get(fh,'CurrentAxes'));
   set(th,'FontUnits','pixels','FontSize',8,'horizontalalignment','center','verticalalignment','middle');
   set(th,'backgroundcolor','white','edgecolor','black','margin',1)
end
