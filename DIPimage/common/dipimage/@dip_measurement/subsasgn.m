%SUBSASGN   Overloaded operator for a.name=b.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 5 February 2002:   Measurement names are not case-sensitive any more.
% February 2008:     Added possibilty to change the structure, addition of 
%                    of non-diplib measurements (BR)
% 6 March 2008:      Allowing addition of arbitrary measurements. Not allowing
%                    changing of measurement values. See new method RMFIELD.
% 18 December 2009:  Added 'axes' and 'units' elements.

function a = subsasgn(a,s,b)
if length(s)==1 & strcmp(s.type,'.')
   name = s.subs;
   if strcmpi(name,'ID')
      % Change Label IDs for the measured objects.
      % All must change at the same time:
      if ~isnumeric(b) | length(size(b))~=2 | prod(size(b))~=length(a.id) | any(mod(b,1))
         error('Invalid label ID array.')
      end
      a.id = reshape(b,1,prod(size(b)));
      return
   elseif strcmpi(name,'prefix')
      % Prefix names with b.
      if ~ischar(b) | size(b,1)~=1
         error('Invalid prefix.')
      end
      for ii=1:length(a.names)
         a.names{ii} = [b,a.names{ii}];
      end
      return
   elseif ~any(strcmpi(name,a.names))
      % Add field 'name' with value b.
      if ~isnumeric(b) | length(size(b))~=2
         error('Invalid data array.')
      end
      % Removed 29-10-2010 MvG : a N-valued measurement such as
      %                          'DimensionsEllipsoid' on a single object
      %                          becomes a single-valued for N objects.
      %                          Checked whether any existing measurement
      %                          depends on the old behaviour by running
      %                          measure('all') on an image with a single
      %                          object and on 'cermet'<128.
      %if size(b,2)==1
      %   b = b';
      %end                       Enf of edit
      if size(b,2)~=length(a.id)
         error('Data array of incorrect size.')
      end
      n = length(a.names)+1;
      a.names{n} = name;
      a.data{n} = b;
      M = size(b,1);
      a.axes{n} = cell(M,1);
      for ii=1:M
         a.axes{n}{ii} = num2str(ii);
      end
      a.units{n} = cell(M,1);
      a.units{n}(:) = {'unknown'};
      return
   end
end
error('Do not mess with the dip_measurement object!')
