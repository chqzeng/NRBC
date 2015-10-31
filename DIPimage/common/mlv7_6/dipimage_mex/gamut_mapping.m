%GAMUT_MAPPING   Map the pixels of the input image on the gamut of the output device
%
% SYNOPSIS:
%  mage_out = gamut_mapping(image_in, clipping_style, gamut_data, param)
%
% DEFAULTS:
%  clipping_style = 'ort_clip'
%  gamut_data     = standard RGB gamut (D65, 2 degrees observer)
%  param(1)       = [0,50] (chroma of the chord point)
%  param(2)       = 50     (lightness of the chord point)
%  param(3)       = 1      (scaling factor)
%  param(4)       = 0      (percentage)
%
% DESCRIPTION:
%  The goal of this function is to reduce the out-of-gamut pixels of an
%  image. This can be achieved in two different ways: by clipping all
%  out-of-gamut pixels on the boundary of the gamut, or by compression of the
%  colors of all pixel points. The advantage of clipping over compression is
%  that only pixels that need to be changed are changed, so that the chroma
%  and lightness of the image are maximal kept. The advantage of compression
%  over clipping is that color differences in out-of-gamut colors can still
%  be seen. It depends on the image and the number of out-of-gamut colors
%  which mapping style gives the best results.
%
%  Currently 6 types of gamut mapping are implemented. For all
%  types the hue h remains constant.
%  1.  CHORD CLIPPING: clipping over a constant line towards the point
%        chord point. The chord point can be defined using param(1) and
%        param(2).
%  2.  ORTHOGONAL CLIPPING: clipping to the closest boundary point (in
%        (chroma/lightness space)
%  3.  CHORD COMPRESSION: compression of lightness and chroma towards the
%        chord point. The compression factor is determined by the
%        maximum scaling that is needed to get rid of all out-of-gamut
%        points. This maximum can be scaled by the user with param(3).
%        param(1) and param(2) are used for the chroma and lightness of the
%        chord point, respectively
%  4.  CHROMA COMPRESSION: compression of the chroma while the lightness
%        remains constant. The compression factor is determined by the
%        maximum scaling that is needed to get rid of all out-of-gamut
%        points. This maximum can be scaled by the user with param(1).
%  5.  SIMPLE CHORD COMPRESSION: compression of the lightness and the chroma
%        towards the chord point. The scaling factor is given by the user.
%  6.  SIMPLE CHROMA COMPRESSION: compression of the lightness. The compression
%        factor is directly given by the user.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, June 2002.
% 20 October 2007: Moved to toolbox directory, simplified, removed some testing
%                  statemens that were still active (!?). (CL)

function out = gamut_mapping(in, clipping_function, gamut_bound, param)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if ~isa(in,'dip_image_array') | ~iscolor(in)
   error('Input needs to be a color image.');
end

if( nargin < 2 | isempty(clipping_function) )
   clipping_function = 'ort_clip';
else
   switch lower(clipping_function)
      case {'ort', 'ortogonal','ort_clip'}
         clipping_function = 'ort_clip';
      case {'chord', '2point','chord_clip'}
         clipping_function = 'chord_clip';
      case {'chord_mapping','chord_map','mapping'}
         clipping_function = 'chord_map';
      case {'chroma_mapping', 'chroma_map'}
         clipping_function = 'chroma_map';
      case 'chroma_map_simple'
         clipping_function = 'chroma_map_simple';
      case 'chord_map_simple'
         clipping_function = 'chord_map_simple';
      otherwise
         error('Unknown clipping mode.');
   end
end

if( nargin < 3)
   gamut_bound = make_gamut;
end

ori_col = colorspace(in);
ori_xyz = get_xyz(in);
in = colorspace(in, 'lab');

if strcmp(clipping_function, 'chroma_map_simple')
   if nargin < 4
      scal = 1;
   else
      scal = param(1);
   end
   out = in;
   out{2} = in{2}.*frac;
   out{3} = in{3}.*frac;
elseif strcmp(clipping_function, 'chord_map_simple')
   if nargin < 4
      scal = 1;
      chord = [0 50];
   else
      chord = param(1:2);
      scal = param(3);
      percen = param(4);
   end
   L = in{1};
   C = sqrt(in{2}.^2 + in{3}.^2);
   h = atan2(in{3}, in{2});
   C_new = (C - chord(1)).*scal + chord(1);
   L_new = (L - chord(2)).*scal + chord(2);

   out = in;
   out{1} = L_new;
   out{2} = C_new .* cos(h);
   out{3} = C_new .* sin(h);
else
   % preparation for the actual gamut mapping procedure: the input image is
   % reshaped in a 1-D image, in which the columns give the Lab of the points.

   input_image = double(cat(3,in));

   s = size(input_image);
   input_image = reshape( input_image, s(1).*s(2), 3)';

   % find the correct mapping function. for explanation of the functions, see
   % above or the corresponding c-file.
   switch ( clipping_function )
      case 'chord_clip'
         if nargin < 4
            chord = [0 50];
         elseif( size(param, 1).*size(param, 2) ~= 2)
            chord = [0 50];
         else
            chord = param(1);
         end
         out = gamut_mapping_chord(input_image, gamut_bound', ....
            chord(1), chord(2));
      case 'ort_clip'
         out = gamut_mapping_ort(input_image, gamut_bound');
      case 'chroma_map'
         if( nargin < 4)
            scal = 1;
            percen = 0.050;
         else
            scal = param(1);
            percen = param(2);
         end
         minval_in = min(in{1});
         maxval_in = max(in{1});
         input_image = scale_lightness(input_image, minval_in, maxval_in, gamut_bound);
         out = gamut_compression_chord(input_image, gamut_bound', ...
            0, 0, 0, scal, percen);
      case 'chord_map'
         if nargin < 4
            chord = [0 50];
            scal = 1;
            percen = 0.050;
         elseif( size(param, 1).*size(param, 2) ~= 4)
            chord = [0 50];
            scal = 1;
            percen = 0.050;
         else
            chord = param(1:2);
            scal = param(3);
            percen = param(4);
         end
         % disp('chord compression');
         out = gamut_compression_chord(input_image, gamut_bound', ...
            chord(1), chord(2), 1, scal, percen);
      otherwise
      error('this clipping style is not known');
   end

   % restore the correct dimensions of the image.
   out = reshape(out', s(1), s(2), 3);
   out = joinchannels('lab', out(:, :, 1), out(:, :, 2), out(:, :, 3));
end

out = colorspace(out, ori_col );


%% used in chroma mapping
function in = scale_lightness(in, minval_in, maxval_in, gamut_bound)

if( nargin < 4)
   minval = 0;
   maxval = 100;
else
   lightness_vals = [gamut_bound(:, 1); gamut_bound(:, 4); gamut_bound(:, 7)];
   maxval = max(lightness_vals);
   labvals = [gamut_bound(:, 1:3); gamut_bound(:, 4:6); gamut_bound(:, 7:9)];
   io = find( labvals(:, 1) < 50 & abs(labvals(:, 2)) < 1 & abs( labvals(:, 3))< 1);
   minval = max( labvals(io, 1));
end

minval_in = min(in(1, :))
maxval_in = max(in(1, :));

% fprintf(1, '%f %f %f %f\n', minval_in, minval, maxval_in, maxval);
if( minval_in < minval | maxval_in > maxval)
   if( maxval_in ~= minval_in)
      in(1, :)= (in(1, :)-minval_in)./(maxval_in-minval_in).*(maxval-minval) + minval;
   else
      if( maxval_in < minval)
         in(1, :) = minval;
      elseif( maxval_in > maxval)
         in(1, :) = maxval;
      %else
         %in(1, :) = in(1, :);
      end
   end
end
