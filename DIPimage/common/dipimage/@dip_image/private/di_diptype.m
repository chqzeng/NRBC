%DIP_TYPE = DI_DIPTYPE(IN)
%    Determines the DIPlib data type associated with the data type
%    of the array IN.
%
%    If IN is a string representation of a data type name, returns
%    the DIPlib data type that best matches, or generates an error
%    if the string is not a valid data type.
%
% Note: There is no extended checking. So unknown data types can
% pass unnoticed (as will non-numeric types). This should not be a
% problem, since this function is private.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 15 November 2002: Fixed binary images to work in MATLAB 6.5 (R13)
% 20 August 2008:   Extended to include some code from DIP_IMAGE we
%                   need to use in DIP_ARRAY.

function dip_type = di_diptype(in)
if islogical(in)
   dip_type = 'bin';
elseif isnumeric(in)
   dip_type = class(in);
   if ~isreal(in)
      if strcmp(dip_type,'double')
         dip_type = 'dcomplex';
      else
         dip_type = 'scomplex';
      end
   end
elseif ischar(in)
   dip_type = in;
else
   error('Illegal input')
end

switch dip_type
   case {'bin8','bin16','bin32'}
      dip_type = 'bin';
   case 'uint'
      dip_type = 'uint32';
   case 'int'
      dip_type = 'sint32';
   case 'int8'
      dip_type = 'sint8';
   case 'int16'
      dip_type = 'sint16';
   case 'int32'
      dip_type = 'sint32';
   case {'single','float'}
      dip_type = 'sfloat';
   case 'double'
      dip_type = 'dfloat';
   case 'complex'
      dip_type = 'dcomplex';
end
allowed_types = {'bin','uint8','uint16','uint32','sint8','sint16','sint32',...
               'sfloat','dfloat','scomplex','dcomplex'};
if ~any(strcmp(dip_type,allowed_types))
   error('Unknown dip_type.')
end
