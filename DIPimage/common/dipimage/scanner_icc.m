%SCANNER_ICC   Converts the colors of an image according to the given ICC profile
%
% SYNOPSIS
%  out = scanner_icc(in, icc_profile, forward_reverse, printval);
%
% DESCRIPTION
%  In this function an ICC profile is used to convert values from RGB to
%  XYZ/CIELAB (forward) or from XYZ/CIELAB to RGB (reverse). The model that
%  is used is a scanner model.  For more informatron about ICC profiles,
%  see the specification (available on www.color.org).
%
% DEFAULTS:
%  icc_profile     = 'hpsj2cx.icm'
%  forward_reverse = 'forward'
%  printval        = 0

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, July 2002.
% 20 October 2007, added fid = -1 check for not existing icc_profile (CL)

function out = scanner_icc(in, icc_profile, forward_reverse, printval);

if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList') % Avoid being in menu
      out = struct('menu','none');
      return
end
if nargin < 1
    joinchannels( 'RGB', 128, 128, 128);
end
if nargin < 2 | isempty(icc_profile),
   icc_profile = fullfile(fileparts(which('scanner_icc')),'private','hpsj2cx.icm');
end
if nargin < 3, forward_reverse = 'forward'; end
if nargin < 4, printval = 0; end

%%%%%%   first put all used tags on 0.

black_white = 0;
color = 0;
A2B0 = 0;
A2B1 = 0;
A2B2 = 0;
B2A0 = 0;
B2A1 = 0;
B2A2 = 0;
add_tags_forward = 0;
add_tags_reverse = 0;

%%%%%%   read_icc_profile

fid = fopen( icc_profile,'r','b');
if fid < 0
   error(['The specified icc_profile ',icc_profile,' could not be opened.']);
end

[fid, tags, tag_offset, tag_size, device_class, inputspace, connectionspace, ...
   rendering_intent, embedded] = read_icc_profile( fid, printval );

%%%%%    look if this profile is a monitor profile
if ~strcmp(device_class, 'scnr')
   error('The profile is not made for a scanner'); end

%%%%%    Read all the tags
%%%%%    The format of all tags is described in the ICC manual

