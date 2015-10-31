%MTIMES   Overloaded operator for a*b.

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger & Cris Luengo, July 2000.
% 18 December 2001: Color information is not as volatile anymore.
% 10 March 2008:    Fixed 'undefined variable COL' error.
% 24 June 2011:     New version of COMPUTE2. Using PREPARETENSORS. (CL)
% 26 September 2011: Computations done by DIPlib. (CL)

function out = mtimes(in1,in2)
try
   [tensorop,in1,in2] = preparetensors(in1,in2);
   if tensorop
      out = mtimes_array(in1,in2);
   else
      out_type = '';
      if dipgetpref('KeepDataType')
         out_type = di_forcedatatype(in1,in2);
      end
      out = compute2('dip_mul',in1,in2,out_type);
   end
catch
   error(di_firsterr)
end

function out = mtimes_array(in1,in2)
% Matrix multiplication for dip_image_arrays.
% out(j,k) = sum[i]( in1(j,i) * in2(i,k) )
s1 = imarsize(in1);
s2 = imarsize(in2);
if length(s1)~=2 | length(s2)~=2
   error('Matrix multiplication only defined for 2D tensors.');
elseif s1(2) == s2(1)
   col1 = in1(1).color;
   col2 = in2(1).color;
   if isempty(col1)
      if isempty(col2)
         col = '';
      else
         col = col2;
      end
   else
      if isempty(col2)
         col = col1;
      else
         if strcmp(col1.space,col2.space)
            col = col1;
         else
            warning('Color spaces do not match: removing color space information.')
            col = '';
         end
      end
   end
   out_type = ''; % all images must have the same data_type
   if dipgetpref('KeepDataType')
       out_type = di_forcedatatype(in1(1,1),in2(1,1));
    end

   I = s1(2);
   J = s1(1);
   K = s2(2);
   out = dip_image('array',[J,K]);
   for kk = 1:K
      for jj = 1:J
         out(jj,kk) = compute2('dip_mul',in1(jj,1),in2(1,kk),out_type);
         out(jj,kk).color = col;
         for ii = 2:I
            tmp = compute2('dip_mul',in1(jj,ii),in2(ii,kk),out_type);
            out(jj,kk) = out(jj,kk)+tmp;
            out(jj,kk).color = col;
         end
      end
   end
else
   error('Inner tensor dimensions must agree.')
end
