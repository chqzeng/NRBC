%WRITE_ICC_PROFILE   Make a ICC profile
%
% SYNOPSIS:
%  write_icc_profile(file_name, header_info, tagname, tagdata, ...
%                    tagname, tagdata, ...)
%
% DESCRIPTION
%  This function writes the header info and the tags to an ICC profile with
%  the name "file_name". The number of tags that can be given is unlimited.
%  The specifiaction of this profile can be downloaded from www.color.org
%  The header_info is a struct containing the following fields:
%     1: CMM                    : specifies the preferred color management
%                                 system that should be used
%     2: device_class           : the kind of device the profile is meant for
%                                 monitor = 'mntr', scanner = 'scnr',
%                                 printer = 'prtr'
%     3: profile_number         : given in 4 digits
%     4: input color space      : the device color space
%                                 mainly 'RGB ' and 'CMYK'
%     5: connection color space : the perceptual color space
%                                 'XYZ ' or 'Lab '
%     6: rendering intent       : the style of reproduction that should be
%                                 used
%                                 0: perceptual
%                                 1: media-relative colorimetric
%                                 2: saturation
%                                 3: ICC absolute colorimetric
%     7: embedded               : 0: profile is not embedded in a file
%                                 1: profile is embedded in a file, the
%                                    profile can be used independently from
%                                    the embedded color data
%                                 2: profile is embedded in a file, the
%                                    profile cannot be used independently from
%                                    the embedded color data
%     8: platform_signature     : specifies the primary platform/operating
%                                 system for which the profile was created.
%     9: device attributes     : Attributes unique to the particular device
%                                 setup such as media type. Four values:
%                                 Reflective  (0) or Transparency (1)
%                                 Glossy (0) or Matte (1)
%                                 Positive (0) or Negative (1) media
%                                 Color (0) or Black & white (1) media
%  The tagnames and tagdata that can be given are the following
%     1:  'rTRC'  tagdata{1} = values, tagdata{2} = tagtype
%     2:  'gTRC'  tagdata{1} = values, tagdata{2} = tagtype
%     3:  'bTRC'  tagdata{1} = values, tagdata{2} = tagtype
%     4:  'kTRC'  tagdata{1} = values, tagdata{2} = tagtype
%     5:  'wtpt'  tagdata = [X Y Z]
%     6:  'bkpt'  tagdata = [X Y Z]
%     7:  'rXYZ'  tagdata = [X Y Z]
%     8:  'gXYZ'  tagdata = [X Y Z]
%     9:  'bXYZ'  tagdata = [X Y Z]
%     10: 'cprt'  tagdata = textstring
%     11: 'chad'  tagdata = 3x3 matrix
%     12: 'gamt'  tagdata = lutdata
%     13: 'A2B0'  tagdata = lutdata
%     14: 'A2B1'  tagdata = lutdata
%     15: 'A2B2'  tagdata = lutdata
%     16: 'B2A0'  tagdata = lutdata
%     17: 'B2A1'  tagdata = lutdata
%     18: 'B2A2'  tagdata = lutdata
%
%  in which lutdata is defined as follows
%     lutdata{1} = input_lut
%     lutdata{2} = clut
%     lutdata{3} = output_lut
%     lutdata{4} = e
%     lutdata{5} = lut_type (only mft1 and mft2 are implemented)
%
% DEFAULTS:
%  file_name   = 'test.icm'
%  header_info =
%     1: CMM                     : '    '
%     2: device_class            : 'mntr'
%     3: profile_number          : [0 0 0 0]
%     4: input color space       : 'RGB '
%     5: connection color space  : 'XYZ '
%     6: rendering intent        : 0
%     7: embedded                : 0
%     8: platform_signature      : '    '
%     9: device attributes       : [0 0 0 0]

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
%  Judith Dijk, August 2002.

function  menu_out = write_icc_profile( filename, header_info, varargin)
% Avoid being in menu
if nargin == 1 & ischar(filename) & strcmp(filename,'DIP_GetParamList')
   menu_out = struct('menu','none');
   return
end

profile_size = 132;
printval = 0;
if nargin < 1 | isempty(filename), filename = 'test.icm'; end
if nargin < 2 | isempty(header_info),
   CMM = '    ';
   device_class = 'mntr';
   profile_number = [0 0 0 0];
   inputspace = 'RGB ';
   connectionspace = 'XYZ ';
   rendering_intent = 0;
   embedded = 0;
   platform_signature = '    ';
   device_attributes = [0 0 0 0];
