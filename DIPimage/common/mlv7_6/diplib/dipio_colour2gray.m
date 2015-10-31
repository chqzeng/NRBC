%dipio_colour2gray   Convert 3D image with colour information to a 2D grayvalue image.
%    out = dipio_colour2gray(in, photometric)
%
%   in
%      Image.
%   photometric
%      String containing one of the following values:
%      'gray', 'RGB', 'L*a*b*', 'L*u*v*', 'CMYK', 'CMY', 'XYZ', 'Yxy',
%      'HCV', 'HSV', 'R''G''B'''
%
% This function converts a colour image, as read by dipio_imagereadtiff, to a grayvalue
% image. in is expected to be an ND image, with the colour information along the last
% axis. out will be a (N-1)D scalar image.
%
% KNOWN BUGS
% The conversion extracts the luminosity, intensity or value of the image, depending
% the source colour space. Thus, the same image in a different colour space will
% yield a different gray-value image. Also, CMY and CMYK conversion is not implemented.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000.


