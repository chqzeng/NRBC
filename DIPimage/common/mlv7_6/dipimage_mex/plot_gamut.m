%PLOT_GAMUT   The intersection of a gamut boundary with a constant hue plane
%
% SYNOPSIS: [chroma_luminance, upper_gamut, lower_gamut, cusp_point] =
%  plot_gamut( in, gamut_data, plotval, stringin)
%
% DEFAULTS:
%  in         = h = 0 (L = 50, a = 1, b = 0 )
%  gamut_data = standard RGB gamut (D65, 2 degrees observer)
%  plotval    = 0
%  stringin   = 'r*-'
%
% DESCRIPTION:
%  With this function the intersection of a gamut boundary with a constant
%  hue plane is determined and, if plotval is 1, plotted. The intersection is
%  determined in the same way as used with the gamut mapping function.
%  The input point can be given as a hue value, or as an image in some
%  colorspace. If the latter image is larger than 1, only the hue of the first
%  point is taken into account.
%
% EXAMPLE :
%    plot_gamut(0, '', 1);
%          (plots the intersection of the standard rgb gamut with the plane h = 0.)

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, June 2002.

function [CL, upper_gamut, lower_gamut, cusp_point] = plot_gamut(in, gamut_data, plotval, stringin)

if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList') % Avoid being in menu
      CL = struct('menu','none');
      return
end

if nargin < 1 | isempty( in)
   in = joinchannels('lab', 50, 1, 0); % point with h = 0;
end
if( nargin < 2 | isempty(gamut_data))
   gamut_data = make_gamut;
end
if( nargin < 3)
   plotval = 0;
end
if( nargin < 4)
   stringin = 'r*-';
end

   % preparation for the actual gamut mapping procedure: the input image is
   % reshaped in a 1-D image, in which the columns give the Lab of the points.

if( size(in, 1) ==1)
   h = double(in);
   s = size( in);
   if( s(1) > 1 | s(2) > 1)
      warning('The input image is not one pixel. Only the first pixel is used');
   end
   input_image = [50 cos(h), sin(h)];
else
   in = colorspace(in, 'lab');
   input_image = double(in{1});
   input_image(:, :, 2) = double(in{2});
   input_image(:, :, 3) = double(in{3});

   s = size( input_image);
   if( s(1) > 1 | s(2) > 1)
      warning('The input image is not one pixel. Only the first pixel is used');
   end
   input_image = reshape( input_image(1, 1, :), 1, 3);
end

[output_image, num_line] = find_gamut_points(input_image', gamut_data');
out = output_image(:);
out = reshape(out(1:4.*num_line), 4, num_line);
out = out';
CL = [out(:, 1) out(:, 2); out(:, 3), out(:, 4)];
CL = unique(CL, 'rows');

cusp_L = CL(end, 2);
cusp_C = CL(end, 1);
io = find( CL(:, 2) >= cusp_L);
upper_gamut = CL(io, :);
io = find( CL(:, 2) <= cusp_L);
lower_gamut = CL(io, :);

if( plotval == 1)
   plot( upper_gamut(:, 1), upper_gamut(:, 2), stringin);
   hold on
   plot( lower_gamut(:, 1), lower_gamut(:, 2), stringin);
   plot( cusp_C, cusp_L, stringin, 'MarkerSize', 15);
   xlabel('chroma C^*');
   ylabel('lightness L^*');
   fprintf(1, 'h=%f\n', atan2(input_image(3), input_image(2) ));
end

cusp_point = [cusp_C, cusp_L];
