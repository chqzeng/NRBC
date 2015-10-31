%DATASET   Convert measurement data to a PRTOOLS dataset.
%   D = DATASET(M) converts the measurements in M into a dataset
%   object, each measurement being a feature.
%
%   D = DATASET(M,LABELS) uses the given LABELS to label the
%   dataset.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, September 2000.

function out = dataset(in,labels)
if nargin < 2
   labels = ones(size(in.id));
else
   if ~isa(in,'dip_measurement')
      error('First parameter must be a dip_measurement object.')
   end
end
labels = labels(:);
data = cat(1,in.data{:})';
fn = in.names;
featlist = cell(1,size(data,2));
jj = 1;
for ii=1:length(fn)
   d = in.data{ii};
   N = size(d,1);
   if N > 1
      index = sprintf(['%.',num2str(ceil(log10(N+1))),'d'],(1:N)');
      index = reshape(index,length(index)/N,N)';
      for kk=1:N
         featlist{jj} = [fn{ii},index(kk,:)];
         jj = jj+1;
      end
   else
      featlist{jj} = fn{ii};
      jj = jj+1;
   end
end
out = dataset(data,labels,strvcat(featlist{:}));
