%THRESH   Alias for THRESHOLD with fixed value.

function out = thresh(in,value)

if nargin<2 | prod(size(value))~=1 | ~isfinite(value)
   value = (max(in) + min(in))/2;
end

out = in >= value;
