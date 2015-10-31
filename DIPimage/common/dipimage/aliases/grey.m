% GREY   Alias for GRAY

function varargout = grey(varargin)
varargout = cell(1,max(nargout,1));
[varargout{:}] = gray(varargin{:});

