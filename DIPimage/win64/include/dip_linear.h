/*
 * Filename: dip_linear.h
 *
 * (C) Copyright 1995-2002               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 */

#ifndef DIP_TPI_INC
   #ifndef DIP_LINEAR_H
   #define DIP_LINEAR_H
   #ifdef __cplusplus
   extern "C" {
   #endif

   typedef enum
   {
    DIP_CNV_USE_ORIGIN  = 0x01,
    DIP_CNV_LEFT        = 0x02,
    DIP_CNV_RIGHT       = 0x04,
    DIP_CNV_GENERAL     = 0x08,
    DIP_CNV_EVEN        = 0x10,
    DIP_CNV_ODD         = 0x20,
    DIP_CNV_HAS_BORDER  = 0x40,

    _DIP_CNV_MASK_ORIGIN = 0x07,
    _DIP_CNV_MASK_SHAPE  = 0x38
   } dipf_Convolve;

   typedef enum
   {
    DIP_LIN_GAUSS_DEFAULT              = 0,
    DIP_LIN_GAUSS_DONT_ALLOCATE_FILTER = 1
   }  dipf_LinMakeGauss;

   typedef enum
   {
      DIP_IMAGE_REPRESENTATION_SPATIAL = 1,
      DIP_IMAGE_REPRESENTATION_SPECTRAL
   } dipf_ImageRepresentation;

   typedef enum
   {
      DIP_FINITE_DIFFERENCE_M101  = 0,
      DIP_FINITE_DIFFERENCE_0M11  = 1,
      DIP_FINITE_DIFFERENCE_M110  = 2,
      DIP_FINITE_DIFFERENCE_1M21  = 3,
      DIP_FINITE_DIFFERENCE_121   = 4
   } dipf_FiniteDifference;

   #ifndef SWIG

   typedef struct
   {
      dip_float *filter;
      dip_int filterSize;
      dip_int origin;
      dipf_Convolve flags;
   }  dip_SeparableConvolutionFilter;

   DIP_ERROR dip_SeparableConvolution ( dip_Image, dip_Image,
                                        dip_SeparableConvolutionFilter *,
                                        dip_BoundaryArray, dip_BooleanArray );
   DIP_ERROR dip_ConvolveFT( dip_Image, dip_Image, dip_Image,
                             dipf_ImageRepresentation, dipf_ImageRepresentation,
                             dipf_ImageRepresentation );
   DIP_ERROR dip_GeneralConvolution ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray );

   DIP_ERROR dip_Uniform ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                           dip_FloatArray, dip_FilterShape);

   DIP_ERROR dip_Gauss ( dip_Image, dip_Image, dip_BoundaryArray,
                         dip_BooleanArray, dip_FloatArray, dip_IntegerArray,
                         dip_float );
   DIP_ERROR dip_GaussFT ( dip_Image, dip_Image, dip_FloatArray, dip_IntegerArray,
                           dip_float );
   DIP_ERROR dip_MakeGaussianFilter ( void **, dip_float, dip_int, dip_float,
                                      dip_int *, dipf_LinMakeGauss, dip_DataType,
                                      dip_Resources );

   DIP_ERROR dip_OrientedGauss ( dip_Image, dip_Image, dip_FloatArray,
                                 dip_FloatArray );

   DIP_ERROR dip_SobelGradient ( dip_Image, dip_Image, dip_BoundaryArray,
                                 dip_int );
   DIP_ERROR dip_FiniteDifferenceEx ( dip_Image, dip_Image, dip_BoundaryArray,
                                      dip_BooleanArray, dip_IntegerArray, dip_Boolean );
   DIP_ERROR dip_FiniteDifference ( dip_Image, dip_Image, dip_BoundaryArray,
                                    dip_int, dipf_FiniteDifference );

   #endif /* !SWIG */

   #define DIP_TPI_INC_ALLOW DIP_DTGID_REAL
   #define DIP_TPI_INC_FILE "dip_linear.h"
   #include "dip_tpi_inc.h"

   #ifdef __cplusplus
   }
   #endif
   #endif

#else

DIP_TPI_INC_DECLARE(dip_Convolve1d) ( DIP_TPI_INC *, DIP_TPI_INC *, DIP_TPI_INC *, dip_int,
                dip_int, dip_int, dipf_Convolve, dip_Boundary );

#endif
/* endif of DIP_LINEAR_H */
