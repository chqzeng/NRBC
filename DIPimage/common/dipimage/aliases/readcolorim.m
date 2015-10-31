%READCOLORIM   Read color image from file
% before separate function, now integrated into readim (BR)

function varargout = readcolorim(varargin)
varargout = cell(1,max(nargout,1));
[varargout{:}] = readim(varargin{:});
