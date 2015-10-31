%MEASUREHELP   Provides help on the measurement features
%
% SYNOPSIS:
%  measurehelp
%
% This function provides help on the usage of the MEASUREMENT function.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February 2002.
% 12 Feb 2007:    Better way of removing Mike's private measurement functions.
% 5 March 2008:   Also listing Bernd's new derived measurements. (CL)

function out = measurehelp(in)

if nargin == 1
   if ischar(in) & strcmp(in,'DIP_GetParamList')
      out = struct('menu','Analysis',...
                   'display','Help on measurement features'...
                   );
      return
   end
end

msmts = dip_getmeasurefeatures;
% Remove private elements from list - This is Michael's useless creation.
[tmp,I] = intersect({msmts.name},{'BendingEnergy','CCLongestRun','Orientation2D','Anisotropy2D'});
if ~isempty(I)
   msmts(I) = [];
end

%add non-diplib measurements
add_msmts = di_derivedmeasurements;
n = length(msmts);
for ii=1:size(add_msmts,1)
   msmts(n+ii).name = add_msmts{ii,1};
   msmts(n+ii).description = add_msmts{ii,2};
end

disp(' ')
disp('Measurement Features to use in MEASURE:')
disp(' ')
fprintf('%20s   %s\n','Name','Description')
fprintf('%20s---%s\n','-------------','--------------------------------------------------------')
for ii=1:length(msmts)
   fprintf('%20s - %s\n',msmts(ii).name,msmts(ii).description)
end
disp(' ')
disp('Measurements marked with an * require a grey-value input image.')
disp(' ')
