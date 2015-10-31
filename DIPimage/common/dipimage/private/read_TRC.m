function [out, tagtype] = read_TRC(fid, icc_off, icc_size, printval)

if nargin < 4
   printval = 0;
end
fseek(fid,icc_off,'bof');
tagtype = fscanf(fid,'%4c',1);
%fprintf(1, 'The type of data is curve\n');
fscanf(fid,'%4c',1);

if( tagtype == 'curv');
   entries=fread(fid,1,'uint32');
   if( entries == 0)
      if( printval == 1)
         fprintf(1, 'The curve is linear\n');
      end
      out = 1;
   elseif( entries == 1)
      gammaval = fread(fid, 1, 'uint16')./2.^8;
      if( printval == 1)
         fprintf(1, 'The curve is a gamma curve with gamma = %f\n', gammaval);
      end
      out = gammaval;   
   else
      mymatrix=[1:entries]';
      for ii=1:entries
         mymatrix(ii)=fread(fid,1,'uint16');
      end
      if( printval == 1)
         fprintf(1, 'The curve is a lookup table with %d elements\n', entries);
      end
      out = mymatrix./2.^16;
   end
elseif( tagtype == 'para');
   function_type = fread(fid,1,'uint16');
   fread(fid,1,'uint16');
   if( printval == 1)
      fprintf(1, 'The curve is a parametric curve with %d elements\n', ...
      function_type);
   end
   switch function_type
      case 0
         out = fread(fid,1,'int32')/2^16;
      case 1
         out(1) = fread(fid,1,'int32')/2^16;
         out(2) = fread(fid,1,'int32')/2^16;
         out(3) = fread(fid,1,'int32')/2^16;   
      case 2
         out(1) = fread(fid,1,'int32')/2^16;
         out(2) = fread(fid,1,'int32')/2^16;
         out(3) = fread(fid,1,'int32')/2^16;   
         out(4) = fread(fid,1,'int32')/2^16;
      case 3
         out(1) = fread(fid,1,'int32')/2^16;
         out(2) = fread(fid,1,'int32')/2^16;
         out(3) = fread(fid,1,'int32')/2^16;   
         out(4) = fread(fid,1,'int32')/2^16;
         out(5) = fread(fid,1,'int32')/2^16;
      case 4
         out(1) = fread(fid,1,'int32')/2^16;
         out(2) = fread(fid,1,'int32')/2^16;
         out(3) = fread(fid,1,'int32')/2^16;   
         out(4) = fread(fid,1,'int32')/2^16;
         out(5) = fread(fid,1,'int32')/2^16;
         out(6) = fread(fid,1,'int32')/2^16;   
   end
end
