function [A, B, M, e, clut_table] = read_lutA2B(fid, icc_off, icc_size)

fprintf(1, 'in read_lutA2B\n');
num_in = fread(fid, 1, 'uint8');
num_out = fread(fid, 1, 'uint8');
fread(fid, 1, 'uint16');
B_off = fread(fid, 1, 'uint32');
matrix_off = fread(fid, 1, 'uint32');
M_off = fread(fid, 1, 'uint32');
clut_off = fread(fid, 1, 'uint32');
A_off = fread(fid, 1, 'uint32');

% Read A

% gaat niet goed. Twee vragen: hoe weet ik hoe groot iedere curve is -> daarvoor
% comprenseren
% Is deze offset tov het begin van de file of top van het begin van de tag (ik
% denk het eerste 
if A_off ~= 0
   for i=1:num_out 
      A{i} = read_TRC( fid, A_off);
   end
end

% read the CLUT
if clut_off ~=0
   fseek(fid, clut_off, 'bof');
   num_clut = 1;
   for i=1:num_in
      dim(i) = fread( fid, 1, 'uint8'); 
      num_clut = num_clut.*dim(i);
   end

   for i = (num_in+1):16
      fread( fid, 1, 'uint8');
   end

   precision = fread(fid,1,'uint8');
   fread(fid, 1, 'uint8');
   fread(fid, 1, 'uint8');
   fread(fid, 1, 'uint8');

   if precision == 1 % uint8
      for i=1:num_clut.*num_out
         clut_table(i) = fread(fid,1,'uint8')/(2.^8-1); 
      end
   else               % uint16
      for i=1:num_clut.*num_out
         clut_table(i) = fread(fid,1,'uint16')/(2.^16-1); 
      end
   end
end

% Read M
% see comment with A
if M_off ~=0
   for i=1:num_in
      M{i} = read_TRC( fid, M_off);
   end
end

% read matrix

if matrix_off ~=0
   fseek(fid, matrix_off, 'bof');
   e = zeros(3, 4);
   e(1, 1) = fread(fid,1,'int32')/2^16;
   e(1, 2) = fread(fid,1,'int32')/2^16;
   e(1, 3) = fread(fid,1,'int32')/2^16;
   e(2, 1) = fread(fid,1,'int32')/2^16;
   e(2, 2) = fread(fid,1,'int32')/2^16;
   e(2, 3) = fread(fid,1,'int32')/2^16;
   e(3, 1) = fread(fid,1,'int32')/2^16;
   e(3, 2) = fread(fid,1,'int32')/2^16;
   e(3, 3) = fread(fid,1,'int32')/2^16;
   e(4, 1) = fread(fid,1,'int32')/2^16;
   e(4, 2) = fread(fid,1,'int32')/2^16;
   e(4, 3) = fread(fid,1,'int32')/2^16;
end
% Read B
% see comment with A
if b_off ~=0
   for i=1:num_in
      B{i} = read_TRC( fid, B_off);
   end
end
