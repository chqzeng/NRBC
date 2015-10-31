%PLOT   plots a one dimensional image
%   This function simply converts all dip_image objects in the input
%   to DOUBLE and passes on all the arguments to PLOT.

% (C) Copyright 2002-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
%Bernd Rieger, Cris Luengo, Sep 2002

function out = plot(varargin)
for ii=1:nargin
   if di_isdipimobj(varargin{ii});
      varargin{ii}=double(varargin{ii});
   end
end

if nargout
   out = plot(varargin{:});
else
   plot(varargin{:});
end
