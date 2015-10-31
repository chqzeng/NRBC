%READ_ICC_PROFILE   Read the values on an ICC header
%
% SYNOPSIS
%  [fid, tag_names, tag_offset, tag_size, device_class, inputspace, ...
%   connectionspace, rendering_intent, embedded] = ...
%   read_icc_profile(fid, printval)
%
% DESCRIPTION
%  This function reads the header of an ICC profile and also the names, offset
%  and size of the tags that are present in the profile. The output can be
%  printed to the screen. For more informatron about ICC profiles, see the
%  specification (available on www.color.org)
%
% DEFAULTS:
%  printval = 1  (The values are printed)
%
% EXAMPLE:
%  fid = fopen( icc_profile, 'r', 'b');
%  read_icc_profile( fid, 1);
%  fclose( fid );

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
%  Judith Dijk, July 2002.

function [fid, tag_names, tag_offset, tag_size, device_class, inputspace, ...
   connectionspace, rendering_intent, embedded] = read_icc_profile( fid , printval)
% Avoid being in menu
if nargin == 1 & ischar(fid) & strcmp(fid,'DIP_GetParamList')
   fid = struct('menu','none');
   return
end

if( nargin < 2)
   printval = 1;
end

%% read the header%%%%

size_header = fread(fid,1,'uint32');
CMM = fscanf(fid,'%4c', 1);
profile_number = zeros(1, 4);
profile_number(1) = fread(fid,1,'uint8');
profile_number(2) = fread(fid,1,'uint8');
profile_number(3) = fread(fid,1,'uint8');
profile_number(4) = fread(fid,1,'uint8');
profile_number = profile_number;
device_class = fscanf(fid,'%4c', 1);

inputspace = fscanf(fid,'%4c', 1);
connectionspace = fscanf(fid,'%4c', 1);
year = fread(fid,1,'uint16');
month = fread(fid,1,'uint16');
day = fread(fid,1,'uint16');
hours = fread(fid,1,'uint16');
minutes = fread(fid,1,'uint16');
seconds = fread(fid,1,'uint16');

profile_signature = fscanf(fid,'%4c', 1);
platform_signature = fscanf(fid,'%4c', 1);
fread(fid,1,'uint16');
CMMflags = fread(fid,1,'uint16');
if( bitand( CMMflags, 1) == 0)
   CMMflag1 = 'Not embedded';
   embedded = 0;
else
   CMMflag1 = 'Embedded';
   embedded = 1;
end
if( bitand( CMMflags, 2) == 0)
   CMMflag2 = 'Profile can be used independently from the embedded color data';
%   embedded = embedded + 0;
else
   CMMflag2 = 'Profile cannot be used independently from the embedded color data';
   embedded = embedded + 2;
end

device_man = fscanf(fid,'%4c', 1);
device_model = fscanf(fid,'%4c', 1);

device_attributes = fread(fid, 1, 'uint32');
if( bitand( device_attributes, 1) == 0)
   dev_attr1 = 'Reflective';
else
   dev_attr1 = 'Transparency';
end
if( bitand( device_attributes, 2) == 0)
   dev_attr2 = 'Glossy';
else
   dev_attr2 = 'Matte';
end
if( bitand( device_attributes, 4) == 0)
   dev_attr3 = 'Positive';
else
   dev_attr3 = 'Negative';
end
if( bitand( device_attributes, 8) == 0)
   dev_attr4 = 'Color';
else
   dev_attr4 = 'Black-and-white';
end

fread(fid, 1, 'uint32'); % used by the ICC profile
rendering_intent = fread(fid, 1, 'uint16');
fread(fid, 1, 'uint16');

%%%% The rendering content may not be correct, we do not have a good profile
%%%% test it


X = fread(fid,1,'uint32')/2^16;
Y = fread(fid,1,'uint32')/2^16;
Z = fread(fid,1,'uint32')/2^16;
profile_creator = fscanf(fid, '%4c', 1);
profile_ID = fscanf(fid, '%4c', 1);


