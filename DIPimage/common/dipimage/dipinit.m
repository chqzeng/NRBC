%DIPINIT   Initialize the working environment
%   DIPINIT is called by DIPIMAGE when starting up. It initializes
%   the working environment. Since it is a script, it is possible
%   to initialize variables too.
%   Note that you can also call this script yourself, to re-set the
%   windows to their initial location.
%
%   The commands herein are only an example. You can copy this file
%   to your local directory (make sure it sits before the DIPimage
%   toolbox directory on your path), and edit it to your liking.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Many people. Last change: 2 September 2011

dipinit_window10 = 'other'; % for DIPimage up to version 2.3 this was 'a'
dipinit_window11 = 'other'; % for DIPimage up to version 2.3 this was 'b'
dipinit_window12 = 'other'; % for DIPimage up to version 2.3 this was 'c'
dipinit_window13 = 'other'; % for DIPimage up to version 2.3 this was 'd'
dipinit_window14 = 'other'; % for DIPimage up to version 2.3 this was 'ans'
dipinit_window15 = 'other';

% Remove any previous links
dipfig -unlink

% Determine MATLAB version to see if we can use 'OuterPosition' property
dipinit_v = version;
dipinit_I = find(dipinit_v=='.');
if length(dipinit_I)>1
   dipinit_v = dipinit_v(1:dipinit_I(2)-1);
end
dipinit_v = str2double(dipinit_v);

% Get window sizes
dipinit_ws = [dipgetpref('DefaultFigureWidth'),dipgetpref('DefaultFigureHeight')];

% First link (we'll use this window to measure outer size of windows)
dipinit_h = dipfig(10,dipinit_window10,dipinit_ws);
drawnow; % for the benefit of MATLAB 7.0.1 on Windows XP

% Determine size of elements & spacing of windows
if dipinit_v >= 6.5
   % This undocumented feature new in MATLAB 6.5
   pause(0.5) % somehow needed when this file is being called from within DIPimage GUI
   dipinit_sp = get(dipinit_h,'OuterPosition') - get(dipinit_h,'Position');
   dipinit_trm = dipinit_sp(3:4)+dipinit_sp(1:2);
   dipinit_sp = dipinit_sp(3:4)+dipinit_ws;
else
   % Some default for older MATLABs
   dipinit_trm = [4,41];
   dipinit_sp = dipinit_ws + [8,45];
end
dipinit_ss = get(0,'ScreenSize');
dipinit_ss = dipinit_ss(3:4);
dipinit_ss = dipinit_ss-dipinit_trm-dipinit_ws;
if dipinit_ss(2) < 2*dipinit_sp(2)
   % The screen is too small to fit the three windows
   dipinit_sp(2) = dipinit_ss(2)/2;
end

% Set the position of the first window and make the other 5
set(dipinit_h,'position',[dipinit_ss-dipinit_sp.*[1,0],dipinit_ws]);
dipfig(11,dipinit_window11,[dipinit_ss-dipinit_sp.*[0,0],dipinit_ws]);
dipfig(12,dipinit_window12,[dipinit_ss-dipinit_sp.*[1,1],dipinit_ws]);
dipfig(13,dipinit_window13,[dipinit_ss-dipinit_sp.*[0,1],dipinit_ws]);
dipfig(14,dipinit_window14,[dipinit_ss-dipinit_sp.*[1,2],dipinit_ws]);
dipfig(15,dipinit_window15,[dipinit_ss-dipinit_sp.*[0,2],dipinit_ws]);

% Message for the benefit of the new user
disp(' ')
disp('   The image display windows you see now are created by dipinit.m.')
disp('   Type HELP DIPINIT to learn how to modify these default windows.')
disp(' ')

% Clear local variables - this is necessary because this is a script
clear dipinit_*
% Note how all variables start with 'dipinit_'. This is to avoid conflicts with
% any variables you might have defined in your base workspace, where this script
% executes.