else
   s = size( header_info, 1);
   if isempty(header_info{1}), CMM = 'KMCS';
      else CMM = header_info{1}; end
   if isempty(header_info{2}) | s < 2, device_class = 'mntr';
      else device_class = header_info{2};  end
   if isempty(header_info{3}) | s < 3, profile_number = [ 0 0 0 0];
      else profile_number = header_info{3};  end
   if isempty(header_info{4}) | s < 4, inputspace = 'RGB ';
      else inputspace = header_info{4};  end
   if isempty(header_info{5}) | s < 5, connectionspace = 'XYZ ';
      else connectionspace = header_info{5};  end
   if isempty(header_info{6}) | s < 6, rendering_intent = 0;
      else rendering_intent = header_info{6};  end
   if isempty(header_info{7}) | s < 7, embedded = 0;
      else embedded = header_info{7};  end
   if isempty(header_info{8}) | s < 8, platform_signature = '    ';
      else platform_signature = header_info{8};  end
   if isempty(header_info{9}) | s < 9, device_attributes = [0 0 0 0];
      else device_attributes = header_info{9};  end
end
% The illuminant given in the header should always be D50, different illuminants
% can be given in the chromatic adaptation Tag.

X = 0.963745;
Y = 1.000000;
Z = 0.824081;

notags = (nargin - 2)./2;
if( notags < 0)
   notags = 0;
end
for i=1:notags
   tag_names{i} = varargin{i.*2-1};
   tag_data{i} = varargin{i.*2};
end

