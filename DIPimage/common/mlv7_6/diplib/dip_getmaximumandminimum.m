%dip_getmaximumandminimum   statistics function.
%    [max, min] = dip_getmaximumandminimum(in, mask)
%
%   in
%      Image.
%   mask
%      Mask image. Can be [] for no mask.
%   max
%      Real number.
%   min
%      Real number.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo,April 2001.

%   DATA TYPES:
%integer, float
%FUNCTION
%This function gets both the maximum and minimum of all the pixel values in
%the in image. Optionally, a mask image can be specified to exclude
%pixels from this search.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image mask (0)      IMAGE *mask    Mask image
%  dip_float *max    double *max    Pointer to maximum variable
%  dip_float *min    double *min    Pointer to minimum variable
%        int display    Display results
%
%SEE ALSO
% Maximum , Minimum
