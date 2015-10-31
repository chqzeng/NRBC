%READGREYIM   Read grey  image from file

function varargout = readgrayim(varargin)
varargout = cell(1,max(nargout,1));
[varargout{:}] = readim(varargin{:});

