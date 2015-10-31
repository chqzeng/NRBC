% Two-dimensional convolution filter
% Select the implementation from either the DIPimage toolbox or the SIGNAL processing toolbox
% DIPimage: http://www.ph.tn.tudelft.nl/DIPimage

function output_im = filt2dim(input1_im, input2_im)

% MATLAB's signal processing toolbox
output_im = filter2(input1_im, input2_im);

% DIPimage toolbox
% output_im = convolve(input2_im, input1_im);