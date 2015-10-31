%OUT_TYPE = DI_FORCEDATATYPE(IN1_TYPE,IN2_TYPE)
%    Determines the output type that should be used for any
%    operation between data of types IN1_TYPE and IN2_TYPE
%    in the case the dipimage preference 'KeepDataType' is set 
%    to 'yes'.
%
%    If both inputs are of type dip_image then the output has
%    the type which uses  more bits to represent the data

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, November 2013

function out_type = di_findtype(in1, in2)
dipimageDT = {'bin','uint8','uint16','uint32','sint8','sint16','sint32',...
               'sfloat','dfloat'};
dipimageDT_sort = [2,8,16,32,9,17,33,34,64];

%one of the inputs must be dip_image type
bothDIP = 1;
if ~strcmp(class(in1),'dip_image')
   in1DT = di_diptype(in1);
   in2DT = in2.dip_type;
   bothDIP = 0; 
elseif ~strcmp(class(in2),'dip_image')
   in1DT = di_diptype(in2);
   in2DT = in1.dip_type;
   bothDIP=0;
end

if bothDIP
   in1DT = in1.dip_type;
   in2DT = in2.dip_type;
   if ~isempty(strfind(in1DT,'complex')) || ~isempty(strfind(in2DT,'complex'))
   %complex
      if strcmp(in1DT,'dcomplex') | strcmp(in2DT,'dcomplex')
         out_type = 'dcomplex';
      elseif strcmp(in1DT,'scomplex') | strcmp(in2DT,'scomplex')
         if strcmp(in1DT,'dfloat') | strcmp(in2DT,'dfloat')
            out_type = 'dcomplex';
         else
            out_type = 'scomplex';
         end
      end
   else
   %real only
      id1 = strmatch(in1DT, dipimageDT);
      id2 = strmatch(in2DT, dipimageDT);
      tmp = max(dipimageDT_sort(id1),dipimageDT_sort(id2));
      tmp = find(tmp==dipimageDT_sort);
      out_type = dipimageDT{tmp};
   end
else
% one is matlab datatype in1DT
% check complex
   if ~isempty(strfind(in1DT,'complex')) || ~isempty(strfind(in2DT,'complex'))
      if strcmp(in1DT,'dcomplex') | strcmp(in2DT,'dcomplex')
         out_type = 'dcomplex';
      elseif strcmp(in1DT,'scomplex') | strcmp(in2DT,'scomplex')
         if strcmp(in1DT,'dfloat') | strcmp(in2DT,'dfloat')
            out_type = 'dcomplex';
         else
            out_type = 'scomplex';
         end
      end
   else
   % both real
   %this rarely is the case that the matlab variable is not of type double
      id1 = strmatch(in1DT, dipimageDT); %matlabtype
      id2 = strmatch(in2DT, dipimageDT);
      if id1-id2== -1;
         out_type = in1DT;
      else
         out_type = in2DT;
      end
      
   end
end
