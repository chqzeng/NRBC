%MATLAB_TYPE = DI_MATTYPE(DIP_TYPE)
%    Determines the MATLAB data type associated with the DIPlib
%    data type DIP_TYPE. If DIP_TYPE is unknown, returns 'double'.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 15 November 2002: Fixed binary images to work in MATLAB 6.5 (R13)

function [matlab_type,complexity] = di_mattype(dip_type)
complexity = 0;
switch dip_type
   case {'bin8','bin16','bin32'}
      error('Assertion failed: bin8, bin16 or bin32 still used somewhere!')
   case 'bin'
      matlab_type = 'uint8';
   case 'uint8'
      matlab_type = 'uint8';
   case 'uint16'
      matlab_type = 'uint16';
   case 'uint32'
      matlab_type = 'uint32';
   case 'sint8'
      matlab_type = 'int8';
   case 'sint16'
      matlab_type = 'int16';
   case 'sint32'
      matlab_type = 'int32';
   case 'sfloat'
      matlab_type = 'single';
   case 'dfloat'
      matlab_type = 'double';
   case 'scomplex'
      matlab_type = 'single';
      complexity = 1;
   case 'dcomplex'
      matlab_type = 'double';
      complexity = 1;
   otherwise
      matlab_type = 'double';
end