no_tags = size(tags, 1);
for i=1:no_tags
   tagname = tags(i, :);
   icc_off = tag_offset(i);
   icc_size = tag_size(i);
   switch tagname
   case  'rTRC'
      [r_TRC, type_r_TRC] = read_TRC(fid, icc_off, icc_size);
   case  'gTRC'
      [g_TRC, type_g_TRC] = read_TRC(fid, icc_off, icc_size);
   case  'bTRC'
      [b_TRC, type_b_TRC] = read_TRC(fid, icc_off, icc_size);
      color = 1;
   case  'kTRC'
      [k_TRC, type_k_TRC] = read_TRC(fid, icc_off, icc_size);
      black_white = 1;
   case  'wtpt'
      XYZ_white = read_XYZ(fid, icc_off, icc_size);
   case  'bkpt'
      XYZ_black = read_XYZ(fid, icc_off, icc_size);
   case  'rXYZ'
      XYZ_red = read_XYZ(fid, icc_off, icc_size);
   case  'gXYZ'
      XYZ_green = read_XYZ(fid, icc_off, icc_size);
   case  'bXYZ'
      XYZ_blue = read_XYZ(fid, icc_off, icc_size);
   case  'cprt'
      copyright = read_txt(fid, icc_off, icc_size);
   case  'desc'
      read_desc(fid, icc_off, icc_size);
   case  'dmdd'
      read_desc(fid, icc_off, icc_size);
   case  'dmnd'
      read_desc(fid, icc_off, icc_size);
   case  'gamt'
      fseek(fid,icc_off,'bof');
      tag_type = fscanf(fid,'%4c',1);
      fscanf(fid,'%4c',1);
      if( tag_type == 'mft1')
         [gam_e, gam_input, gam_clut, gam_output] = read_lut8(fid, icc_off, icc_size);
      elseif( tag_type == 'mft2')
         [gam_e, gam_input, gam_clut, gam_output] = read_lut16(fid, icc_off, icc_size);
      elseif( tag_type == 'mBA ')
         [gam_e, gam_input, gam_clut, gam_output] = read_lutB2A(fid, icc_off, icc_size);
      else
         fprintf(1, 'The tag type of gamutTag is not recognized\n');
      end
      type_gamt = tag_type;
   case  'A2B0'
      fseek(fid,icc_off,'bof');
      tag_type = fscanf(fid,'%4c',1);
      fscanf(fid,'%4c',1);
      if( tag_type == 'mft1')
         [A2B0_e, A2B0_input, A2B0_clut, A2B0_output] = read_lut8(fid, icc_off, icc_size);
      elseif( tag_type == 'mft2')
         [A2B0_e, A2B0_input, A2B0_clut, A2B0_output] = read_lut16(fid, icc_off, icc_size);
      elseif( tag_type == 'mBA ')
         [A2B0_A, A2B0_B, A2B0_m, A2B0_e, A2B0_clut] = read_lutA2B(fid, icc_off, icc_size);
      else
         fprintf(1, 'The tag type of A2B0Tag is not recognized\n');
      end
      type_A2B0 = tag_type;
      A2B0 = 1;
   case  'A2B1'
      fseek(fid,icc_off,'bof');
      tag_type = fscanf(fid,'%4c',1);
      fscanf(fid,'%4c',1);
      if( tag_type == 'mft1')
         [A2B1_e, A2B1_input, A2B1_clut, A2B1_output] = read_lut8(fid, icc_off, icc_size);
      elseif( tag_type == 'mft2')
         [A2B1_e, A2B1_input, A2B1_clut, A2B1_output] = read_lut16(fid, icc_off, icc_size);
      elseif( tag_type == 'mBA ')
         [A2B1_A, A2B1_B, A2B1_m, A2B1_e, A2B1_clut] = read_lutA2B(fid, icc_off, icc_size);
      else
         fprintf(1, 'The tag type of A2B1Tag is not recognized\n');
      end
      type_A2B1 = tag_type;
      A2B1 = 1;
   case  'A2B2'
      fseek(fid,icc_off,'bof');
      tag_type = fscanf(fid,'%4c',1);
      fscanf(fid,'%4c',1);
      if( tag_type == 'mft1')
         [A2B2_e, A2B2_input, A2B2_clut, A2B2_output] = read_lut8(fid, icc_off, icc_size);
      elseif( tag_type == 'mft2')
         [A2B2_e, A2B2_input, A2B2_clut, A2B2_output] = read_lut16(fid, icc_off, icc_size);
      elseif( tag_type == 'mBA ')
         [A2B2_A, A2B2_B, A2B2_m, A2B2_e, A2B2_clut] = read_lutA2B(fid, icc_off, icc_size);
      else
         fprintf(1, 'The tag type of A2B2Tag is not recognized\n');
      end
      type_A2B2 = tag_type;
      A2B2 = 1;
   case  'B2A0'
      fseek(fid,icc_off,'bof');
      tag_type = fscanf(fid,'%4c',1);
      fscanf(fid,'%4c',1);
      if( tag_type == 'mft1')
          [B2A0_e, B2A0_input, B2A0_clut, B2A0_output] = read_lut8(fid, icc_off, icc_size);
      elseif( tag_type == 'mft2')
          [B2A0_e, B2A0_input, B2A0_clut, B2A0_output] = read_lut16(fid, icc_off, icc_size);
      elseif( tag_type == 'mBA ')
          [B2A0_A, B2A0_B, B2A0_m, B2A0_e, B2A0_clut] = read_lutB2A(fid, icc_off, icc_size);
      else
         fprintf(1, 'The tag type of B2A0Tag is not recognized\n');
      end
      B2A0 = 1;
      type_B2A0 = tag_type;
   case  'B2A1'
      fseek(fid,icc_off,'bof');
      tag_type = fscanf(fid,'%4c',1);
      fscanf(fid,'%4c',1);
      if( tag_type == 'mft1')
         [B2A1_e, B2A1_input, B2A1_clut, B2A1_output] = read_lut8(fid, icc_off, icc_size);
      elseif( tag_type == 'mft2')
         [B2A1_e, B2A1_input, B2A1_clut, B2A1_output]  = read_lut16(fid, icc_off, icc_size);
      elseif( tag_type == 'mBA ')
         [B2A1_A, B2A1_B, B2A1_m, B2A1_e, B2A1_clut]  = read_lutB2A(fid, icc_off, icc_size);
      else
         fprintf(1, 'The tag type of B2A1Tag is not recognized\n');
      end
      type_B2A1 = tag_type;
      B2A1 = 1;
   case  'B2A2'
      fseek(fid,icc_off,'bof');
      tag_type = fscanf(fid,'%4c',1);
      fscanf(fid,'%4c',1);
      if( tag_type == 'mft1')
         [B2A2_e, B2A2_input, B2A2_clut, B2A2_output]  = read_lut8(fid, icc_off, icc_size);
      elseif( tag_type == 'mft2')
         [B2A2_e, B2A2_input, B2A2_clut, B2A2_output] = read_lut16(fid, icc_off, icc_size);
      elseif( tag_type == 'mBA ')
         [B2A2_A, B2A2_B, B2A2_m, B2A2_e, B2A2_clut] = read_lutB2A(fid, icc_off, icc_size);
      else
         fprintf(1, 'The tag type of B2A2Tag is not recognized\n');
      end
      B2A2 = 1;
      type_B2A2= tag_type;
   case  'chad'
      chromatic_adaptation_array = read_chad(fid, icc_off, icc_size);
   otherwise
      if( printval == 1)
         fprintf(1, '\ttag %s not known\n', tagname);
      end
   end
