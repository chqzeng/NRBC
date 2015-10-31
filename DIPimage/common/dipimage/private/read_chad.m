function out = read_chad(fid, icc_off, icc_size)

fseek(fid,icc_off,'bof');
fscanf(fid,'%4c',1);
fscanf(fid,'%4c',1);
out = zeros(3, 3);
out(1, 1) = fread(fid,1,'uint32')/2^16;
out(1, 2) = fread(fid,1,'uint32')/2^16;
out(1, 3) = fread(fid,1,'uint32')/2^16;
out(2, 1) = fread(fid,1,'uint32')/2^16;
out(2, 2) = fread(fid,1,'uint32')/2^16;
out(2, 3) = fread(fid,1,'uint32')/2^16;
out(3, 1) = fread(fid,1,'uint32')/2^16;
out(3, 2) = fread(fid,1,'uint32')/2^16;
out(3, 3) = fread(fid,1,'uint32')/2^16;
