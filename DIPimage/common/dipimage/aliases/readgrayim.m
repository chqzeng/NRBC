%READGRAYIM   Read gray-value image from file
% Mimics the old functionality of readim

function varargout = readgrayim(varargin)
varargout = cell(1,max(nargout,1));
[varargout{:}] = readim(varargin{:});
varargout{1} = colorspace(varargout{1},'gray');
