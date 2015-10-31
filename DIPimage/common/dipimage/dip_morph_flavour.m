%DIP_MORPH_FLAVOUR   Sets or gets the morphological flavour
%   DIP_MORPH_FLAVOUR('name') sets the morphological flavour to 'name'
%   'name' is one of 'Serra' or 'Heijmans'. The default is 'Serra'.
%   Note that the low-level DIPlib functions always follow the 'Serra'
%   definition.
%
%   These are the differences in morphological operations when changing
%   the flavour:
%
%               | Serra, Soille      | Heijmans, Haralick
%   ======================================================
%   erosion     | minf(a,b)          | minf(a,b)
%   ------------+--------------------+--------------------
%   dilation    | maxf(a,b)          | maxf(a,-b)
%   ------------+--------------------+--------------------
%   opening     | maxf(minf(a,b),-b) | maxf(minf(a,b),-b)
%   ------------+--------------------+--------------------
%   closing     | minf(maxf(a,b),-b) | minf(maxf(a,-b),b)
%   ------------------------------------------------------
%
%   Note that '-b' means MIRROR(B). These differences are only significant for
%   non-symmetric SEs, and therefore only influence the functions DILATION_SE,
%   CLOSING_SE and RANKMIN_CLOSING_SE.
%
%   DIP_MORPH_FLAVOUR without any input arguments returns the current
%   flavour.

% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February 2002.
% 3 December 2002: The definition we gave Serra was, of course, all wrong. Soille and
%                  Serra are from the same school.
% 20 July 2004:    Corrected a bug in the help.

function out = dip_morph_flavour(in)
% Avoid being in menu
value = 0;
if nargin == 1
   if ischar(in)
      switch lower(in)
         case 'dip_getparamlist'
            out = struct('menu','none');
            return
         case {'soille','serra'}
            value = 0; % any other value does the same...
         case 'heijmans'
            value = 2;
         otherwise
            error('Unkown morphological flavour');
      end
   else
      error('String expected');
   end
   dipsetpref('MorphologicalFlavour',value);
else
   value = dipgetpref('MorphologicalFlavour');
end
if nargout>0 | nargin<1
   switch value
      case 2
         out = 'Heijmans';
      otherwise
         out = 'Serra';
   end
end

% Warning: the integer values associated with these names are used elsewhere too
% (do a search on "dipgetpref('MorphologicalFlavour')" to find these locations)
