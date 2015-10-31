%JPEG_QUALITY_SCORE   Estimate perceptual JPEG quality without reference
%
% SYNOPSIS:
%  score = jpeg_quality_score(image)
%
% EXAMPLE:
%  a = readim;
%  imwrite(uint8(a),'temp.jpg','jpg','Quality',10);
%  b = readim('temp.jpg');
%  jpeg_quality_score(b)
%  imwrite(uint8(a),'temp.jpg','jpg','Quality',50);
%  b = readim('temp.jpg');
%  jpeg_quality_score(b)
%  imwrite(uint8(a),'temp.jpg','jpg','Quality',90);
%  b = readim('temp.jpg');
%  jpeg_quality_score(b)
%  delete('temp.jpg')
%
% LITERATURE:
%  Zhou Wang, Hamid R. Sheikh and Alan C. Bovik,
%   "No-Reference Perceptual Quality Assessment of JPEG Compressed Images,"
%   Proceedings of IEEE 2002 International Conferencing on Image Processing, pp 477-480.
%
% NOTE:
%  This function works for grey-value images, the paper does not describe
%  how to apply this measure to colour images.

% (C) Copyright 2012, Cris Luengo, All rights reserved
% Centre for Image Analysis, Uppsala, Sweden.

function S = jpeg_quality_score(img)

if nargin ~= 1
   error('Input image expected.')
end

if ischar(img) & strcmp(img,'DIP_GetParamList')
   S = struct('menu','none');
   return
end

img = dip_image(img);
if ~isscalar(img) | ndims(img)~=2
   error('This function only works for 2D grey-value images.');
end
sz = imsize(img);
if all(sz<=8)
   error('Image too small for a JPEG quality score.');
end   

d_h = dip_finitedifference(img,0,'0m11');
d_v = dip_finitedifference(img,1,'0m11');

% "Blockiness"
B_h = mean(abs(d_h(7:8:end-1,:)));
B_v = mean(abs(d_v(:,7:8:end-1)));
B = ( B_h + B_v )/2;

% "Activity" measure 1 (average absolute difference between in-block image samples)
A_h = (8*mean(abs(d_h))-B_h)/7;
A_v = (8*mean(abs(d_v))-B_v)/7;
A = ( A_h + A_v )/2;

% "Activity" measure 2 (zero-crossing rate)
Z_h = mean(d_h(0:end-1,:)*d_h(1:end,:)<0);
Z_v = mean(d_v(:,0:end-1)*d_v(:,1:end)<0);
Z = ( Z_h + Z_v )/2;

% Total quality score
S = -245.9 + 261.9 * power(B,-0.0240) * power(A, 0.0160) * power(Z, 0.0064);
