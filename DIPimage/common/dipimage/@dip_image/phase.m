%PHASE  Phase angle.
%   PHASE(B) returns the phase angles, in radians, of a complex
%   image. This is the same as the MATLAB command ANGLE.
%
%   See also ANGLE, ABS, UNWRAP.

function img = phase(img)
img = angle(img);
