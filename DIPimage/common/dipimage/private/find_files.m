%FIND_FILES return sorted files
%
% out = find_files(filebase, ext, start, ending, verbose)
%
%  filebase: string containing the base filename
%  ext     : extension
%  start   : first index to read
%  ending  : last index to read
%  verbose : show diagnostic messages
%
% DEFAUTLS:
%  start  = 0 % start with the first found image
%  ending = 0 % read all found images
%  verbose  = 1

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, April 2004 (based on CL readstack)
% April 2004,     added support for empty extension (BR)
% May 2004,       added error if no files are found (BR)
% September 2004, support for dots in the file name (BR)
% September 2004, Fixed for use of '' as extension parameter, moved trimming of IN
%                 from READTIMESERIES to here; now we're able to read the 'imser?' series.
%                 Also correct use of 'ImageFilePath' preference & using FULLFILE. (CL)
% September 2004, fix Leica timeseries reading (BR)
% November 2004,  added Leica timeseries stuff (BR)
% June 2006,      changed global SupressOutput to parameter VERBOSE (CL)
% April 2009,     Made more flexible, was able to remove specific Leica extension (CL)
% April 2012,     Allowing file names with all digits (CL, after Rodrigo Fernandez Gonzalez)

function out=find_files(in,ext,st,ed,verbose)
if nargin < 5
   verbose = 1;
   if nargin < 4
      ed = 0;
      if nargin < 3
         st = 0;
         if nargin < 2
            ext = '';
         end
      end
   end
end
if ~isempty(ext) & ext(1)~='.'
   ext = ['.',ext];
end

if sum(in=='*')>1
   error('Only one ''*'' wildcard accepted.')
elseif sum(in=='*')==1
   wc = 1;
else
   wc = 0;
end

[pathstr,basename,extension] = fileparts(in);
if ~isempty(ext)
   if ~strcmp(ext,extension) % the extension doesn't match the given one -- it's not the extension
      basename = [basename extension];
      extension = '';
   end
end
if length(extension) > 5 % someone puts dots in the filename
   basename = [basename extension];
   extension = '';
end
if ~isempty(extension) & isempty(ext)
   ext = extension;
end
if wc & ~any(basename=='*')
   error('A wildcard ''*'' is only accepted in the file name, not the extension nor the directory name.')
end

if ~wc
   % remove trailing numbers and substitute them with a '*'
   while ~isempty(basename) & any(basename(end)=='0123456789')
      basename(end) = [];
   end
   basename = [basename,'*'];
end
if ~isempty(ext)
   basename = [basename,ext];
end
fns = dir(fullfile(pathstr,basename));
fns([fns.isdir]) = [];
if isempty(fns) & isempty(pathstr)
   p = convertpath(dipgetpref('imagefilepath'));
   for ii=1:length(p)
      fns = dir(fullfile(p{ii},basename));
      fns([fns.isdir]) = [];
      if ~isempty(fns)
         pathstr = p{ii};
         break;
      end
   end
end
if isempty(fns)
   out = {};
   return;
end

if isempty(ext)
   % No extension given -- let's use the first extension we find!
   [bla,bla,ext] = fileparts(fns(1).name);
   basename = [basename,ext];
end

jj = find(basename=='*');
if length(jj)~=1
   error('assertion failed!')
end
kk = length(basename)-jj;
xx = length(ext)-1;

Nout =  length(fns);
out = cell(1,Nout);
iout = zeros(1,Nout);
for ii=1:Nout
   out{ii} = fns(ii).name;
   if ~strcmp(out{ii}(end-xx:end),ext)
      iout(ii) = -1;
   else
      iout(ii) = str2double(out{ii}(jj:end-kk));
      if isnan(iout(ii))
         iout(ii) = -1;
      end
   end
   out{ii} = fullfile(pathstr,out{ii});
end

I = iout >= st;
if ed ~=0
   I = I & iout <= ed;
end
out = out(I);
iout = iout(I);
[iout,I] = sort(iout);
out = out(I);
