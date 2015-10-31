function text_out = read_txt(fid, icc_off, icc_size, printval)

if nargin < 4
   printval = 0;
end
fseek(fid,icc_off,'bof');
tagtype = fscanf(fid,'%4c',1);
fscanf(fid,'%4c',1); % extra zeros;
s = sprintf('%%%dc', icc_size-8);
text_out = fscanf(fid,s,1);
if printval == 1
   fprintf(1, '%s\n', text_out);
end
