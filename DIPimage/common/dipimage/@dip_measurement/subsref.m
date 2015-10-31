%SUBSREF   Overloaded operator for b=a(i).name.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 1 December 2000:   Fixed bug in referencing label ID's.
% 5 February 2002:   Measurement names are not case-sensitive any more.
% 13 September 2007: New method to index label ID's. Much, much faster.
% 18 December 2009:  Added 'axes' and 'units' elements.
% 9 April 2010:      Further fix to the indexing of label ID's, in case of very large ID's.
% 7 Septebmer 2011:  Fixed bug preventing the use of logical arrays to index (Petr Matula).

function out = subsref(in,s)
N = length(s);
ii = 1;
out = in;
if strcmp(s(ii).type,'()')
   % Select objects
   I = s(ii).subs;
   if length(I) ~= 1
      try
         I = cat(2,I{:});
      catch
         error('Illegal indexing.')
      end
   else
      I = I{1};
   end
   if ~(islogical(I) | isnumeric(I)) | length(I) ~= prod(size(I)) | isempty(I)
      error('Illegal indexing.')
   end
   I = I(:); % Make sure it is a column vector
   if islogical(I)
      if length(I) ~= length(out.id)
         error('Incorrect indexing array.')
      end
      out.id = out.id(I);
      for jj=1:length(out.data)
         out.data{jj} = out.data{jj}(:,I);
      end
   else
      if any(~ismember(I,out.id))
         error('Object ID not available.')
      end
      %  Old method:
      %[I,J] = find((repmat(I,1,length(out.id)) == repmat(out.id,length(I),1))');
      %  Newer method: (much, much faster)
      %lut = []; lut(out.id) = 1:length(out.id);
      %I = lut(I);
      %  Newest method: (avoids out-of memory problems when there's ridiculously large ID values)
      %  [Note the shape of the matrix: only columns are sparse, not rows! A row vector will ocupy
      %  as much space being sparse as being full.]
      lut = sparse(out.id,ones(size(out.id)),1:length(out.id));
      I = full(lut(I));
      %
      out.id = out.id(I);
      for jj=1:length(out.data)
         out.data{jj} = out.data{jj}(:,I);
      end
   end
   ii = ii+1;
end
if ii>N, return, end
if strcmp(s(ii).type,'.')
   % Select measurement
   name = s(ii).subs;
   if strcmpi(name,'ID')
      out = out.id;
   else
      I = find(strcmpi(name,out.names));
      if isempty(I)
         error('Measurement not available.')
      end
      out = out.data{I(1)};
   end
   ii = ii+1;
   if ii>N, return, end
   % Some other referencing being done on the result. Let MATLAB handle it...
   try
      out = subsref(out,s(ii:N));
   catch
      error(lasterr);
   end
elseif ii<=N
   % There are no more indexing operations posible...
   error('Illegal indexing operation.');
end
