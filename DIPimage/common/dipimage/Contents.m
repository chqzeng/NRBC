% DIPimage, a scientific image analysis toolbox
% Version 2.7   30-Oct-2014
%
% Authors: Cris Luengo, Lucas van Vliet, Bernd Rieger
% Project supervisor: Lucas J. van Vliet
% Contact: info@diplib.org
%
% GUI:
%   dipimage             - Start the DIPimage GUI
%
% File I/O:
%   readim               - Read image from file
%   readroiim            - Read ROI of a grey-value image from file
%   readtimeseries       - Reads a series/stack of images from disk in one image.
%   readrawim            - Read image from RAW format file
%   writeim              - Write grey-value or color image to file
%   readavi              - Reads AVI movie into a 3D image
%   writeavi             - Writes 3D image into an AVI file
%   writedisplayavi      - Writes displayed 3D image into an AVI file
%
% Display:
%   overlay              - Overlay a grey-value or color image with a binary or label image
%   overlay_confidence   - Overlay a grey-value image with a grey-value image
%   overlay_vector       - Overlay a grey-value image with a vector image
%   orientationplot      - Plot 2/3D orientation
%   dipgetimage          - Retrieves an image from a display
%   dipprofile           - Interactive extraction of 1D function from image
%   dipstackinspect      - Interactive inspection of the third dimension
%   dipcrop              - Interactive image cropping
%   dipgetcoords         - Interactive coordinate extraction
%   dipdrawpolygon       - Interactive polygon drawing tool
%   diproi               - Interactive ROI selection
%   diptruesize          - Sets the size of a display to its natural size
%   dipclf               - Clears figure windows created by DIPSHOW
%
% Generation:
%   newim                - Creates a dip_image of the specified size
%   newcolorim           - Creates a dip_image color image of the specified size and colorspace
%   deltaim              - Generate a discrete delta function
%   ramp                 - Creates an image with general coordinates
%   xx                   - Creates an image with X coordinates
%   yy                   - Creates an image with Y coordinates
%   zz                   - Creates an image with Z coordinates
%   rr                   - Creates an image with R coordinates
%   phiphi               - Creates an image with Phi coordinates
%   testobject           - Creates bandlimited test objects
%   noise                - Add noise to an image
%   drawline             - Draws a line in an image
%   drawpolygon          - Draws a polygon in an image
%   gaussianblob         - Adds Gauss shaped spots to an  image
%
% Manipulation:
%   mirror               - Mirror an image
%   shift                - Shift a nD image
%   correctshift         - Corrects the shift in a time series
%   localshift           - 
%   rotation             - Rotate a 2D/3D image around an axis
%   rotation3d           - 
%   affine_trans         - 
%   resample             - Resample an image
%   subsample            - Subsample an image
%   rebin                - Rebinning of an image
%   split                - Split an image into subsampled versions
%   extend               - Extends/pads an image with values
%   cut                  - Cuts/crops an image symmetrically around the center
%   slice_ex             - Extracts one slice from an n-D image
%   slice_in             - Inserts one slice in an n-D image
%
% Point:
%   clip                 - Grey-value clipping
%   erfclip              - Grey-value error function clipping
%   gaussianedgeclip     - Clips/maps grey-values to produce a Gaussian edge
%   gaussianlineclip     - Clips/maps grey-values to produce a Gaussian line
%   diphist              - Displays a histogram
%   diphist2d            - Generates a 2D histogram
%   mdhistogram          - Compute a Multi-dimensional histogram
%   stretch              - Grey-value stretching
%   hist_equalize        - Histogram equalization
%   lut                  - Look-up Table (with interpolation)
%   get_subpixel         - Retrieves subpixel values in an image
%
% Filters:
%   convolve             - General convolution filter
%   smooth               - Smooth all elements of the tensor image.
%   gaussf               - Gaussian filter
%   unif                 - Uniform filter
%   maxf                 - Maximum filter
%   minf                 - Minimum filter
%   medif                - Median filter
%   percf                - Percentile filter
%   varif                - Variance filter
%   gabor                - Gabor filter
%   gabor_click          - Gabor filter
%
% Differential Filters:
%   derivative           - Derivative filters
%   dx                   - First derivative in the X-direction
%   dy                   - First derivative in the Y-direction
%   dz                   - First derivative in the Z-direction
%   gradientvector       - Gradient vector
%   gradmag              - Gradient magnitude
%   dxx                  - Second derivative in the X-direction
%   dyy                  - Second derivative in the Y-direction
%   dzz                  - Second derivative in the Z-direction
%   dxy                  - Second derivative in the XY-direction
%   dxz                  - Second derivative in the XZ-direction
%   dyz                  - Second derivative in the YZ-direction
%   dgg                  - Second derivative in the gradient-direction
%   dcc                  - Second derivative in the contour-direction
%   laplace              - Laplace operator
%   laplace_plus_dgg     - Laplace + Dgg
%   laplace_min_dgg      - Laplace - Dgg
%   hessian              - Hessian matrix of an image
%   dethessian           - Det(Hessian) operator
%   prewittf             - Prewitt derivative filter
%   sobelf               - Sobel derivative filter
%
% Adaptive Filters:
%   kuwahara             - Kuwahara filter for edge-preserving smoothing
%   selectionf           - Selection filter
%   tframehessian        - Second derivatives driven by structure tensor
%   bilateralf           - Bilateral filter with different implementations
%   gaussf_adap          - Adaptive Gaussian filtering.
%   percf_adap           - Adaptive percentile filtering.
%   gaussf_adap_banana   - Adaptive Gaussian filtering in banana like neighborhood
%   percf_adap_banana    - Adaptive percentile filtering in banana like neighborhood
%
% Binary Filters:
%   bdilation            - Binary dilation
%   berosion             - Binary erosion
%   bopening             - Binary opening
%   bclosing             - Binary closing
%   hitmiss              - Hit-miss operator
%   bskeleton            - Binary skeleton
%   bpropagation         - Binary propagation
%   brmedgeobjs          - Remove edge objects from binary image
%   fillholes            - Fill holes in a binary image
%   hull                 - Generates convex hull of a binary image
%   countneighbours      - Counts the number of neighbours each pixel has
%   bmajority            - Binary majority voting
%   getsinglepixel       - Get single-pixels from skeleton
%   getendpixel          - Get end-pixels from skeleton
%   getlinkpixel         - Get link-pixels from skeleton
%   getbranchpixel       - Get branch-pixels from skeleton
%
% Morphology:
%   dilation             - Grey-value dilation
%   erosion              - Grey-value erosion
%   closing              - Grey-value closing
%   opening              - Grey-value opening
%   tophat               - Top-hat
%   dilation_se          - Grey-value dilation with a user-defined structuring element
%   erosion_se           - Grey-value erosion with a user-defined structuring element
%   closing_se           - Grey-value closing with a user-defined structuring element
%   opening_se           - Grey-value opening with a user-defined structuring element
%   rankmin_closing      - Rank-min closing
%   rankmax_opening      - Rank-max opening
%   rankmin_closing_se   - Rank-min closing with user defined structuring element
%   rankmax_opening_se   - Rank-max opening with user defined structuring element
%   hmaxima              - H-maxima transform
%   hminima              - H-minima transform
%   reconstruction       - Morphological reconstruction by dilation
%
% Diffusion:
%   pmd                  - Perona Malik anisotropic diffusion
%   pmd_gaussian         - Perona Malik diffusion with Gaussian derivatives
%   aniso                - Robust anisotropic diffusion using Tukey error norm
%   mcd                  - Mean curvature diffusion
%   cpf                  - Nonlinear diffusion using corner preserving formula (improved over MCD)
%   ced                  - Coherence enhancing (anisotropic) diffusion
%
% Restoration:
%   wiener               - Wiener filter/restoration
%   mappg                - maximum a-posteriori probablity restoration
%   tikhonovmiller       - Tikhonov Miller restoration
%   backgroundoffset     - Remove  background offset
%   afm_flatten          - Subtract background and artifacts from AFM/SPM images
%
% Segmentation:
%   threshold            - Thresholding
%   hist2image           - Backmaps a 2D histogram ROI to the images
%   minima               - Detect local minima
%   maxima               - Detect local maxima
%   watershed            - Watershed
%   waterseed            - Watershed initialized with a seed image
%   splitandmerge        - 
%   canny                - Canny edge detector
%   snakeminimize        - Minimizes the energy function of a snake
%   gvf                  - Computes an external force using Gradient Vector Flow
%   vfc                  - Computes an external force using Vector Field Convolution
%   snakedraw            - Draws a snake over an image
%   snake2im             - Creates a binary image based on a snake
%   im2snake             - Creates a snake based on a binary image
%   label                - Label objects in a binary image
%   relabel              - Renumber labels in a labeled image
%   countingframe        - Applies a counting frame to a labelled image
%
% Transforms:
%   ft                   - Fourier Transform (forward)
%   ift                  - Fourier transform (inverse)
%   nufft_type1          - 
%   nufft_type2          - 
%   ht                   - Hilbert transform for nD images
%   dt                   - Euclidean distance transform
%   vdt                  - Vector components of Euclidean distance transform
%   gdt                  - Grey-weighted distance transform
%   radoncircle          - 
%
% Analysis:
%   measure              - Do measurements on objects in an image
%   msr2obj              - Label each object in the image with its measurement
%   msr2ds               - Convert a measurement structure to a PRTOOLS dataset
%   measurehelp          - Provides help on the measurement features
%   scalespace           - Gaussian scale-space
%   morphscales          - Morphological scale-space
%   scale2rgb            - Convert scale-space to RGB image
%   structuretensor      - Computes Structure Tensor on 2D images
%   structuretensor3d    - Computes Structure Tensor on 3D images
%   curvature            - Curvature in grey value images in nD
%   pst                  - Parametric Structure Tensor
%   quadraturetensor     - Computes Quadrature Tensor on 2D images
%   granulometry         - Obtains a particle size distribution.
%   findshift            - Finds shift between two images
%   find_affine_trans    - 
%   fmmatch              - Fourier-Mellin transform
%   opticflow            - Computes the optic flow of a 2D/3D time series
%   findlocalshift       - Estimates locally the shift
%   findlocmax           - Finds iteratively the local maximum in a LSIZE cube
%   findminima           - Find local minima
%   findmaxima           - Find local maxima
%   subpixlocation       - Find sub-pixel location of extrema
%
% Statistics:
%   chordlength          - Computes the chord lengths of the phases in a labeled image
%   paircorrelation      - Computes the pair correlation of the phases in a labeled image
%   autocorrelation      - Computes the auto-correlation of an image
%   crosscorrelation     - Computes the cross-correlation between two images
%   radialsum            - Computes the sum as a function of the R-coordinate
%   radialmean           - Computes the average as a function of the R-coordinate (angular mean)
%   radialmin            - Computes the minimum as a function of the R-coordinate
%   radialmax            - Computes the maximum as a function of the R-coordinate
%   mse                  - Mean square error
%   mre                  - Mean relative error
%   mae                  - Mean absolute error
%   lfmse                - Linear fitted mean square error
%   ssim                 - Structural similarity index (a visual similarity measure)
%   psnr                 - Peak Signal-to-Noise Ratio (in dB)
%   noisestd             - Estimate noise standard deviation
%   mutualinformation    - Computes the mutual information (in bits) of two images
%   entropy              - Computes the entropy (in bits) of an image
%   cal_readnoise        - Calculates the read noise/gain of a CCD
%
%
% Other available functions are:
%   acquireim            - 
%   arcf                 - Arc-shape filter (1d oriented & curved Gaussian/bilateral filter)
%   arrangeslices        - Converts an n-D image into a 2D image by arringing the slices
%   array2im             - Convert a dip_image_array to an image stack
%   bbox                 - Bounding box of an n-D binary image
%   change_chroma        - Change the saturation of the image (CIELAB/CIELUV space)
%   change_gamma         - Change the gamma of the input image
%   change_xyz           - Change the whitepoint of the XYZ colorspace
%   color_rotation       - Rotation from Blue-Black to White Black
%   coord2image          - Generate binary image with ones at coordinates.
%   curvature_thirion    - Isophote curvature in grey value images
%   deblock              - Remove blocking artifact from JPEG compressed images
%   detile               - Splits an image in subimages.
%   dip_initialise       - Initialises the DIPimage toolbox and library
%   dip_morph_flavour    - Sets or gets the morphological flavour
%   dipaddpath           - Adds a path to be used in the DIPimage GUI
%   dipanimate           - Animates a 3D image in a display window
%   dipfig               - Links a variable name with a figure window
%   dipgetpref           - Gets a DIPimage preference
%   dipinit              - Initialize the working environment
%   dipisosurface        - Plot isosurfaces of 3D grey value images
%   diplink              - Linking of displays for 3D images
%   diplooking           - Interactive looking glas over the image
%   dipmapping           - Changes the mapping of an image in a figure window
%   dipmaxaspect         - Undocumented till usefulness proved
%   dipmenus             - Not a user function
%   dipmex               - Compile a MEX-file that uses DIPlib
%   diporien             - Interactive orientation testing
%   dippan               - Interactive panning of an image
%   dipprojection        - Calculates the max/sum projection along the not visible axis for 3D
%   dipsetpref           - Sets a DIPimage preference
%   dipshow              - Shows a dip_image object as an image
%   dipstep              - Stepping through slices of a 3D image
%   diptest              - Interactive pixel testing
%   dipzoom              - Interactive image zooming
%   displaylabelnumbers  - Overlay the label numbers on a figure window
%   dpr                  - Differential phase residuals
%   edir                 - 
%   fast_str2double      - 
%   find_lambda          - calculates the regularazation parameter for the TM_filter
%   findospeaks          - Find peaks in Orientation Space
%   fixlsmfile           - 
%   frc                  - Fourier Ring Correlation
%   gamut_destretch      - 
%   gamut_mapping        - 
%   gamut_stretch        - 
%   getparams            - Automated parameter parsing for DIPimage functions
%   huecorr              - Changing the hue in the HSV colorspace
%   hybridf              - Denoise by a soft blending of arc filter and Gaussian filter
%   im2array             - Convert an image stack to a dip_image_array
%   im2mat               - Converts a dip_image to a matlab array.
%   iso_luminance_lines  - Plot lines with same luminance in color image
%   isophote_curvature   - Isophote curvature in grey value images
%   jacobi               - Symmetric eigenvalue analysis
%   joinchannels         - Joins scalar images as channels in a color image
%   jpeg_quality_score   - Estimate perceptual JPEG quality without reference
%   luminance_steered_dilation - Dilation on color image with luminance ordering
%   luminance_steered_erosion - Erosion on color image with luminance ordering
%   make_gamut           - Make the gamut for given device and measured values
%   mat2im               - Converts a matlab array to a dip_image.
%   measure_gamma_monitor - Interactive tool to measure the gamma of your monitor
%   mon_rgb2xyz          - RGB to XYZ transformation for a calibrated monitor
%   mon_xyz2rgb          - XYZ to RGB transformation for a calibrated monitor
%   monitor_icc          - Converts the colors of an image according to the given ICC profile
%   msr_remap            - Map a measurement structure corresponding to a particular label
%   nconv                - Normalized Convolution
%   newimar              - Creates an array of empty dip_images
%   orientation4d        - Orientation estimation in 4D
%   orientationspace     - Orientation space
%   out_of_gamut         - Determine which colors of an image are outside the gamut
%   plot_gamut           - 
%   print_cmy2xyz        - CMY to XYZ transformation for a calibrated printer
%   print_xyz2cmy        - XYZ to CMYK transformation for a calibrated printer
%   printer_icc          - Converts the colors of an image according to the given ICC profile
%   ramp1                - Creates a one-dimensional image with general coordinates
%   read_icc_profile     - Read the values on an ICC header
%   rgb_to_border        - Determines points on the gamut boundary in a certain direction
%   scan_rgb2xyz         - XYZ to RGB transformation for a calibrated scanner
%   scan_xyz2rgb         - XYZ to RGB transformation for a calibrated scanner
%   scanner_calibration  - Derive a profile for a calibrated scanner
%   scanner_icc          - Converts the colors of an image according to the given ICC profile
%   setlabels            - Remap or remove labels
%   slice_op             - Apply a function to all slices in the last image dimension
%   spectra2xyz          - Converts input spectra to XYZ values
%   structf              - Structure adaptive filter (oriented, variable-sized Gaussian filtering)
%   tile                 - Displays a 2D tensor image in one 2D image.
%   transform            - 
%   umbra                - umbra of an image
%   view5d               - Start the java viewer by Rainer Heintzmann
%   write_add            - 
%   write_icc_profile    - Make a ICC profile
%   xx1                  - Creates a one-dimensional image with X coordinates
%   yy1                  - Creates a one-dimensional image with Y coordinates
%   zz1                  - Creates a one-dimensional image with Z coordinates
%
% Type
%   methods dip_image
% to get a list of functions overloaded for dip_images.
%
% More information about DIPimage is available in the on-line manual:
%   ftp://ftp.qi.tnw.tudelft.nl/pub/DIPlib/Download/docs/dipimage_user_manual.pdf

% (C) Copyright 1999-2014               Quantitative Imaging Group
%     All rights reserved               Faculty of Applied Sciences
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
