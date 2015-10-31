%P = CONVERTPATH(P)
%    Converts the string P into a cell array.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, March 2001.
% 10 April 2008: Moved from GETIMAGEFILEPATH to CONVERTPATH. Generalized by
%                adding input parameter instead of always using 'imagefilepath'.
%    p = getimagefilepath;   ==>   p = convertpath(dipgetpref('imagefilepath'));

function out = convertpath(p)
out = {};
ii = 1;
while ~isempty(p)
   I = find(p==pathsep);
   if isempty(I)
      out{ii} = p;
      break;
   else
      out{ii} = p(1:I-1);
      p = p(I+1:end);
      ii = ii+1;
   end
end
% Remove trailing file separator to avoid problems in DIPimage GUI.
for ii=1:length(out)
   if out{ii}(end) == filesep
      out{ii}(end) = [];
   end
end
