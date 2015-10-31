function XYZ = read_XYZ(fid, icc_off, icc_size, printval)

if nargin < 4
   printval = 0;
end
fseek(fid,icc_off,'bof');
tagtype = fscanf(fid,'%4c',1);
fscanf(fid,'%4c',1);
X = fread(fid,1,'int32')/2^16;
Y = fread(fid,1,'int32')/2^16;
Z = fread(fid,1,'int32')/2^16;
if( printval == 1)
   fprintf(1, 'offset in read_XYZ = %d\n', icc_off);
   fprintf(1, 'XYZ = %f %f %f\n', X, Y, Z);
end
XYZ = [X Y Z];