end

%%%%%    Another error message
if rendering_intent == 0 & A2B0 == 1, add_tags_forward = 1; end
if rendering_intent == 1 & A2B1 == 1, add_tags_forward = 1; end
if rendering_intent == 2 & A2B2 == 1, add_tags_forward = 1; end
if rendering_intent == 0 & B2A0 == 1, add_tags_reverse = 1; end
if rendering_intent == 1 & B2A1 == 1, add_tags_reverse = 1; end
if rendering_intent == 2 & B2A2 == 1, add_tags_reverse = 1; end

if connectionspace == 'Lab ' & add_tags_forward == 0 & strcmp( forward_reverse, 'forward')
   error('This profile is not correct\n, CIELAB connectionspace has to be used with lookuptables.');
end
if connectionspace == 'Lab ' & add_tags_reverse == 0 & strcmp( forward_reverse, 'reverse')
   error('This profile is not correct\n, CIELAB connectionspace has to be used with lookuptables.');
end

%%%%%    The real conversion.
%%%%%    Three large loops: outer : is the image black-and-white or color
%%%%%                       middle: is the conversion forward or reverse?
%%%%%                       inner:  is there a lookup table present?
%%%%%    Black-and white is not really interesting


if black_white
   if strcmp( forward_reverse, 'forward')
      if add_tags_forward == 0
         connection = TRC_curve( in, k_TRC, type_k_TRC);
         out(:, 1) = connection(:).*d50_X;
         out(:, 2) = connection(:).*d50_Y;
         out(:, 3) = connection(:).*d50_Z;
      else
         if rendering_intent == 0 % perceptual
            fprintf(1, 'this function is not implemented\n');
         elseif rendering_intent == 1 % colorimetric
            fprintf(1, 'this function is not implemented\n');
         elseif rendering_intent == 2% saturation
            fprintf(1, 'this function is not implemented\n');
         end
      end
   else
      connection = in(:, 2);           % The luminance values
      if add_tags_reverse == 0
         out = TRC_curve_reverse(in, k_TRC, type_k_TRC)
      else
         if rendering_intent == 0 % perceptual
            fprintf(1, 'this function is not implemented\n');
         elseif rendering_intent == 1 % colorimetric
            fprintf(1, 'this function is not implemented\n');
         elseif rendering_intent == 2 % saturation
            fprintf(1, 'this function is not implemented\n');
         end
      end
   end
end

%%%%%    Here the color conversions start.
%%%%%    Four main options:
%%%%%    *   forward and curve: RGB -> linear RGB by curve
%%%%%                           XYZ = a*RGB
%%%%%    *   forward and lookup table
%%%%%             linear RGB = RGB through lin_input (LUT)
%%%%%             linear XYZ = linear RGB through clut (LUT)
%%%%%             XYZ = linear XYZ through lin_output (LUT)
%%%%%             XYZ = e.*XYZ
%%%%%    *   reverse and curve: linear RGB = a^(-1) XYZ
%%%%%                           RGB -> reverse_curve of linear RGB
%%%%%    *   reverse and lookup table
%%%%%             XYZ = e.*XYZ
%%%%%             linear XYZ = XYZ through lin_input (LUT)
%%%%%             linear RGB = linear XYZ through clut (LUT)
%%%%%             RGB = linear RGB through lin_output (LUT)




