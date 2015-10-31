%OUT_TYPE = DI_FINDTYPEX(IN1_TYPE,IN2_TYPE)
%    Determines the output type that should be used for
%    concatenation between data of types IN1_TYPE and IN2_TYPE.
%
% Note: There is no extended checking. So unknown data types can
% pass unnoticed. This should not be a problem, since this function
% is private.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 24 May 2000: Recovered this code from the old version of FINDTYPE.
% 15 November 2002: Fixed binary images to work in MATLAB 6.5 (R13)
% 7 April 2009: When combining, e.g. uint8 and sint8, the output must
%               be sint16 to hold all posible input values.

function out_type = di_findtypex(in1_type,in2_type)

if strcmp(in1_type,in2_type)
   % Same type
   out_type = in1_type;
else
   % Different types
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
   elseif strcmp(in1_type,'sfloat') | strcmp(in2_type,'sfloat')
      out_type = 'sfloat';
   elseif strcmp(in1_type,'bin') & strcmp(in2_type,'bin')
      out_type = 'bin';
   else
      % All that is left now is SINTxx or UINTxx
      if strcmp(in1_type,'bin')
         in1_type = 'uint1'; % ficticious type, trust me, it works...
      end
      if strcmp(in2_type,'bin')
         in2_type = 'uint1'; % ficticious type, trust me, it works...
      end
      if length(in1_type)<5 | ~strcmp(in1_type(2:4),'int') | ...
         length(in2_type)<5 | ~strcmp(in2_type(2:4),'int')
         error('Unkown image types.')
      end
      int1_len = str2num(in1_type(5:end));
      int1_signed = in1_type(1)=='s';
      int2_len = str2num(in2_type(5:end));
      int2_signed = in2_type(1)=='s';
      if int1_signed & int2_signed
         % both signed
         out_type = ['sint',num2str(max(int1_len,int2_len))];
      elseif ~int1_signed & ~int2_signed
         % both unsigned
         out_type = ['uint',num2str(max(int1_len,int2_len))];
      else
         % combining signed and unsigned
         if int1_signed
            slen = int1_len;
            ulen = int2_len;
         else
            ulen = int1_len;
            slen = int2_len;
         end
         if slen>ulen
            out_type = ['sint',num2str(slen)];
         else
            len = max(slen,ulen);
            if len==8
               out_type = 'sint16';
            elseif len==16
               out_type = 'sint32';
            else
               out_type = 'sfloat';
            end
         end
      end
   end
end

%%%% TEST CODE:
% dt = {'bin','uint8','uint16','uint32','sint8','sint16','sint32','sfloat','dfloat','scomplex','dcomplex'};
% N = length(dt); res = cell(N,N);
% for ii=1:N, for jj=1:N, res{ii,jj} = di_findtypex(dt{ii},dt{jj}); end, end
%%%%
