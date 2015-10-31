%dip_findshift   Estimate the shift between images.
%    out = dip_findshift(in1, in2, method, param, mask)
%
%   in1
%      Image.
%   in2
%      Image.
%   method
%      Method used to estimate the shift. String containing one of the
%      following values:
%      'default', 'integer', 'cpf', 'ffts', 'mts', 'grs', 'iter', 'ncc'.
%   param
%      Real number.
%   mask
%      Image.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   DATATYPES:
%binary, integer, float, complex
%FUNCTION
%This function estimates the (sub-pixel) global shift between in1 and in2.
%The numbers found represent the shift of in1 with respect to in2, or the
%position of the first pixel of in2 in the coordinate system of in1. There
%are several methods used:
%
%The CPF method (marked as FFTS in the literature below) uses the phase of the
%cross-correlation (as calculated by CrossCorrelationFT) to estimate
%the shift. parameter sets the amount of frequencies used in this estimation.
%The maximum value that makes sense is sqrt(1/2). Any larger value will give the
%same result. Choose smaller values to ignore the higher frequencies, which
%have a smaller SNR and are more affected by aliasing. If parameter is set to
%0, the optimal found for images sub-sampled by a factor four will be used
%(parameter = 0.2).
%
%The MTS method (marked as GRS in the literature below) uses a first order
%Taylor approximation of the equation
%in1(t) = in2(t-s)
% at scale
%parameter. Setting parameter to zero, a scale of 1 will be used. This means
%that the images will be smoothed with a Gaussian kernel of 1.
%
%The ITER method is an iterative version of the MTS method.
%It is known that a single MTS method have bias due to
%truncation of the Taylor expansion series (Marijn Behuijen BSc thesis)
%This bias is proportional to the subpixel shift squared. As a result
%if Taylor method is applied iteratively and shift is incremented after 
%each iteration, the bias eventually become negligible. By using 3
%iterations & noticing that log(bias_increment) is a linear sequence,
%it is possible to correct bias that result in high precision O(1e-6).
%Undocumented feature about param for ITER method:
%if (param>0 & param<=0.1) => param specifies the desired accuracy
%if (param<0) => round(abs(param)) specifies number of iterations
%The iterative loop would exit early if the new iteration fails to improve shift
%
%The PROJ method compute shift in each dimension from images' projections.
%It is fast and fairly accurate for high SNR. Should not be used for low SNR
%
%The NCC method finds subpixel shift by nD quadratic fitting of a normalized 
%cross-correlation surface over 3^n neighborhood of the integer maximum (n=1,2,3)
%
%All methods require that the shift be small. Therefore, first the integer
%pixel is calculated, and both images are cropped to the common part.
%
%Setting method to DIP_FS_INTEGER_ONLY skips the second part. If method is
%0, DIP_FS_MTS is used.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in1     IMAGE *in1     Input image
%  dip_Image in2     IMAGE *in2     Input image
%  dip_FloatArray out            Estimated shift
%  dipf_FindShiftMethod method      int method     Estimation method
%  dip_float parameter     float parameter      Parameter
%
%The dipf_FindShiftMethod enumeration consists of the following flags:
%
%  DIPlib      Scil-Image     Description    DIP_FSM_DEFAULT      FSM_DEFAULT    Default method (MTS)
%  DIP_FSM_INTEGER_ONLY    FSM_INTEGER_ONLY     Find only integer shift
%  DIP_FSM_CPF    FSM_CPF     Use cross-correlation method
%  DIP_FSM_FFTS      FSM_CPF     Same
%  DIP_FSM_MTS    FSM_MTS     Use Taylor series method
%  DIP_FSM_GRS    FSM_MTS     Same
%  DIP_FSM_ITER   FSM_ITER    Iterative Taylor series method
%
%LITERATURE
%C.L. Luengo Hendriks, Improved Resolution in Infrared Imaging Using
%Randomly Shifted Images, M.Sc. Thesis, Delft University of Technology, 1998
%SEE ALSO
%
