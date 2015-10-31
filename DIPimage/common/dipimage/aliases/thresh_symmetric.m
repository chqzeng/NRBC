%THRESH_SYMMETRIC   Alias for THRESHOLD('background').

function out = thresh_symmetric(in,param)
out = threshold(in,'background',param);
