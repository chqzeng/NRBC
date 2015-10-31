%STRUCT   Convert dip_measurement object to struct matrix.
%   A = STRUCT(B) converts the measurement data B to a structure
%   in the form:
%      B(ii).id       = Label (numeric) for object ii.
%      B(ii).msrname1 = Result of measurement 1 on object ii.
%      B(ii).msrname2 = Result of measurement 2 on object ii.
%      B(ii).msrname3 = ...
%          ...
%
%   If A is a dip_measurement structure, then
%   A == DIP_MEASUREMENT(STRUCT(A)).

% (C) Copyright 1999-2005               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 1 September 2005 - corrected bug: one empty 'ID' field was created.

function out = struct(in)
fn = {'id',in.names{:}};
fn = [fn;cell(1,length(fn))];
out = struct(fn{:});
out = repmat(out,length(in.id),1);
for ii=1:length(in.id)
   out(ii).id = in.id(ii);
   for jj=1:length(in.names)
      out = setfield(out,{ii},in.names{jj},in.data{jj}(:,ii));
   end
end