tag_size = [];
for i=1:notags
   switch tag_names{i};
      case  'rTRC'
         r_TRC = tag_data{i}{1};
         if size( tag_data{i}, 1) > 1
            type_r_TRC = tag_data{i}{2};
         else
            type_r_TRC = 'curv';
         end
         tag_size(i) = determine_size_TRC( r_TRC, type_r_TRC);
      case  'gTRC'
         g_TRC = tag_data{i}{1};
         if size( tag_data{i}, 1) > 1
            type_g_TRC = tag_data{i}{2};
         else
            type_g_TRC = 'curv';
         end
         tag_size(i) = determine_size_TRC( g_TRC, type_g_TRC);
      case  'bTRC'
         b_TRC = tag_data{i}{1};
         if size( tag_data{i}, 1) > 1
            type_b_TRC = tag_data{i}{2};
         else
            type_b_TRC = 'curv';
         end
         tag_size(i) = determine_size_TRC( b_TRC, type_b_TRC);
      case  'kTRC'
         k_TRC = tag_data{i}{1};
         if size( tag_data{i}, 1) > 1
            type_k_TRC = tag_data{i}{2};
         else
            type_k_TRC = 'curv';
         end
         tag_size(i) = determine_size_TRC( k_TRC, type_k_TRC);
      case  'wtpt'
         XYZ_white = tag_data{i};
         tag_size(i) = 20;
      case  'bkpt'
         XYZ_black = tag_data{i};
         tag_size(i) = 20;
      case  'rXYZ'
         XYZ_red = tag_data{i};
         tag_size(i) = 20;
      case  'gXYZ'
         XYZ_green = tag_data{i};
         tag_size(i) = 20;
      case  'bXYZ'
         XYZ_blue = tag_data{i};
         tag_size(i) = 20;
      case  'cprt'
         copyright = tag_data{i};
         s = size(copyright);
         tag_size(i) = s(1).*s(2) + 8;
      case  'chad'
         chromatic_adaptation_array = tag_data{i};
         tag_size(i) = 44;
      case  'gamt'
         gam_input = tag_data{i}{1};
         gam_clut = tag_data{i}{2};
         gam_output = tag_data{i}{3};
         if size( tag_data{i}, 1) >= 4 | size(tag_data{i}, 2) >= 4
            gam_e = tag_data{i}{4};
            if size( tag_data{i}, 1) >= 5 | size( tag_data{i}, 2) >= 5
               gam_type = tag_data{i}{5};
            else
               gam_type = 'mft2';
            end
         else
            gam_e = [1 0 0 ; 0 1 0 ; 0 0 1];
            gam_type = 'mft2';
         end
         tag_size(i) = determine_size_lut( gam_input, gam_clut, ...
            gam_output, gam_type);
      case  'A2B0'
         A2B0_input = tag_data{i}{1};
         A2B0_clut = tag_data{i}{2};
         A2B0_output = tag_data{i}{3};
         if size( tag_data{i}, 1) > 4
            A2B0_e = tag_data{i}{4}
            if size( tag_data{i}, 1) > 5
               A2B0_type = tag_data{i}{5};
            else
               A2B0_type = 'mft2';
            end
         else
            A2B0_e = [1 0 0 ; 0 1 0 ; 0 0 1];
            A2B0_type = 'mft2';
         end
         tag_size(i) = determine_size_lut( A2B0_input, A2B0_clut, ...
            A2B0_output, A2B0_type);
      case  'A2B1'
         A2B1_input = tag_data{i}{1};
         A2B1_clut = tag_data{i}{2};
         A2B1_output = tag_data{i}{3};
         if size( tag_data{i}, 1) > 4
            A2B1_e = tag_data{i}{4}
            if size( tag_data{i}, 1) > 5
               A2B1_type = tag_data{i}{5};
            else
               A2B1_type = 'mft2';
            end
         else
            A2B1_e = [1 0 0 ; 0 1 0 ; 0 0 1];
            A2B1_type = 'mft2';
         end
         tag_size(i) = determine_size_lut( A2B1_input, A2B1_clut, ...
            A2B1_output, A2B1_type);
      case  'A2B2'
         A2B2_input = tag_data{i}{1};
         A2B2_clut = tag_data{i}{2};
         A2B2_output = tag_data{i}{3};
         if size( tag_data{i}, 1) > 4
            A2B2_e = tag_data{i}{4}
            if size( tag_data{i}, 1) > 5
               A2B2_type = tag_data{i}{5};
            else
               A2B2_type = 'mft2';
            end
         else
            A2B2_e = [1 0 0 ; 0 1 0 ; 0 0 1];
            A2B2_type = 'mft2';
         end
         tag_size(i) = determine_size_lut( A2B2_input, A2B2_clut, ...
            A2B2_output, gam_type);
      case  'B2A0'
         B2A0_input = tag_data{i}{1};
         B2A0_clut = tag_data{i}{2};
         B2A0_output = tag_data{i}{3};
         if size( tag_data{i}, 1) > 4
            B2A0_e = tag_data{i}{4}
            if size( tag_data{i}, 1) > 5
               B2A0_type = tag_data{i}{5};
            else
               B2A0_type = 'mft2';
            end
         else
            B2A0_e = [1 0 0 ; 0 1 0 ; 0 0 1];
            B2A0_type = 'mft2';
         end
         tag_size(i) = determine_size_lut( B2A0_input, B2A0_clut, ...
            B2A0_output, B2A0_type);
      case  'B2A1'
         B2A1_input = tag_data{i}{1};
         B2A1_clut = tag_data{i}{2};
         B2A1_output = tag_data{i}{3};
         if size( tag_data{i}, 1) > 4
            B2A1_e = tag_data{i}{4}
            if size( tag_data{i}, 1) > 5
               B2A1_type = tag_data{i}{5};
            else
               B2A1_type = 'mft2';
            end
         else
            B2A1_e = [1 0 0 ; 0 1 0 ; 0 0 1];
            B2A1_type = 'mft2';
         end
         tag_size(i) = determine_size_lut( B2A1_input, B2A1_clut, ...
            B2A1_output, B2A1_type);
      case  'B2A2'
         B2A2_input = tag_data{i}{1};
         B2A2_clut = tag_data{i}{2};
         B2A2_output = tag_data{i}{3};
         if size( tag_data{i}, 1) > 4
            B2A2_e = tag_data{i}{4}
            if size( tag_data{i}, 1) > 5
               B2A2_type = tag_data{i}{5};
            else
               B2A2_type = 'mft2';
            end
         else
            B2A2_e = [1 0 0 ; 0 1 0 ; 0 0 1];
            B2A2_type = 'mft2';
         end
         tag_size(i) = determine_size_lut( B2A2_input, B2A2_clut, ...
            B2A2_output, B2A2_type);
   end
end

