function [e, input_table, clut_table, output_table] = read_lut8(fid, icc_off, icc_size)

% fprintf(1, 'in read_lut8\n');
fseek( fid, icc_off, 'bof');
tagtype = fscanf(fid,'%4c',1);
fscanf( fid,'%4c',1);
num_in = fread(fid, 1, 'uint8');
num_out = fread(fid, 1, 'uint8');
num_clut = fread(fid, 1, 'uint8');
fread(fid, 1, 'uint8');
% fprintf(1, 'num_in = %d, num_out = %d, num_clut = %d\n', num_in, num_out, num_clut);
e = zeros(3, 3);
e(1, 1) = fread(fid,1,'int32')/2^16;
e(1, 2) = fread(fid,1,'int32')/2^16;
e(1, 3) = fread(fid,1,'int32')/2^16;
e(2, 1) = fread(fid,1,'int32')/2^16;
e(2, 2) = fread(fid,1,'int32')/2^16;
e(2, 3) = fread(fid,1,'int32')/2^16;
e(3, 1) = fread(fid,1,'int32')/2^16;
e(3, 2) = fread(fid,1,'int32')/2^16;
e(3, 3) = fread(fid,1,'int32')/2^16;

input_table = zeros(256, num_in);
output_table = zeros(256, num_out);
for(i=1:256*num_in)
   input_table(i) = fread(fid,1,'uint8')/255;
end
input_table = [[0:255]' input_table];

clut_table = zeros(num_out, num_clut.^num_in);
for(i=1:num_clut.^num_in.*num_out)
   clut_table(i) = fread(fid,1,'uint8')/255;
end
clut_table = clut_table';
x = [0:(num_clut-1)]';
y = zeros(num_clut.^num_in, num_in);
if( num_in == 1)
   y = x;
end
if( num_in == 3)
   for i=1:num_clut
      y(1+(i-1)*num_clut:num_clut*i, 2) = i-1;
      y(1+(i-1)*num_clut:num_clut*i, 3) = x;
   end
   for i=1:num_clut
      y(1+(i-1)*num_clut.^2:num_clut.^2*i, 1) = i-1;
      y(1+(i-1)*num_clut.^2:num_clut.^2*i, 2:3) = y(1:num_clut.^2, 2:3);
   end
end
if( num_in == 4)
   for i=1:num_clut
      y(1+(i-1)*num_clut:num_clut*i, 3) = i-1;
      y(1+(i-1)*num_clut:num_clut*i, 4) = x;
   end
   for i=1:num_clut
      y(1+(i-1)*num_clut.^2:num_clut.^2*i, 2) = i-1;
      y(1+(i-1)*num_clut.^2:num_clut.^2*i, 3:4) = y(1:num_clut.^2, 3:4);
   end
   for i=1:num_clut
      y(1+(i-1)*num_clut.^3:num_clut.^3*i, 1) = i-1;
      y(1+(i-1)*num_clut.^3:num_clut.^3*i, 2:4) = y(1:num_clut.^3, 2:4);
   end
end
y = y./(num_clut-1);
clut_table = [y clut_table];
for(i=1:256*num_out)
   output_table(i) = fread(fid,1,'uint8')/255;
end
output_table = [[0:255]' output_table]; 
