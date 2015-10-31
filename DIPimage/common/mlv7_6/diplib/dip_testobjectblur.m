%dip_testobjectblur   TestObject generation function.
%    out = dip_testobjectblur(object, psf, xNyquist, testPSF)
%
%   object
%      Image.
%   psf
%      Image.
%   xNyquist
%      Real number.
%   testPSF
%      PSF shape. String containing one of the following values:
%      'gaussian', 'incoherent_otf', 'user_supplied', 'none'.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   DATATYPES:
%binary, integer, float
%FUNCTION
%This function blurs a testobject with a Gaussian psf, with a two
%dimensional in focus diffraction limited incoherent PSF
%or with an user-supplied PSF.
%The xNyquist parameter specifies the oversampling factor of the incoherent
%PSF and Gaussian PSF. The sigma of the Gaussian PSF is equal to 0.9 * xNyquist.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image object     IMAGE *object     Input Object Image
%  dip_Image psf     IMAGE *psf     User supplied PSF
%  dip_Image convolved     IMAGE *convolved     Output Image
%  dip_float xNyquist      double xNyquist      Oversampling Factor
%  dipf_TestPSF testPSF    int testPSF    TestPSF
%
%The dipf_TestPSF enumaration consists of the following flags:
%
%     DIP_TEST_PSF_GAUSSIAN      Gaussian PSF         DIP_TEST_PSF_INCOHERENT_OTF      in-focus, diffraction limited, incoherent PSF         DIP_TEST_PSF_USER_SUPPLIED    User supplied PSF with the psf image         DIP_TEST_PSF_NONE    no blurring
%SEE ALSO
% TestObjectCreate , TestObjectModulate , TestObjectAddNoise
