%STATUS = DIPIO_FILESTATUS(LASTERR)
%    Call just after a dipio_imageread() function call generated and error.
%    Returns:
%       1 -> the file exists but cannot be read
%       2 -> the file does not exist
%       0 -> some other error occurred

% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2004.

function status = dipio_filestatus(str)
status = 0;
if isempty(str)
   return
end
I = length(str);
while str(I)==10
   I = I-1;
   if I==0
      return
   end
end
str = str(1:I);
err = 'File not found';
el = length(err);
if length(str) >= el
   if strcmp(str(end-el+1:end),err)
      status = 2;
      return
   end
end
err = 'File type not recognised';
el = length(err);
if length(str) >= el
   if strcmp(str(end-el+1:end),err)
      status = 1;
      return
   end
end
