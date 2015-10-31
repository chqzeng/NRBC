%OUT_TYPE = DI_FINDTYPE(IN1_TYPE,IN2_TYPE)
%    Determines the output type that should be used for any
%    operation between data of types IN1_TYPE and IN2_TYPE.
%
% Note: There is no extended checking. So unknown data types can
% pass unnoticed. This should not be a problem, since this function
% is private.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 1999.
% October 1999: separated this function from private/doinputs.m
% 7 April 2000: this function doesn't return integer types any more.
% 15 November 2002: Fixed binary images to work in MATLAB 6.5 (R13)

function out_type = di_findtype(in1_type,in2_type)
if strcmp(in1_type,'dcomplex') | strcmp(in2_type,'dcomplex')
   out_type = 'dcomplex';
elseif strcmp(in1_type,'scomplex') | strcmp(in2_type,'scomplex')
   if strcmp(in1_type,'dfloat') | strcmp(in2_type,'dfloat')
      out_type = 'dcomplex';
   else
      out_type = 'scomplex';
   end
elseif strcmp(in1_type,'dfloat') | strcmp(in2_type,'dfloat')
   out_type = 'dfloat';
elseif strcmp(in1_type,'bin') & strcmp(in2_type,'bin')
   out_type = 'bin';
else
   out_type = 'sfloat';
end
