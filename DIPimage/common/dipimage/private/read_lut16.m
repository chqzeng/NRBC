function [e, input_table, clut_table, output_table] = read_lut16(fid, icc_off, icc_size)

fseek( fid, icc_off, 'bof');
tagtype = fscanf(fid,'%4c',1);
fscanf( fid,'%4c',1);
%fprintf(1, 'in read_lut16\n');
lut_out = zeros(1, 1);
num_in = fread(fid, 1, 'uint8');
num_out = fread(fid, 1, 'uint8');
num_clut = fread(fid, 1, 'uint8');
fread(fid, 1, 'uint8');
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

entries_in = fread(fid,1,'uint16');
entries_out = fread(fid,1,'uint16');

input_table = zeros( entries_in, num_in);
output_table = zeros( entries_out, num_out);
for i=1:(entries_in*num_in)
   input_table(i) = fread(fid,1,'uint16');
end
values = [0:entries_in-1]'./(entries_in-1);

input_table = [values input_table./(2.^16-1)];

clut_table = zeros(num_out, num_clut.^num_in);
for(i=1:num_clut.^num_in.*num_out)
   clut_table(i) = fread(fid,1,'uint16')/(2.^16-1);
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

for i=1:(entries_out*num_out)
   output_table(i) = fread(fid,1,'uint16');
end
values = [0:entries_out-1]'./(entries_out-1);
output_table = [values output_table./(2.^16-1)];
