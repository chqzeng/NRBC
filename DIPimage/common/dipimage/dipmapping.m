%DIPMAPPING   Changes the mapping of an image in a figure window
%   DIPMAPPING(H,MAPPING) changes the mapping setting for figure window
%   H. MAPPING can be any string of the following:
%
%      'unit'                 'labels'          'xy'
%      'normal' or '8bit'     'periodic'        'xz'
%      '12bit'                'grey'            'yz'
%      '16bit'                'saturation'      'xt'
%      's8bit'                'zerobased'       'yt'
%      's12bit'                                 'zt'
%      's16bit'
%      'lin' or 'all'         'abs'
%      'percentile'           'real'            'global'
%      'log'                  'imag'            'nonglobal'
%      'base'                 'phase'
%      'angle'
%      'orientation'
%
%   The strings in the first column change the grey-value mapping. See
%   the help for DIPSHOW for more information on these. The strings in
%   the second column change the colormap. Incidentally, 'labels'
%   implies 'normal'. The strings in the third column set the complex
%   to real mapping. The ones in the third comumn select the orientation
%   of the slices in a 3D display, and the ones in the fourth column set
%   global stretching on or off in 3D displays. You can combine one
%   string from each of these four columns in a single command, the
%   order is irrelevant.
%
%   Additionally, DIPMAPPING(...,'SLICE',N) sets a 3D display to slice
%   number N. These two values must be consecutive, but they can be
%   mixed in with the other strings in any order.
%   DIPMAPPING(...,'COLORMAP',CM) sets the colormap to CM. These two
%   values must be consecutive, but they can be mixed in with the other
%   strings in any order.
%
%   You can also use a two-value vector that sets the range, as in
%   DIPSHOW: DIPMAPPING(H,[LOW,HIGH]).
%
%   H, the figure window handle, can be left out. It will default to
%   the current figure.
%
%   See also DIPSHOW.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2001
% 22 September 2001: Added undocumented feature 'manual' as a callback to a menu item.
%                    Added 'slice' and 'global' parameters.
% 19 October 2001:   The dialog box now updates the figure interactively. Removed the
%                    cancel button.
% 19 March 2002:     Fixed little bug that occurred when the dialog box was killed by
%                    the user.
% 25 November 2003:  Added colormap things.
% 7 February 2005:   Added mapping modes for unsigned, 12- and 16-bit data. Not computing
%                    the range immediately if not available - let user click a button if
%                    he needs it.
% 4 October 2005:    The 'labels' mode now forces 'normal', like it said in the help.
% 24 July 2007:      Added 'xt','yt' and 'zt' options.
% 24 June 2008:      Fixed GUI error when low and high limits for slider were equal.
% 2 September 2011:  Added 'unit' stretch mode. (CL)
% 11 August 2014:    Fix for new graphics in MATLAB 8.4 (R2014b).

% Undocumented:
%   DIPMAPPING('manual') brings up a dialog box that allows the user to
%   select an upper and lower bound for the range. It is used as a callback to the
%   'Manual...' menu item under 'Mappings'.
%   DIPMAPPING('custom') brings up a dialog box that allows the user to
%   select a colormap. It is used as a callback to the 'Custom...' menu item under
%   'Mappings'.

