%FAST_STR2DOUBLE   A faster version of str2double()
%
% SYNOPSIS:
%  str_out = fast_str2double(str_in)
%
% NOTES:
%   1. fast_str2double is based on the C library's strtod() function
%   2. it cannot deal with complex numbers
%   3. like C's strtod(), it accepts hexadecimal numbers (e.g. 0xAA)
%      as valid input.
