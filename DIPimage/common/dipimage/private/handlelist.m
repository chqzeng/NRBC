%HANDLELIST   Returns a list of handles and titles for the selected type.
%   [HANDLES,TITLES] = HANDLELIST(SELECTION), with SELECTION a cell array
%   with strings or a single string, each string representing a substring
%   of the Tag element of the figure windows to return data about. TITLES
%   is a cell array with strings.
%
%   Only handles for figure windows created by DIPSHOW are returned.
%
%   Examples for SELECTION:
%      {'2D','3D'}
%      {'Color','Grey','Binary'}
%      {'1D_Color','2D_Binary','3D_Grey'}
%   SELECTION is not case-sensitive.

% (C) Copyright 1999-2014               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, September 2001.
% (Substitutes common code in DIPIMAGE and HANDLESELECT, now also used by TESTPARAM.)
% 11 August 2014: Fix for new graphics in MATLAB 8.4 (R2014b).

function [handles,titles] = handlelist(selection)

if nargin==0 | isempty(selection)
   selection = '';
elseif ~ischar(selection) & ~iscellstr(selection)
   error('Invalid SELECTION parameter.')
end

% Get list of defined handles
handles = get(0,'Children');
if matlabver_ge([8,4])
	handles = [handles.Number];
end
if ~isempty(handles)
   tags = get(handles,'Tag');
   I = strncmp(tags,'DIP_Image',9);
   handles = handles(I);
   if ~isempty(handles)
      if ~isempty(selection)
         if length(I)>1, tags = tags(I); end % else Tags is a string, not a cell array!
         I = contain(lower(tags),lower(selection));
         handles = handles(I);
      end
      if nargout>1
         N = length(handles);
         if N>0
            titles = get(handles,'name');
            if N==1, titles = {titles}; end
            for ii=1:N
               if ~isempty(titles{ii})
                  titles{ii} = ['Figure No. ',num2str(handles(ii)),': ',titles{ii}];
               else
                  titles{ii} = ['Figure No. ',num2str(handles(ii))];
               end
            end
            [titles,I] = sort(titles);
            handles = handles(I);
         end
      end
   end
end
if nargout>1 & isempty(handles)
   titles = {};
end

% Returns true for each element in str1 that contains any of str2
function res = contain(str1,str2)
if iscell(str1)
   N = prod(size(str1));
   res = logical(zeros(N,1));
   for ii=1:N
      res(ii) = contains(str1{ii},str2);
   end
else
   res = contains(str1,str2);
end

% Returns true if str1 contains any of str2
function res = contains(str1,str2)
if iscell(str2)
   res = 0;
   for ii=1:prod(size(str2))
      res = res | ~isempty(findstr(str1,str2{ii}));
      if res, return, end
   end
else
   res = ~isempty(findstr(str1,str2));
end