%%%%%%%%%%%%% print the header  %%%%%%%%%%%%%%%%%%
if printval == 1
   switch device_class
      case  'mntr'
         device_name = 'Display device';
      case 'scnr'
         device_name = 'Input device';
      case 'prtr'
         device_name = 'Output device';
      otherwise
         device_name = 'Unknown device';
   end
   switch rendering_intent
      case  0
        rendering_txt = sprintf('perceptual');
      case  1
         rendering_txt = sprintf(1, 'media-relative colorimetric');
      case  2
         rendering_txt = sprintf(1, 'saturation');
      case  3
         rendering_txt = sprintf(1, 'icc absolute colorimetric');
   end

   fprintf(1, 'Header:\n');
   fprintf(1, '\tsize\t\t  = %d\n', size_header);
   fprintf(1, '\tCMM\t\t  = %s\n', CMM);
   fprintf(1, '\tVersion\t\t  = %d.%d.%d\n', profile_number(1), ...
      profile_number(2), profile_number(3));
   fprintf(1, '\tDevice Class\t  = %s\n', device_name);
   fprintf(1, '\tColor Space\t  = %s\n', inputspace);
   fprintf(1, '\tConn. Space\t  = %s\n', connectionspace);
   fprintf(1, '\tDate, Time    = %d ', day);
   switch month
      case 1, m = 'Jan';
      case 2, m = 'Feb';
      case 3, m = 'Mar';
      case 4, m = 'Apr';
      case 5, m = 'May';
      case 6, m = 'Jun';
      case 7, m = 'Jul';
      case 8, m = 'Aug';
      case 9, m = 'Sep';
      case 10, m = 'Oct';
      case 11, m = 'Nov';
      case 12, m = 'Dec';
   end
   fprintf(1, '%s %d, ', m, year);
   if( hours < 10)
      fprintf(1, '0%d:', hours);
   else
      fprintf(1, '%d:', hours);
   end
   if( minutes < 10)
      fprintf(1, '0%d:', minutes);
   else
      fprintf(1, '%d:', minutes);
   end
   if( seconds < 10)
      fprintf(1, '0%d\n', seconds);
   else
      fprintf(1, '%d\n', seconds);
   end
   fprintf(1, '\tProfile Signature = %s\n', profile_signature);
   fprintf(1, '\tPlatform \t  = %s\n', platform_signature);
   fprintf(1, '\tFlags \t\t  = %s\n', CMMflag1);
   fprintf(1, '\t  %s\n', CMMflag2);
   fprintf(1, '\tDev. Mnfctr.\t  = %s\n', device_man);
   fprintf(1, '\tDev. Model.\t  = %s\n', device_model);
   fprintf(1, '\tDev. Attrbts \t  = %s, %s, %s, %s\n', dev_attr1, dev_attr2, ...
      dev_attr3, dev_attr4);
   fprintf(1, '\tRendering intent  = %s\n', rendering_txt);
   fprintf(1, '\tIlluminant\t  = %f %f %f\n', X, Y, Z);
   fprintf(1, '\tCreator\t\t  = %s\n', profile_creator);
                                  % omzetten....
end

%%%%%% read all the tags, their offset and their size  %%%%%%

fseek(fid,128,'bof');
notags=fread(fid,1,'uint32');
if( printval == 1)
   fprintf(1, '\n\nTags: \tThe number of tags = %d\n', notags);
   fprintf(1, '\tnumber\tname \toffset \tsize\n');
end

for i=1:notags
   num = 132 + 12*(i-1);
   fseek( fid, num, 'bof');
   tag_names(i, :) = fscanf(fid,'%4c',1);
   tag_offset(i, :) = fread(fid,1,'uint32');
   tag_size(i, :) = fread(fid,1,'uint32');
   if printval == 1
      fprintf(1, '\ti=%d\t%s \t%d \t%d\n', i, tag_names(i,:), tag_offset(i,:), ...
         tag_size(i, :));
   end
end