fid = fopen( filename, 'w', 'b');
if ~isempty(tag_size)
   profile_size = 132 + notags.*12 + sum(tag_size);
else
   profile_size = 132
end
%% write the header %%%%

fwrite( fid, profile_size, 'uint32');
fprintf( fid, CMM, '%4c');
fwrite(fid, profile_number(1), 'uint8');
fwrite(fid, profile_number(2), 'uint8');
fwrite(fid, profile_number(3), 'uint8');
fwrite(fid, profile_number(4), 'uint8');
fprintf(fid, device_class,'%4c');
fprintf(fid, inputspace,'%4c');
fprintf(fid, connectionspace,'%4c');

x = datestr(now);
fwrite(fid, str2num( x(8:11)), 'uint16'); % year
month = x(4:6);
   switch month
      case 'Jan', m = 1;
      case 'Feb', m = 2;
      case 'Mar', m = 3;
      case 'Apr', m = 4;
      case 'May', m = 5;
      case 'Jun', m = 6;
      case 'Jul', m = 7;
      case 'Aug', m = 8;
      case 'Sep', m = 9;
      case 'Oct', m = 10;
      case 'Nov', m = 11;
      case 'Dec', m = 12;
   end
fwrite(fid, m, 'uint16'); % month
fwrite(fid, str2num( x(1:2)), 'uint16'); % day
fwrite(fid, str2num( x(13:14)), 'uint16'); % hours
fwrite(fid, str2num( x(16:17)), 'uint16'); % minutes
fwrite(fid, str2num( x(19:20)), 'uint16'); % seconds
fprintf(fid, 'acsp', '%4c');
fprintf(fid, platform_signature, '%4c', 1);
fwrite(fid, 0, 'uint16');
fwrite(fid, embedded, 'uint16');

device_man = '    ';
device_model = '    ';
fprintf(fid, device_man, '%4c');
fprintf(fid, device_model, '%4c');
dev_att = device_attributes(1) + 2.* device_attributes(2) + ...
   4.* 2.* device_attributes(3) + 8.* 2.* device_attributes(4);
fwrite(fid, dev_att, 'uint32');

profile_creator = 'DipImage        ';
profile_ID = '    ';
fwrite(fid, 0, 'uint32'); % used by the ICC profile
fwrite(fid, rendering_intent, 'uint32');

%%%% heeft met de rendering intent te maken -> testen met een ander profile

fwrite( fid, floor(X.* 2.^16), 'uint32');
fwrite( fid, floor(Y.* 2.^16), 'uint32');
fwrite( fid, floor(Z.* 2.^16), 'uint32');
fprintf( fid, profile_creator, '%4c');
fprintf( fid, profile_ID, '%16c');

%%%% 28 bytes reserved for future expansion: set to 0;

fwrite( fid, 1, 'uint32');
fwrite( fid, 2, 'uint32');
fwrite( fid, 3, 'uint32');
fwrite( fid, 4, 'uint32');
fwrite( fid, 5, 'uint32');
fwrite( fid, 6, 'uint32');
fwrite( fid, 7, 'uint32');

%%%%%% write all the tags, their offset and their size  %%%%%%

tag_offset = 132 + notags.*12;

fwrite(fid, notags, 'uint32');

if( printval == 1)
   fprintf(1, '\n\nTags: \tThe number of tags = %d\n', notags);
   fprintf(1, '\tnumber\tname \toffset \tsize\n');
end

for i=1:notags
   offset_header = 132+12.*(i-1);
   fseek( fid, offset_header, 'bof');
   fprintf( fid, tag_names{i}, '%4c');
   fwrite( fid, tag_offset, 'uint32');
   fwrite( fid, tag_size(i), 'uint32');
   tag_offset = tag_offset + tag_size(i);
end

