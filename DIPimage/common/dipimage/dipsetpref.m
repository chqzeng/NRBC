%DIPSETPREF   Sets a DIPimage preference
%   DIPSETPREF('name',value) sets the value of the named DIPimage
%   preference.
%
%   DIPSETPREF('name1',value1,'name2',value2,'name3',value3,...)
%   sets multiple values at once.
%
%   Notice that these values are not stored from one session to the
%   next. You can add a DIPSETPREF command to your STARTUP file
%   to customize your copy of DIPimage.
%
%   The property names and values are described in the user manual.
%
%   See also: DIPGETPREF

% Undocumented syntax: DIPSETPREF -UNLOAD
%   Unlocks and clears the MEX-file private/dippreferences.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 7 April 2001:     Removed call to FIRSTERR.
% December 2002:    Removed comment to diphelp, which does not exist (BR)
% 25 October 2007:  Implemented the '-unload' syntax.
% 25 November 2007: Added '-link' and '-unlink' for DIPFIG to access
%                   DIPPREFERENCES indirectly. (MvG)
% 12 March 2008:    Removed last addition. Calling a different DIPPREFERENCES.

function menu_out = dipsetpref(varargin)

if nargin==1
   name = varargin{1};
   if ischar(name)
      if strcmp(name,'DIP_GetParamList')
         menu_out = struct('menu','none');
         return
      elseif strcmpi(name,'-unload')
         dippreferences('unload');
         clear private/dippreferences
         return
      end
   end
end
if nargin<2 | mod(nargin,2)
   error('Need name-value pairs.')
end
try
   for ii=1:2:nargin
      dippreferences('set',varargin{ii},varargin{ii+1});
   end
catch
   error(firsterr)
end
