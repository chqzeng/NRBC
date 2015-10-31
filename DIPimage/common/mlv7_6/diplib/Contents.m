% DIPlib, a scientific image analysis library
% Version 2.7   30-Oct-2014
%
% DIPlib, a scientific image analysis library
%    authors: Michael van Ginkel, Geert van Kempen, Cris Luengo
% dipIO, the file I/O library for DIPlib
%    authors: Cris Luengo, Bernd Rieger & Geert van Kempen
% MATLAB interface to DIPlib
%    authors: Cris Luengo, Michael van Ginkel
% Project supervisor: Lucas J. van Vliet
% Contact: info@diplib.org
%
% The available functions are:
%   dip_adaptivebanana            - Adaptive Gaussian Filter in banana neighborhood.
%   dip_adaptivegauss             - Adaptive Gaussian Filter.
%   dip_adaptivepercentile        - Adaptive Percentile Filter.
%   dip_adaptivepercentilebanana  - Adaptive Percentile Filter in Banana.
%   dip_and                       - Logical and between two images.
%   dip_arcfilter                 - xy-separable bilateral filter
%   dip_areaopening               - Area opening and closing
%   dip_arith                     - Arithmetic operations between two images.
%   dip_armdhistogram             - Multidimensional histogram.
%   dip_attenuationcorrection     - Attenuation correction algorithm.
%   dip_biasedsigma               - Adaptive edge sharpening & contrast enhancing filter.
%   dip_bilateral                 - xy-separable bilateral filter
%   dip_bilateralfilter           - brute-force (full kernel) bilateral filter
%   dip_binaryanchorskeleton2d    - binary skeleton operation.
%   dip_binaryclosing             - Binary Mathematical Morphology.
%   dip_binarydilation            - Binary Mathematical Morphology.
%   dip_binaryerosion             - Binary Mathematical Morphology.
%   dip_binarynoise               - Generates an image disturbed by binary noise.
%   dip_binaryopening             - Binary Mathematical Morphology.
%   dip_binarypropagation         - Binary Mathematical Morphology.
%   dip_binaryrandomvariable      - Binary random variable generator.
%   dip_binaryskeleton3d          - binary skeleton operation.
%   dip_canny                     - Canny edge detector.
%   dip_chordlength               - .
%   dip_cityblockdistancetopoint  - Distance generation function.
%   dip_clip                      - Point operation.
%   dip_closing                   - Mathematical morphology filter.
%   dip_compare                   - Compares two images.
%   dip_contraststretch           - Point operation.
%   dip_convolve1d                - 1D convolution filter.
%   dip_convolveft                - Fourier transform based Convolution filter.
%   dip_crop                      - Remove the outer parts of an image.
%   dip_croptobetterfouriersize   - Crops to a size more suitable to the FFT algorithm.
%   dip_crosscorrelationft        - Estimate the shift between images.
%   dip_cumulativesum             - statistics function.
%   dip_danielsonlinedetector     - Line detector.
%   dip_derivative                - Derivative filter.
%   dip_dgg                       - Second order derivative filter.
%   dip_dilation                  - Mathematical morphology filter.
%   dip_directedpathopening       - Path opening in a specific direction.
%   dip_dmllibfile                - Returns the name of the dmllib.so file to link to.
%   dip_drawline                  - .
%   dip_drawlines                 - (PRIVATE FUNCTION)
%   dip_edgeobjectsremove         - Remove binary edge objects.
%   dip_edt                       - Euclidean distance transform.
%   dip_ellipticdistancetopoint   - Distance generation function.
%   dip_erfclip                   - Point Operation.
%   dip_erosion                   - Mathematical morphology filter.
%   dip_euclideandistancetopoint  - Distance generation function.
%   dip_euclideanskeleton         - binary skeleton operation.
%   dip_exit                      - Terminates the DIPlib library
%   dip_exponentialfitcorrection  - Exponential fit based attenuation correction.
%   dip_extendregion              - Image manipulation functions.
%   dip_findshift                 - Estimate the shift between images.
%   dip_finitedifference          - a linear filter.
%   dip_finitedifferenceex        - Finite Difference Filter.
%   dip_fouriertransform          - Computes the Fourier transform.
%   dip_ftbox                     - Generates the Fourier transform of a box.
%   dip_ftcross                   - Generates the Fourier transform of a cross.
%   dip_ftcube                    - Generates the Fourier transform of a cube.
%   dip_ftellipsoid               - Generates Fourier transform of a ellipsoid.
%   dip_ftgaussian                - Generates the Fourier transform of a Gaussian.
%   dip_ftsphere                  - Generated Fourier transform of a sphere.
%   dip_gaboriir                  - Infinite impulse response filter.
%   dip_gauss                     - Gaussian Filter.
%   dip_gaussft                   - Gaussian Filter through the Fourier domain.
%   dip_gaussiannoise             - Generate an image disturbed by Gaussian noise.
%   dip_gaussianrandomvariable    - Gaussian random variable generator.
%   dip_gaussiansigma             - Adaptive Gaussian smoothing filter.
%   dip_gaussiir                  - Infinite impulse response filter.
%   dip_gdt                       - Grey weighted distance transform.
%   dip_generalconvolution        - General convolution filter.
%   dip_generalisedkuwahara       - Generalised Kuwahara filter.
%   dip_generalisedkuwaharaimproved - Generalised Kuwahara filter.
%   dip_generateramp              - Generates a ramp image.
%   dip_getboundary               - Get global Boundary Conditions.
%   dip_getlibraryinformation     - Display information on the DIPlib library
%   dip_getmaximumandminimum      - statistics function.
%   dip_getmeasurefeatures        - Get list of measurement features to use in dip_measure
%   dip_getnumberofthreads        - Set the global number of threads.
%   dip_getobjectlabels           - Gets the object label values of a labeled image.
%   dip_gettruncation             - Get the global gaussian truncation.
%   dip_gradientdirection2d       - Derivative filter.
%   dip_gradientmagnitude         - Derivative filter.
%   dip_growregions               - Grow regions in a labelled image
%   dip_growregionsweighted       - Grow regions in a labelled image
%   dip_hartleytransform          - Computes the Hartley transform.
%   dip_hysteresisthreshold       - Hysteresis thresholding.
%   dip_idivergence               - Idivergence.
%   dip_imagechaincode            - Obtain the chain codes for the objects in the image
%   dip_imagelut                  - Lookup table
%   dip_imarlut                   - lookup responses from an image array
%   dip_incoherentotf             - Generates an incoherent OTF.
%   dip_incoherentpsf             - Generates an incoherent PSF.
%   dip_initialise_libs           - Initialises the DIPlib library
%   dip_isodatathreshold          - Point Operation.
%   dip_kuwahara                  - Edge perserving smoothing filter.
%   dip_kuwaharaimproved          - Edge perserving smoothing filter.
%   dip_label                     - Label objects in binary image.
%   dip_laplace                   - Second order derivative filter.
%   dip_laplacemindgg             - Second order derivative filter.
%   dip_laplaceplusdgg            - Second order derivative filter.
%   dip_lee                       - Mathematical morphology filter .
%   dip_linefit                   - Robust line fit of a 2D point set
%   dip_localminima               - Local minima detection.
%   dip_map                       - Remaps an image.
%   dip_maxima                    - Detects local maxima.
%   dip_maximum                   - statistics function.
%   dip_maximumpixel              - Gets the value and position of the maximum.
%   dip_mdhistogram               - (PRIVATE FUNCTION)
%   dip_mean                      - statistics function.
%   dip_measure                   - Measure stuff in a labeled image.
%   dip_medianfilter              - Non-linear smoothing filter.
%   dip_minima                    - Detects local minima.
%   dip_minimum                   - statistics function.
%   dip_minimumpixel              - Gets the value and position of the minimum.
%   dip_mirror                    - Mirrors an image.
%   dip_modulofloatperiodic       - .
%   dip_morphologicalgradmag      - Mathematical morphology filter.
%   dip_morphologicalrange        - Mathematical morphology filter.
%   dip_morphologicalreconstruction - Morphological grey-value reconstruction.
%   dip_morphologicalsmoothing    - Mathematical morphology filter.
%   dip_morphologicalthreshold    - Mathematical morphology filter.
%   dip_multiscalemorphgrad       - Mathematical morphology filter.
%   dip_nonmaximumsuppression     - Non-maximum suppression.
%   dip_objecttomeasurement       - Convert object label value to measurement value.
%   dip_opening                   - Mathematical morphology filter.
%   dip_or                        - Logical or between two images.
%   dip_orientationspace          - .
%   dip_orientedgauss             - .
%   dip_paircorrelation           - .
%   dip_pathopening               - Omnidirectional path opening.
%   dip_percentile                - statistics function.
%   dip_percentilefilter          - Rank-order filter.
%   dip_pgst3dline                - Parametric Gradient Structure Tensor
%   dip_pgst3dsurface             - Parametric Gradient Structure Tensor
%   dip_poissonnoise              - Generate an image disturbed by Poisson noise.
%   dip_poissonrandomvariable     - Poisson random variable generator.
%   dip_positionmaximum           - Position of the maximum along projectDim.
%   dip_positionminimum           - Position of the minimum along projectDim.
%   dip_positionpercentile        - Position of the percentile along projectDim.
%   dip_probabilisticcorrelation  - .
%   dip_prod                      - statistics function.
%   dip_pseudoinverse             - Image restoration filter.
%   dip_quantizedbilateralfilter  - piece-wise linear speedup for bilateral filter
%   dip_radialdistribution        - .
%   dip_radialmaximum             - statistics function.
%   dip_radialmean                - statistics function.
%   dip_radialminimum             - statistics function.
%   dip_radialsum                 - statistics function.
%   dip_randomseed                - Random seed function.
%   dip_randomvariable            - Random number generator.
%   dip_rangethreshold            - Point Operation.
%   dip_rankcontrastfilter        - .
%   dip_resampleat                - Interpolation at irregular pixel positions. (<=3D only)
%   dip_resampling                - Interpolation function.
%   dip_resamplingft              - .
%   dip_rotation                  - Interpolation function.
%   dip_rotation3d                - Interpolation function.
%   dip_rotation3d_axis           - Interpolation function.
%   dip_rotation3daxis            - Interpolation function.
%   dip_rotation_with_bgval       - Interpolation function.
%   dip_seededwatershed           - Watershed initialised with custom seeds.
%   dip_separableconvolution      - Separable convolution filter.
%   dip_setboundary               - Set global boundary conditions.
%   dip_setnumberofthreads        - Set the global number of threads.
%   dip_settruncation             - Set the global gaussian truncation.
%   dip_sharpen                   - Enhance an image.
%   dip_shift                     - an image manipulation function.
%   dip_sigma                     - Adaptive uniform smoothing filter.
%   dip_simplegaussfitimage       - .
%   dip_simulatedattenuation      - Simulation of the attenuation process.
%   dip_skewing                   - Interpolation function.
%   dip_smallobjectsremove        - .
%   dip_sobelgradient             - A linear gradient filter.
%   dip_sortindices               - Sorts the indices into an image according to grey-value.
%   dip_standarddeviation         - statistics function.
%   dip_structureadaptivegauss    - Structure Adaptive Gaussian Filter.
%   dip_structureanalysis         - .
%   dip_structuretensor2d         - Two dimensional Structure Tensor.
%   dip_structuretensor3d         - Three dimensional Structure Tensor.
%   dip_subpixellocation          - Detect local maxima with subpixel accuracy
%   dip_subpixelmaxima            - Detect local maxima with subpixel accuracy
%   dip_subpixelminima            - Detect local minima with subpixel accuracy
%   dip_subsampling               - Interpolation function.
%   dip_sum                       - statistics function.
%   dip_svd                       - Singular value decomposition
%   dip_symmetriceigensystem2     - Eigenvalue/-vector analysis for a sym 2x2 matrix.
%   dip_symmetriceigensystem3     - Eigenvalue/-vector analysis for a sym 3x3 matrix.
%   dip_systemdoctor              - Checks the DIPlib library installation
%   dip_tensorimageinverse        -    
%   dip_testobjectaddnoise        - TestObject generation function.
%   dip_testobjectblur            - TestObject generation function.
%   dip_testobjectcreate          - TestObject generation function.
%   dip_testobjectmodulate        - TestObject generation function.
%   dip_threshold                 - Point Operation.
%   dip_tikhonovmiller            - Image restoration filter.
%   dip_tikhonovregparam          - Determine the value of the regularisation parameter.
%   dip_tophat                    - Mathematical morphology filter.
%   dip_uniform                   - Uniform filter.
%   dip_uniformnoise              - Generate an image disturbed by uniform noise.
%   dip_uniformrandomvariable     - Uniform random variable generator.
%   dip_upperenvelope             - Construct an upper-envelope for an image.
%   dip_upperskeleton2d           - 2D upper skeleton.
%   dip_variancefilter            - Sample Variance Filter.
%   dip_vdt                       - Euclidean vector distance transform.
%   dip_watershed                 - Watershed.
%   dip_wiener                    - Image Restoration Filter.
%   dip_wrap                      - Wrap an image.
%   dip_xor                       - Exclusive or between two images.
%   dipio_appendrawdata           - Append/Write raw data to file.
%   dipio_colour2gray             - Convert 3D image with colour information to a 2D grayvalue image.
%   dipio_getimagereadformats     - Get list of formats to be used with dipio_imageread
%   dipio_getimagewriteformats    - Get list of formats to be used with dipio_imagewrite
%   dipio_getlibraryinformation   - Display information on the dipIO library
%   dipio_imagefilegetinfo        - Get information about image from file.
%   dipio_imageread               - Read image from file.
%   dipio_imagereadcolour         - Read colour image from file.
%   dipio_imagereadcolourseries   - Read colour image from file.
%   dipio_imagereadroi            - Read image ROI from file.
%   dipio_imagereadtiff           - Read TIFF image from file.
%   dipio_imagewrite              - Write image to file.
%   dipio_imagewritecolour        - Write colour image to file.
%   dipio_imagewriteics           - Write colour image to file.
%   parameters                    - How parameters are translated into DIPlib enums.

% (C) Copyright 1999-2014               Quantitative Imaging Group
%     All rights reserved               Faculty of Applied Sciences
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
