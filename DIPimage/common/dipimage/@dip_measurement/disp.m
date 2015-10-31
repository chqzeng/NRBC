%DISP   Display a dip_measurement object.
%   DISP(B) displays the data in B.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% Adapted from DIP_MEASUREPRINT.
% 27 November 2000:  Increased speed (x486->PII ?).
% 12 July 2001:      Changed display of multicolumn, starts now at 1 conform with call (Bernd)
% 18 December 2009:  Added 'axes' and 'units' elements.

function disp(in)

Nobj = length(in.id);
Nmsr = length(in.names);

if ~Nobj | ~Nmsr
   disp('Empty measurement structure.');
   return
end

% Print measurement labels and creating format string for printing the table
line1 = '     ID';
line2 = '       ';
line3 = '       ';
fmtstr = ' %6d';
linelength = 7;
for jj=1:Nmsr
   ldat = size(in.data{jj},1);
   for kk=1:ldat
      line1 = [line1,sprintf(' %14s',in.names{jj})];
      line2 = [line2,sprintf(' %14s',in.axes{jj}{kk})];
      line3 = [line3,sprintf(' %14s',['(',in.units{jj}{kk},')'])];
   end
   if any(strcmpi(in.names{jj},{'dimensions','size','maximum','minimum'}))
      % These quantities are integers
      fmtstr = [fmtstr,repmat(' %14d',1,ldat)];
   else
      fmtstr = [fmtstr,repmat(' %14.6f',1,ldat)];
   end
   linelength = linelength + ldat*15;
end
fprintf('%s\n',line1);
if any(line2~=' ')
   fprintf('%s\n',line2);
end
fprintf('%s\n',line3);
fprintf(' %s\n',repmat('-',1,linelength));
fmtstr = [fmtstr,'\n'];

% Print measurements for each object
data = cat(1,in.data{:});
for ii=1:Nobj
   fprintf(fmtstr,in.id(ii),data(:,ii));
end
