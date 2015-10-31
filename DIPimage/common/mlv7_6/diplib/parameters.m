%Parameters   How parameters are translated into DIPlib enums.
%
%   dip_BoundaryArray: cell array containing one of these strings for
%   each dimension in the input image. It is not necessary to make a
%   cell if there is only one dimension.
%       symmetric = DIP_BC_SYMMETRIC_MIRROR
%       asymmetric = DIP_BC_ASYMMETRIC_MIRROR
%       periodic = DIP_BC_PERIODIC
%       asym_periodic = DIP_BC_ASYMMETRIC_PERIODIC
%       add_zeros = DIP_BC_ADD_ZEROS
%       add_max = DIP_BC_ADD_MAX_VALUE
%       add_min = DIP_BC_ADD_MIN_VALUE
%       0_order = DIP_BC_ZERO_ORDER_EXTRAPOLATE
%       1_order = DIP_BC_FIRST_ORDER_EXTRAPOLATE
%       2_order = DIP_BC_SECOND_ORDER_EXTRAPOLATE
%
%   DIPF_CLIP
%       both = DIP_CLIP_BOTH
%       low = DIP_CLIP_LOW
%       high = DIP_CLIP_HIGH
%       thresh/range = DIP_CLIP_THRESHOLD_AND_RANGE
%       low/high = DIP_CLIP_LOW_AND_HIGH_BOUNDS
%
%   DIP_DERIVATIVEFLAVOUR
%       gaussfir (also firgauss) = DIP_DF_FIRGAUSS
%       gaussiir (also iirgauss) = DIP_DF_IIRGAUSS
%       gaussft (also ftgauss) = DIP_DF_FTGAUSS
%       finitediff = DIP_DF_FINITEDIFF
%
%   DML_2DIP_SORTTYPE
%       quicksort = DIP_SORT_QUICK_SORT
%       distributionsort = DIP_SORT_DISTRIBUTION_SORT
%       insertionsort = DIP_SORT_INSERTION_SORT
%       heapsort = DIP_SORT_HEAP_SORT
%       [] or default = DIP_SORT_DEFAULT
%
%   DIP_FILTERSHAPE
%       rectangular = DIP_FLT_SHAPE_RECTANGULAR
%       elliptic = DIP_FLT_SHAPE_ELLIPTIC
%       diamond = DIP_FLT_SHAPE_DIAMOND
%       parabolic = DIP_FLT_SHAPE_PARABOLIC
%       user_defined = DIP_FLT_SHAPE_STRUCTURING_ELEMENT
%       interpolated_line = DIP_FLT_SHAPE_INTERPOLATED_LINE
%       discrete_line = DIP_FLT_SHAPE_DISCRETE_LINE
%       periodic_line = DIP_FLT_SHAPE_PERIODIC_LINE
%       [] or default = DIP_FLT_SHAPE_DEFAULT
%
%   DIPF_FOURIERTRANSFORM
%       forward = DIP_TR_FORWARD
%       inverse = DIP_TR_INVERSE
%
%   DIPF_IMAGERESTORATION
%       verbose = DIP_RESTORATION_VERBOSE
%       symmetric_psf = DIP_RESTORATION_SYMMETRIC_PSF
%       otf = DIP_RESTORATION_OTF
%       sieve = DIP_RESTORATION_SIEVE
%       normalize = DIP_RESTORATION_NORMALIZE
%       use_inputs = DIP_RESTORATION_USE_INPUTS
%
%   DIPF_INTERPOLATION
%       bspline = DIP_INTERPOLATION_BSPLINE
%       4-cubic = DIP_INTERPOLATION_FOURTH_ORDER_CUBIC
%       3-cubic = DIP_INTERPOLATION_THIRD_ORDER_CUBIC
%       linear (also bilinear) = DIP_INTERPOLATION_LINEAR
%       zoh = DIP_INTERPOLATION_ZERO_ORDER_HOLD
%       lanczos2 = DIP_INTERPOLATION_LANCZOS_2
%       lanczos3 = DIP_INTERPOLATION_LANCZOS_3
%       lanczos4 = DIP_INTERPOLATION_LANCZOS_4
%       lanczos6 = DIP_INTERPOLATION_LANCZOS_6
%       lanczos8 = DIP_INTERPOLATION_LANCZOS_8
%       [] or default = DIP_INTERPOLATION_DEFAULT
%
%   DIPF_SUBPIXELEXTREMUMMETHOD
%       linear = DIP_SEM_LINEAR
%       parabolic = DIP_SEM_PARABOLIC_SEPARABLE
%       gaussian = DIP_SEM_GAUSSIAN_SEPARABLE
%       bspline = DIP_SEM_BSPLINE
%       parabolic_nonseparable = DIP_SEM_PARABOLIC
%       gaussian_nonseparable = DIP_SEM_GAUSSIAN
%       [] or default = DIP_SEM_DEFAULT
%
%   DIPF_SUBPIXELEXTREMUMPOLARITY
%       maximum = DIP_SEP_MAXIMUM
%       minimum = DIP_SEP_MINIMUM
%
%
%   DIP_MPHEDGETYPE
%       texture = DIP_MPH_TEXTURE
%       object = DIP_MPH_OBJECT
%       both = DIP_MPH_BOTH
%
%   DIP_MPHTOPHATPOLARITY
%       black = DIP_MPH_BLACK
%       white = DIP_MPH_WHITE
%
%   DIPF_MPHSMOOTHING
%       open/close = DIP_MPH_OPEN_CLOSE
%       close/open = DIP_MPH_CLOSE_OPEN
%       average = DIP_MPH_AVERAGE
%
%   DIPF_LEESIGN
%       unsigned = DIP_LEE_UNSIGNED
%       signed = DIP_LEE_SIGNED
%
%   DIP_GRADIENTDIRECTIONATANFLAVOUR
%       half_circle = DIP_HALF_CIRCLE
%       full_circle = DIP_FULL_CIRCLE
%
%   DIPF_TESTOBJECT
%       ellipsoid = DIP_TEST_OBJECT_ELLIPSOID
%       box = DIP_TEST_OBJECT_BOX
%       ellipsoidshell = DIP_TEST_OBJECT_ELLIPSOID_SHELL
%       boxshell = DIP_TEST_OBJECT_BOX_SHELL
%       user_supplied = DIP_TEST_OBJECT_USER_SUPPLIED
%
%   DIPF_TESTPSF
%       gaussian = DIP_TEST_PSF_GAUSSIAN
%       incoherent_otf = DIP_TEST_PSF_INCOHERENT_OTF
%       user_supplied = DIP_TEST_PSF_USER_SUPPLIED
%       none = DIP_TEST_PSF_NONE
%
%   DIPF_INCOHERENTOTF
%       stokseth = DIP_MICROSCOPY_OTF_STOKSETH
%       hopkins = DIP_MICROSCOPY_OTF_HOPKINS
%
%   DIPF_EXPFITDATA
%       mean = DIP_ATTENUATION_EXP_FIT_DATA_MEAN
%       percentile = DIP_ATTENUATION_EXP_FIT_DATA_PERCENTILE
%       [] or default = DIP_ATTENUATION_EXP_FIT_DATA_DEFAULT
%
%   DIPF_EXPFITSTART
%       firstpixel = DIP_ATTENUATION_EXP_FIT_START_FIRST_PIXEL
%       globalmax = DIP_ATTENUATION_EXP_FIT_START_GLOBAL_MAXIMUM
%       firstmax = DIP_ATTENUATION_EXP_FIT_START_FIRST_MAXIMUM
%       [] or default = DIP_ATTENUATION_EXP_FIT_START_DEFAULT
%
%   DIPF_ATTENUATIONCORRECTION
%       lt2 = DIP_ATTENUATION_RAC_LT2
%       lt1 = DIP_ATTENUATION_RAC_LT1
%       det = DIP_ATTENUATION_RAC_DET
%       [] or default = DIP_ATTENUATION_DEFAULT
%
%   DIP_ENDPIXELCONDITION
%       looseendsaway = DIP_ENDPIXEL_CONDITION_LOOSE_ENDS_AWAY
%       natural = DIP_ENDPIXEL_CONDITION_NATURAL
%       1neighbor = DIP_ENDPIXEL_CONDITION_KEEP_WITH_ONE_NEIGHBOR
%       2neighbors = DIP_ENDPIXEL_CONDITION_KEEP_WITH_TWO_NEIGHBORS
%       3neighbors = DIP_ENDPIXEL_CONDITION_KEEP_WITH_THREE_NEIGHBORS
%
%   DIPF_CONTRASTSTRETCH
%       linear = DIP_CST_LINEAR
%       slinear = DIP_CST_SIGNED_LINEAR
%       logarithmic = DIP_CST_LOGARITHMIC
%       slogarithmic = DIP_CST_SIGNED_LOGARITHMIC
%       erf = DIP_CST_ERF
%       decade = DIP_CST_DECADE
%       sigmoid = DIP_CST_SIGMOID
%       clip = DIP_CST_CLIP
%       01 = DIP_CST_01
%       pi = DIP_CST_PI
%
%   DIPF_IMAGEREPRESENTATION
%       spatial = DIP_IMAGE_REPRESENTATION_SPATIAL
%       spectral = DIP_IMAGE_REPRESENTATION_SPECTRAL
%
%   DIPF_FINITEDIFFERENCE
%       m101 = DIP_FINITE_DIFFERENCE_M101
%       0m11 = DIP_FINITE_DIFFERENCE_0M11
%       m110 = DIP_FINITE_DIFFERENCE_M110
%       1m21 = DIP_FINITE_DIFFERENCE_1M21
%       121 = DIP_FINITE_DIFFERENCE_121
%
%   DIPF_DISTANCETRANSFORM
%       fast = DIP_DISTANCE_EDT_FAST
%       ties = DIP_DISTANCE_EDT_TIES
%       true = DIP_DISTANCE_EDT_TRUE
%       bruteforce = DIP_DISTANCE_EDT_BRUTE_FORCE
%
%   DIPF_REGULARIZATIONPARAMETER
%       manual = DIP_RESTORATION_REG_PAR_MANUAL
%       gcv = DIP_RESTORATION_REG_PAR_GCV
%       cls = DIP_RESTORATION_REG_PAR_CLS
%       snr = DIP_RESTORATION_REG_PAR_SNR
%       edf = DIP_RESTORATION_REG_PAR_EDF
%       ml = DIP_RESTORATION_REG_PAR_ML
%       edf_cv = DIP_RESTORATION_REG_PAR_EDF_CV
%       cls_cv = DIP_RESTORATION_REG_PAR_CLS_CV
%       snr_cv = DIP_RESTORATION_REG_PAR_SNR_CV
%       variance_cv = DIP_RESTORATION_VARIANCE_CV
%
%   DIPF_FINDSHIFTMETHOD
%       integer = DIP_FSM_INTEGER_ONLY
%       cpf = DIP_FSM_CPF
%       ffts = DIP_FSM_FFTS
%       mts = DIP_FSM_MTS
%       grs = DIP_FSM_GRS
%       iter = DIP_FSM_ITER
%       proj = DIP_FSM_PROJ
%       ncc = DIP_FSM_NCC
%       [] or default = DIP_FSM_DEFAULT
%
%   DML_2DIPF_CORRELATION_ESTIMATOR
%       random = DIP_CORRELATION_ESTIMATOR_RANDOM
%       grid = DIP_CORRELATION_ESTIMATOR_GRID
%       [] = DIP_CORRELATION_ESTIMATOR_DEFAULT
%
%   DML_2DIPF_CORRELATION_NORMALISATION
%       none = DIP_CORRELATION_NORMALISATION_NONE
%       volume_fraction = DIP_CORRELATION_NORMALISATION_VOLUME_FRACTION
%       volume_fraction^2 = DIP_CORRELATION_NORMALISATION_VOLUME_FRACTION_SQUARE
%       [] = DIP_CORRELATION_NORMALISATION_NONE
%
%   DIP_BACKGROUNDVALUE
%       zero = DIP_BGV_ZERO
%       max = DIP_BGV_MAX_VALUE
%       min = DIP_BGV_MIN_VALUE
%       [] or default = DIP_BGV_DEFAULT
%
%   DIP_MORPHOLOGICALSIEVEFLAVOUR
%       closing = DIP_MSF_CLOSING
%       opening = DIP_MSF_OPENING
%       mfilter = DIP_MSF_MFILTER
%       nfilter = DIP_MSF_NFILTER
%
%   DIPIO_PHOTOMETRICINTERPRETATION
%       grayvalue, gray, grey = DIPIO_PHM_GREYVALUE
%       RGB = DIPIO_PHM_RGB
%       YCbCr = DIPIO_PHM_YCBCR
%       CIElab, L*a*b*, Lab = DIPIO_PHM_CIELAB
%       CIEluv, L*u*v*, Luv = DIPIO_PHM_CIELUV
%       CMYK = DIPIO_PHM_CMYK
%       CMY = DIPIO_PHM_CMY
%       XYZ = DIPIO_PHM_CIEXYZ
%       Yxy = DIPIO_PHM_CIEYXY
%       HCV = DIPIO_PHM_HCV
%       HSV = DIPIO_PHM_HSV
%       R'G'B' = DIPIO_PHM_RGB_NONLINEAR
%       [] = DIPIO_PHM_DEFAULT
%
%   DML_2DIPIO_COMPRESSIONMETHOD
%       none = DIPIO_CMP_NONE
%       ZIP = DIPIO_CMP_LZW
%       GZIP = DIPIO_CMP_LZW
%       LZW = DIPIO_CMP_LZW
%       Compress = DIPIO_CMP_COMPRESS
%       PackBits = DIPIO_CMP_PACKBITS
%       Thunderscan = DIPIO_CMP_THUNDERSCAN
%       NEXT = DIPIO_CMP_NEXT
%       CCITTRLE = DIPIO_CMP_CCITTRLE
%       CCITTRLEW = DIPIO_CMP_CCITTRLEW
%       CCITTFAX3 = DIPIO_CMP_CCITTFAX3
%       CCITTFAX4 = DIPIO_CMP_CCITTFAX4
%       deflate = DIPIO_CMP_DEFLATE
%       JPEG = DIPIO_CMP_JPEG
%       [] = DIPIO_CMP_DEFAULT
%
%   DML_2DIPF_GREYVALUESORTORDER
%       low_first = DIP_GVSO_LOW_FIRST
%       high_first = DIP_GVSO_HIGH_FIRST

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000.
% Last change: 11 October 2007.
