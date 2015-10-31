%FIXLSMFILE   Fix an LSM file so that it can be read by READIM
%
%  When a Zeiss LSM file with a single channel is written to file, and
%  the Zeiss software was set to display this image with a palette
%  selected (such as "range indicator"), the resulting file does not
%  conform to the TIFF standard (the LSM file format is built ontop of
%  this standard). In this case, the routines used by READIM will
%  refuse to read in more than one plane in the best of cases, or
%  completely refuse to open the file in the worst of them. Calling
%  FIXLSMFILE on this file will fix it so that it can be read. This
%  function changes the input file. After the alteration, the file
%  will be still be opened (apparently unaltered) by the Zeiss LSM
%  Image Browser.
%
% SYNOPSIS:
%  fixlsmfile [options,] filename [,filename,filename,...]
%
% PARAMETERS:
%  options:  -v    verbose error output
%            -q    for quiet mode
%  filename: name of file, including full or relative path and extension.
%
% NOTE:
%  This function changes the file given as an argument!

% (C) Copyright 2004-2009, All rights reserved
% Cris Luengo, June 2005.
