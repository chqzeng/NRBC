%DIPROI   Interactive ROI selection
%   Returns the mask image it allows the user to create over an existing
%   image display. It is formed by a single polygon or spline, created by
%   clicking on the image.
%
% SYNOPSIS:
%   [roi, v] = diproi(figure_handle, interpolation)
%   [roi, v] = diproi(interpolation)
%
% PARAMETERS:
%   figure_handle: 
%   interpolation: 'polygon','spline'
%
% RETURNS
%   v: vertices of polygon or spline
%
% DEFAULTS:
%   figure_handle: current window (GCF).
%   interpolation: 'polygon'
%
%   DIPROI is only available for 2D figure windows.
%
%   To create the polygon, use the left mouse button to add vertices.
%   A double-click adds a last vertex and closes the shape. 'Enter'
%   closes the shape without adding a vertex. To remove vertices, use
%   the 'Backspace' or 'Delete' keys, or the right mouse button. 'Esc'
%   aborts the operation. Shift-click will add a vertex constrained to
%   a horizontal or vertical location with respect to the previous vertex.
%
%   Note that you need to select at least three vertices. If you
%   don't, an error will be generated.
%
%   It is still possible to use all the menus in the victim figure
%   window, but you won't be able to access any of the tools (like
%   zooming and testing). The regular key-binding is also disabled.
%
%   Note: If you feel the need to interrupt this function with Ctrl-C,
%   you will need to refresh the display (by re-displaying the image
%   or changing the 'Actions' state).
%
%   See also DIPSHOW, DIPGETCOORDS, DIPCROP, DIPPROFILE.

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2001
% Adapted from DIPGETCOORDS
% 18 September 2001: Fixed bug for MATLAB 6: 'CurrentCharacter' is []
%                    after pressing shift key.
% 29 April 2002: Added right-click = delete feature.
% 3 April 2004: Added spline inter polation and changed vertices to 
%               second output (BR)
% 28 May 2010: Moved the interactive part to a separate function: DIPDRAWPOLYGON.

function [varargout] = diproi(varargin)

% Parse input
d = struct('menu','Display',...
          'display','Create mask image',...
          'inparams',struct('name',       {'fig','intertype'},...
                            'description',{'Figure window','Interpolation type'},...
                            'type',       {'handle','option'},...
                            'dim_check',  {0,0},...
                            'range_check',{'2D',{'polygon','spline'}},...
                            'required',   {0,0},...
                            'default',    {[],'polygon'}...
                           ),...
          'outparams',struct('name',{'mask','vertices'},...
                             'description',{'Mask image','Vertices'},...
                             'type',{'image','array'}...
                             )...
         );
if nargin == 1
   s = varargin{1};
   if ischar(s)
      if strcmp(s,'DIP_GetParamList')
         varargout{1} = d;
         return
      elseif any(strcmpi(varargin{1},{'polygon','spline'}))
         varargin = {[],varargin{1}};
      end
   end
end
try
   [fig,intertype] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

coords = dipdrawpolygon(fig);

if size(coords,1)<3
   error('You need to select at least three vertices.')
end

udata = get(fig,'userdata');
mask = newim(udata.imsize,'uint8');
switch intertype
   case 'polygon'
      mask = drawpolygon(mask,coords,1,'closed');
      mask = dip_image(mask,'bin');
      mask = ~bpropagation(mask&0,~mask,0,1,1);
      varargout{1} = mask;
      if nargout==2
        varargout{2} = coords; 
      end
   case 'spline'
      coords(end+1,:)=coords(1,:);
      n=length(coords);
      xs = spline(1:n,coords(:,1),1:.2:n);
      ys = spline(1:n,coords(:,2),1:.2:n);
      co = [xs' ys'];
      co(end,:) = [];
      co = floor(co);
      m2 = drawpolygon(mask,co,1,'closed');
      m2 = dip_image(m2,'bin');
      m2 = ~bpropagation(m2&0,~m2,0,1,1);
      varargout{1} = m2;
      if nargout==2
        varargout{2} = co; 
      end
   otherwise
      error('Unkown interpolation type.');
end