for i=1:notags
   switch tag_names{i};
      case  'rTRC'
         write_TRC(fid, r_TRC, type_r_TRC);
      case  'gTRC'
         write_TRC(fid, g_TRC, type_g_TRC);
      case  'bTRC'
         write_TRC(fid, b_TRC, type_b_TRC);
      case  'kTRC'
         write_TRC(fid, k_TRC, type_k_TRC);
      case  'wtpt'
         write_XYZ(fid, XYZ_white);
      case  'bkpt'
         write_XYZ(fid, XYZ_black);
      case  'rXYZ'
         write_XYZ(fid, XYZ_red);
      case  'gXYZ'
         write_XYZ(fid, XYZ_green);
      case  'bXYZ'
         write_XYZ(fid, XYZ_blue);
      case  'cprt'
         write_text(fid, copyright);
      case  'gamt'
         write_lut( fid, gam_e, gam_input, gam_clut, ...
            gam_output, gam_type);
      case  'A2B0'
         write_lut( fid, A2B0_e, A2B0_input, A2B0_clut, ...
            A2B0_output, A2B0_type);
      case  'A2B1'
         write_lut( fid, A2B1_e, A2B1_input, A2B1_clut, ...
            A2B1_output, A2B1_type);
      case  'A2B2'
         write_lut( fid, A2B2_e, A2B2_input, A2B2_clut, ...
            A2B2_output, A2B2_type);
      case  'B2A0'
         write_lut( fid, B2A0_e, B2A0_input, B2A0_clut, ...
            B2A0_output, B2A0_type);
      case  'B2A1'
         write_lut( fid, B2A1_e, B2A1_input, B2A1_clut, ...
            B2A1_output, B2A1_type);
      case  'B2A2'
         write_lut( fid, B2A2_e, B2A2_input, B2A2_clut, ...
            B2A2_output, B2A2_type);
      case  'chad'
         write_chad(fid, chromatic_adaptation_array);
   end
end

fclose(fid);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% subfunctions  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function size_out = determine_size_TRC(TRC_values, tagtype);

if( tagtype == 'curv');
   entries = size(TRC_values, 1).*size(TRC_values, 2);
   if( entries == 1 & TRC_values(1) == 1)
      entries = 0; % linear curve
   end
   size_out = 12+entries.*2;
elseif( tagtype == 'para');
   s = size( TRC_values );
   s = s(1).*s(2);
   size_out = 12 + s.*4;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function tag_size = determine_size_lut( lut_input, lut_clut, ...
            lut_output, lut_type)

if( lut_type == 'mft1')
   tag_size =  size(lut_input, 1).*size(lut_input, 2) + ...
    size(lut_clut, 1).*size(lut_clut, 2) + ...
    size(lut_output, 1).*size(lut_output, 2) + 48;
elseif( lut_type == 'mft2')
   tag_size =  (size(lut_input, 1).*size(lut_input, 2) + ...
    size(lut_clut, 1).*size(lut_clut, 2) + ...
    size(lut_output, 1).*size(lut_output, 2)).*2 + 52;
else
   error('luts of type %s cannot be written\n', lut_type);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  write_TRC(fid, TRC_values, tagtype);

fprintf(fid, tagtype, '%4c');
fprintf(fid, '    ', '%4c');

if( tagtype == 'curv');
   entries = size(TRC_values, 1).*size(TRC_values, 2);
   if( entries == 1 & TRC_values(1) == 1)
      entries = 0; % linear curve
   end
   fwrite(fid, entries,'uint32');
   if( entries == 1)
      fwrite( fid, TRC_values.*2.^8, 'uint16');
      size_out = 14;
   elseif (entris > 1)
      for ii=1:entries
         fwrite( fid, floor(TRC_values(ii).*2.^16), 'uint16');
      end
   end
elseif( tagtype == 'para');
   s = size( TRC_values );
   s = s(1).*s(2);
   switch(s)
      case 1
         function_type = 0;
      case 3
         function_type = 1;
      case 4
         function_type = 2;
      case 5
         function_type = 3;
      case 7
         function_type = 4;
   end
   fwrite( fid, function_type, 'uint16');
   fwrite(fid,0,'uint16');
   for ii=1:s
     fwrite( fid, floor(TRC_values(ii).*2.^16), 'uint32');
   end
   size_out = 12 + s.*4;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function write_XYZ(fid, XYZ)

fprintf( fid, 'XYZ ', '%4c');
fprintf( fid, '    ', '%4c');
X = XYZ(1);
Y = XYZ(2);
Z = XYZ(3);
fwrite( fid, X.*2.^16, 'uint32');
fwrite( fid, Y.*2.^16, 'uint32');
fwrite( fid, Z.*2.^16, 'uint32');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function write_chad(fid, chad)