if color == 1
   if strcmp( forward_reverse, 'forward')
      if add_tags_forward == 0
         device_R = double(in{1}./255);
         device_G = double(in{2}./255);
         device_B = double(in{3}./255);
         linear_R = TRC_curve( device_R, r_TRC, type_r_TRC);
         linear_G = TRC_curve( device_G, g_TRC, type_g_TRC);
         linear_B = TRC_curve( device_B, b_TRC, type_b_TRC);

         a = [XYZ_red' XYZ_green' XYZ_blue'];

         X = a(1, 1).*linear_R + a(1, 2).*linear_G + a(1, 3).*linear_B;
         Y = a(2, 1).*linear_R + a(2, 2).*linear_G + a(2, 3).*linear_B;
         Z = a(3, 1).*linear_R + a(3, 2).*linear_G + a(3, 3).*linear_B;
         out = joinchannels('XYZ', X, Y, Z);
         out.whitepoint = XYZ_white;
      else
         if rendering_intent == 0 % perceptual
            if strcmp(type_A2B0, 'mft1') | strcmp(type_A2B0, 'mft2')
               e = A2B0_e;
               lin_input = A2B0_input;
               lin_output = A2B0_output;
               clut = A2B0_clut;
            else
               error('This type of data is not implemented yet');
            end
         elseif rendering_intent == 1 % colorimetric
            if strcmp(type_A2B1, 'lut8') | strcmp(type_A2B1, 'lut16')
               e = A2B1_e;
               lin_input = A2B1_input;
               lin_output = A2B1_output;
               clut = A2B1_clut;
            else
               error('This type of data is not implemented yet');
            end
         elseif rendering_intent == 2 % saturation
            if strcmp(type_A2B2, 'lut8') | strcmp(type_A2B2, 'lut16')
               e = A2B2_e;
               lin_input = A2B2_input;
               lin_output = A2B2_output;
               clut = A2B2_clut;
            else
               error('This type of data is not implemented yet');
            end
         end
         lin_input(:, 1) = lin_input(:, 1)./max(lin_input(:, 1));
         lin_output(:, 1) = lin_output(:, 1)./max(lin_output(:, 1));
         % input -> clut -> output -> e
         device_R = double(in{1}./255);
         device_G = double(in{2}./255);
         device_B = double(in{3}./255);

         R_lin = lin_interpol( device_R, lin_input(:, 1:2));
         G_lin = lin_interpol( device_G, lin_input(:, [1, 3]));
         B_lin = lin_interpol( device_B, lin_input(:, [1, 4]));
         if( connectionspace == 'XYZ ')
            [X_lin, Y_lin, Z_lin] = lin_interpol_3( R_lin, G_lin, ...
               B_lin, clut);
            X_out = lin_interpol( X_lin, lin_output(:, 1:2));
            Y_out = lin_interpol( Y_lin, lin_output(:, [1, 3]));
            Z_out = lin_interpol( Z_lin, lin_output(:, [1, 4]));

            X = e(1, 1).*X_out + e(1, 2).*Y_out + e(1, 3).*Z_out;
            Y = e(2, 1).*X_out + e(2, 2).*Y_out + e(2, 3).*Z_out;
            Z = e(3, 1).*X_out + e(3, 2).*Y_out + e(3, 3).*Z_out;
            out = joinchannels('XYZ', X, Y, Z);
         else
            [L_lin, a_lin, b_lin] = lin_interpol_3( R_lin, G_lin, ...
               B_lin, clut);
            L = lin_interpol( L_lin, lin_output(:, 1:2));
            a = lin_interpol( a_lin, lin_output(:, [1, 3]));
            b = lin_interpol( b_lin, lin_output(:, [1, 4]));
            L = L.*100;
            a = a.*255-127.5;
            b = b.*255-127.5;
            out =  joinchannels('LAB', L, a, b);
         end
         out.whitepoint = XYZ_white;
      end
   else  % reverse
      if add_tags_reverse == 0
         a = [XYZ_red' XYZ_green' XYZ_blue']^(-1)

         X = double(in{1});
         Y = double(in{2});
         Z = double(in{3});

         linear_R = a(1, 1).*X + a(1, 2).*Y + a(1, 3).*Z
         linear_G = a(2, 1).*X + a(2, 2).*Y + a(2, 3).*Z
         linear_B = a(3, 1).*X + a(3, 2).*Y + a(3, 3).*Z

         linear_R = (linear_R >= 0).*(linear_R <=1).*linear_R + (linear_R >1);
         linear_G = (linear_G >= 0).*(linear_G <=1).*linear_G + (linear_G >1);
         linear_B = (linear_B >= 0).*(linear_B <=1).*linear_B + (linear_B >1);

         device_R = TRC_curve_reverse( linear_R, r_TRC, type_r_TRC);
         device_G = TRC_curve_reverse( linear_G, g_TRC, type_g_TRC);
         device_B = TRC_curve_reverse( linear_B, b_TRC, type_b_TRC);

         out = joinchannels('RGB', device_R.*255, device_G.*255, device_B.*255);
         out.whitepoint = XYZ_white;

      else
         if rendering_intent == 0 % perceptual
            if strcmp(type_B2A0, 'mft1') | strcmp(type_B2A0, 'mft2')
               e = B2A0_e;
               lin_input = B2A0_input;
               lin_output = B2A0_output;
               clut = B2A0_clut;
            else
               error('This type of data is not implemented yet');
            end
         elseif rendering_intent == 1 % colorimetric
            if strcmp(type_B2A1, 'mft1') | strcmp(type_B2A1, 'mft2')
               e = B2A1_e;
               lin_input = B2A1_input;
               lin_output = B2A1_output;
               clut = B2A1_clut;
            else
               error('This type of data is not implemented yet');
            end
         elseif rendering_intent == 2 % saturation
            if strcmp(type_B2A2, 'mft1') | strcmp(type_B2A2, 'mft2')
               e = B2A2_e;
               lin_input = B2A2_input;
               lin_output = B2A2_output;
               clut = B2A2_clut;
            else
               error('This type of data is not implemented yet');
            end
         end

         % input -> clut -> output -> e
         lin_input(:, 1) = lin_input(:, 1)./max(lin_input(:, 1));

         if( connectionspace == 'XYZ ')
            in = colorspace(in, 'XYZ');

            X_in = double(in{1});
            Y_in = double(in{2});
            Z_in = double(in{3});

            e = e^(-1);
            X = e(1, 1).*X_in + e(1, 2).*Y_in + e(1, 3).*Z_in;
            Y = e(2, 1).*X_in + e(2, 2).*Y_in + e(2, 3).*Z_in;
            Z = e(3, 1).*X_in + e(3, 2).*Y_in + e(3, 3).*Z_in;

            X_lin = lin_interpol( X, lin_input(:, 1:2));
            Y_lin = lin_interpol( Y, lin_input(:, [1, 3]));
            Z_lin = lin_interpol( Z, lin_input(:, [1, 4]));

            [R_lin, G_lin, B_lin] = lin_interpol_3( X_lin, Y_lin, ...
               Z_lin, clut);
         else
            in = colorspace(in, 'Lab');
            L = double(in{1});
            a = double(in{2});
            b = double(in{3});

            L = L./100;
            a = (a + 127.5)./255;
            b = (b + 127.5)./255;

            L_lin = lin_interpol( L, lin_input(:, 1:2));
            a_lin = lin_interpol( a, lin_input(:, [1, 3]));
            b_lin = lin_interpol( b, lin_input(:, [1, 4]));

            [R_lin, G_lin, B_lin] = lin_interpol_3( L_lin, a_lin, ...
               b_lin, clut);
         end

         lin_output(:, 1) = lin_output(:, 1)./max(lin_output(:, 1));
         device_R = lin_interpol( R_lin, lin_output);
         device_G = lin_interpol( G_lin, lin_output);
         device_B = lin_interpol( B_lin, lin_output);

         out = joinchannels('RGB', device_R.*255, device_G.*255, device_B.*255);
         out.whitepoint = XYZ_white;
      end
   end
end
