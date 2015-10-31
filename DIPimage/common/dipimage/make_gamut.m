%MAKE_GAMUT   Make the gamut for given device and measured values
%
% SYNOPSIS:
%  gamut_data = make_gamut( device_values, measured values, XYZ_white)
%
% DESCRIPTION:
%  Gamut data is acquired, which can be used in other functions. The idea is
%  that the relations between reference points are found in the device color
%  space (RGB and CMY).  The associated perceptual color values
%  (in XYZ/CIELAB) are stored in gamut_data. If reference data is given the
%  variable XYZ_white is not used.
%  This function assumes that there are 6 cube planes in the device gamut,
%  so it only works for RGB and CMY as device values.
%
%  To find the relations in the device colorspace first the 6 planes of the
%  device gamut are identified. On each of these planes the delaunay
%  triangulation is determined. Of each triangle the following values are
%  stored:
%     XYZ of point 1
%     XYZ of point 2
%     XYZ of point 3
%     normal vector of the triangle (in XYZ)
%     distance to the origin of the XYZ space
%     area of the triangle (in XYZ)
%  All XYZ's have to be replaced with Lab's for reference values in the
%  CIELAB space
%
%  If no arguments are given or the first argument is 'RGB', the gamut for
%  a standard RGB device is determined. The second argument is the number of
%  sampling points in each direction (default 11), the third argument is the
%  XYZ of the whitepoint (default d65).
%
%  This function uses the function delaunayn, which is only available in
%  matlab version 6 and up.
%
% EXAMPLE:
%  gamut_bound = make_gamut('RGB', 21);

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
%  Judith Dijk, August 2002.
% 17 December 2009: Using new function MATLABVER_GE.

function gamut_bound =  make_gamut(device_values, ref_values, XYZ_white)

if nargin == 1 & ischar(device_values) & strcmp(device_values,'DIP_GetParamList') % Avoid being in menu
      gamut_bound = struct('menu','none');
      return
end

if( nargin < 1)
   device_values = 'RGB';
end
if ~matlabver_ge([6,0])
   error('This function works only for matlab version 6 and up');
end
if isa(device_values, 'char')
   if( ~strcmp(device_values, 'RGB') & ~strcmp(device_values, 'rgb'))
      error('The first argument is not recognized');
   end
   if nargin < 2, num = 11; else num = ref_values; end
   if( num < 2 ), error('Give higer number for RGB spacings'); end
   if( nargin < 3), XYZ_white = [0.9505, 1. 1.0888]; end

   x = [0:100./(num-1):100]'.*2.55;
   y = zeros( num.^2, 2);
   for( i=1:num)
      y(num.*(i-1)+1:num.*i, 2) =x;
      y(num.*(i-1)+1:num.*i, 1) =x(i);
   end
   a = num.^2 ;
   z = zeros( a.*6, 3);
   z(1:a, 2:3) = y;
   z(a+1:2.*a, [1, 3]) = y;
   z(2.*a+1:3.*a, 1:2) = y;
   z(3.*a+1:6.*a, :) = z(1:3.*a,:);
   z(3.*a+1:4.*a, 1) =  255;
   z(4.*a+1:5.*a, 2) =  255;
   z(5.*a+1:6.*a, 3) =  255;

   z = reshape(z, num.^2.*6, 1, 3);
   R = dip_image( z(:, :, 1));
   G = dip_image( z(:, :, 2));
   B = dip_image( z(:, :, 3));

   device_values = joinchannels( 'RGB', R, G, B);
   ref_values = colorspace( device_values, 'lab');
else
   if( nargin < 2)
      error('There should be two arguments unless the first argument = RGB');
   end
   if( ~isa( ref_values, 'dip_image') & ~isa( ref_values, 'dip_image_array'))
      error('The reference values should be given in a dipimage'); end
   if( ~isa( device_values, 'dip_image') & ~isa( device_values, 'dip_image_array'))
      error('The device values should be given in a dipimage'); end

   col = colorspace(ref_values);
   if( ~strcmp( col, 'L*a*b*') & ~strcmp( col, 'XYZ'))
      error('The reference values should be in L*a*b* or XYZ');
   end
   col_in = colorspace(device_values);
   if( ~strcmp( col_in, 'CMY') & ~strcmp( col_in, 'CMYK') & ~strcmp( col_in, 'RGB'))
      error('The device values should be in CMY(K) or RGB');
   end
end
% Make doubles of the color image planes

dev_bound = double( device_values{1} );
dev_bound(:, :, 2) = double( device_values{2} );
dev_bound(:, :, 3) = double( device_values{3} );
ref_bound = double( ref_values{1} );
ref_bound(:, :, 2) = double( ref_values{2} );
ref_bound(:, :, 3) = double( ref_values{3} );

dev_bound = squeeze( dev_bound );
ref_bound = squeeze( ref_bound );
s = size( dev_bound );
s_ref = size( ref_bound );
if( sum( s == s_ref )~= size(s, 2))
   error('the size of the device values and the reference values should be equal');
end
if( size(s, 2)> 2)
   dev_bound = squeeze( reshape( dev_bound, s(1).*s(2), s(3)));
   ref_bound = squeeze( reshape( ref_bound, s(1).*s(2), s(3)));
end
s = size( dev_bound );
if( s(2) ~= 3)
      error('there should be a 3 dimension in the reference values');
end
% identify the 6 planes of the input device

minim = min( dev_bound(:, 1));
maxim = max( dev_bound(:, 1));
io{ 1 } = find( dev_bound(:, 1) == minim);
io{ 2 } = find( dev_bound(:, 1) == maxim);
io{ 3 } = find( dev_bound(:, 2) == minim);
io{ 4 } = find( dev_bound(:, 2) == maxim);
io{ 5 } = find( dev_bound(:, 3) == minim);
io{ 6 } = find( dev_bound(:, 3) == maxim);
io2 = [ 2 3; 2 3; 1 3; 1 3; 1 2; 1 2];

% determine the delaunay triangulation of each plane and store the values.

gamut_bound = [];
for j=1:6
   val_in = dev_bound(io{j}, io2(j, :));
   T = delaunayn(val_in);
   io_in = io{j};
   for i=1:size(T, 1)
      k = io_in(T(i,:));
      v1 = ref_bound(k(1), :);
      v2 = ref_bound(k(2), :);
      v3 = ref_bound(k(3), :);
      n = cross( v2-v1, v3-v1);
      c = sum(n.*v1);
      tot_opp = abs(sum(n))./2;
      gamut_bound = [gamut_bound; v1 v2 v3 n c tot_opp];
   end
end