fprintf( fid, 'sf32', '%4c');
fprintf( fid, '    ', '%4c');
chad = chad .*2.^16;
fwrite( fid, chad(1, 1) ,'uint32');
fwrite( fid, chad(1, 2) ,'uint32');
fwrite( fid, chad(1, 3) ,'uint32');
fwrite( fid, chad(2, 1) ,'uint32');
fwrite( fid, chad(2, 2) ,'uint32');
fwrite( fid, chad(2, 3) ,'uint32');
fwrite( fid, chad(3, 1) ,'uint32');
fwrite( fid, chad(3, 2) ,'uint32');
fwrite( fid, chad(3, 3) ,'uint32');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function write_lut(fid, e, input_table, clut_table, output_table, tag_type)

fprintf(fid, tag_type, '%4c');
fprintf(fid, '    ', '%4c');
if( tag_type == 'mft1')
%   fprintf(1, 'in write_lut_8\n');
   num_in = size( input_table, 2);
   num_out = size( output_table, 2);
   num_clut = size( clut_table, 1).*size( clut_table, 2);
   num_clut = round((num_clut./num_out).^(1./num_in));

   fwrite( fid, num_in, 'uint8');
   fwrite( fid, num_out, 'uint8');
   fwrite( fid, num_clut, 'uint8');
   fwrite( fid, 0, 'uint8');
   e = e.*2.^16;
   fwrite( fid, e(1, 1),'int32');
   fwrite( fid, e(1, 2),'int32');
   fwrite( fid, e(1, 3),'int32');
   fwrite( fid, e(2, 1),'int32');
   fwrite( fid, e(2, 2),'int32');
   fwrite( fid, e(2, 3),'int32');
   fwrite( fid, e(3, 1),'int32');
   fwrite( fid, e(3, 2),'int32');
   fwrite( fid, e(3, 3),'int32');

   input_table = input_table.*255;
   output_table = output_table.*255;
   clut_table = clut_table.*255;

   for(i=1:256*num_in)
      fwrite( fid, input_table(i), 'uint8');
   end

   for(i=1:num_clut.^num_in.*num_out)
      fwrite( fid, clut_table(i), 'uint8');
   end

   for(i=1:256*num_out)
      fwrite( fid, output_table(i), 'uint8');
   end
elseif( tag_type == 'mft2')
%   fprintf(1, 'in write_lut_16\n');
   num_in = size( input_table, 2);
   num_out = size( output_table, 2);
   num_clut = size( clut_table, 1).*size( clut_table, 2);
   num_clut = round((num_clut./num_out).^(1./num_in));
   fwrite( fid, num_in, 'uint8');
   fwrite( fid, num_out, 'uint8');
   fwrite( fid, num_clut, 'uint8');
   fwrite( fid, 0, 'uint8');
   e = e.*2.^16;
   fwrite( fid, e(1, 1),'int32');
   fwrite( fid, e(1, 2),'int32');
   fwrite( fid, e(1, 3),'int32');
   fwrite( fid, e(2, 1),'int32');
   fwrite( fid, e(2, 2),'int32');
   fwrite( fid, e(2, 3),'int32');
   fwrite( fid, e(3, 1),'int32');
   fwrite( fid, e(3, 2),'int32');
   fwrite( fid, e(3, 3),'int32');

   entries_in = size(input_table, 1);
   entries_out = size(output_table, 1);
   fwrite( fid, entries_in, 'uint16');
   fwrite( fid, entries_out, 'uint16');

   input_table = input_table.*(2.^16-1);
   clut_table = clut_table.*(2.^16-1);
   output_table = output_table.*(2.^16-1);

   for(i=1:entries_in*num_in)
      fwrite( fid, input_table(i), 'uint16');
   end

   for(i=1:num_clut.^num_in.*num_out)
      fwrite( fid, clut_table(i), 'uint16');
   end

   for(i=1:entries_out*num_out)
      fwrite( fid, output_table(i), 'uint16');
   end
else
   fprintf(1, 'Tagtype %s is not implemented\n', tag_type);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function write_text( fid, text_in);
   fprintf( fid, 'text', '%4c');
   fprintf( fid, '    ', '%4c');
   s = size( text_in, 1) .* size( text_in, 2);
   for i=1:s
      fprintf( fid, text_in(i), '%c');
   end
%  write a null operator here
%  then also enlarge size_tag in write_icc_profile
%  fprintf( fid, '0', 'uint8');
