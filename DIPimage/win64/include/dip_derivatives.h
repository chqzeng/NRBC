/*
 * Filename: dip_derivatives.h
 *
 * (C) Copyright 1995-1997               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 *
 */

#ifndef DIP_DERIVATIVES_H
#define DIP_DERIVATIVES_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_argument_list.h"

typedef enum
{
   DIP_DF_FIRGAUSS   = 0,
   DIP_DF_IIRGAUSS   = 1,
   DIP_DF_FTGAUSS    = 2,
   DIP_DF_FINITEDIFF = 3,
   DIP_DF_DEFAULT    = DIP_DF_FIRGAUSS
} dip_DerivativeFlavour;

typedef struct
{
   dip_DerivativeFlavour flavour;
   dip_float truncation;
} dip_DerivativeSpec;

#define DIP_DF_SD_DGG   1
#define DIP_DF_SD_DPLUS 2
#define DIP_DF_SD_DMIN  3

typedef enum
{
   _DIP_DF_MDINFO_DEFAULT = 0,
   _DIP_DF_MDINFO_DUMMY   = 1
} dip__DfMdInfoFlags;

typedef struct
{
   dip_BoundaryArray boundary;
   dip_BooleanArray  process;
   dip_FloatArray sigmas;
   dip_float truncation;
   dip_DerivativeFlavour flavour;
   dip_Image image;
   dip_Image orImage;
   dip_Image propImage;
   dip__DfMdInfoFlags flags;
} dip_DfMdInfo;

typedef enum
{
   DIP_DF_MD_DEFAULT      =    0,
   DIP_DF_MD_ADJUST       =    1,
   DIP_DF_MD_NEW          =    2,
   DIP_DF_MD_BOUNDARY     = 0x04,
   DIP_DF_MD_PROCESS      = 0x08,
   DIP_DF_MD_SIGMAS       = 0x10,
   DIP_DF_MD_TRUNCATION   = 0x20,
   DIP_DF_MD_FLAVOUR      = 0x40
} dip_DfMdFlags;

typedef enum
{
   DIP_DFOD_DONT_ALLOCATE = 1
} dip_OrderedDerivativesFlags;

typedef enum
{
   DIP_HALF_CIRCLE         = 180,
   DIP_FULL_CIRCLE         = 360
} dip_GradientDirectionAtanFlavour;

DIP_ERROR dip_DefaultDerivativeSpec( dip_DerivativeSpec *,
                                     dip_DerivativeSpec ** );
DIP_ERROR dip_Derivative ( dip_Image, dip_Image, dip_BoundaryArray,
                           dip_BooleanArray, dip_FloatArray, dip_IntegerArray,
                           dip_float, dip_DerivativeFlavour );

DIP_ERROR dip_GradientMagnitude ( dip_Image, dip_Image, dip_BoundaryArray,
                                  dip_BooleanArray, dip_FloatArray, dip_float,
                                  dip_DerivativeFlavour );

DIP_ERROR dip_Laplace ( dip_Image, dip_Image, dip_BoundaryArray,
                        dip_BooleanArray, dip_FloatArray, dip_float,
                        dip_DerivativeFlavour );
DIP_ERROR dip_Dgg     ( dip_Image, dip_Image, dip_BoundaryArray,
                        dip_BooleanArray, dip_FloatArray, dip_float,
                        dip_DerivativeFlavour );
DIP_ERROR dip_LaplacePlusDgg
                     ( dip_Image, dip_Image, dip_BoundaryArray,
                     dip_BooleanArray, dip_FloatArray, dip_float,
                     dip_DerivativeFlavour );
DIP_ERROR dip_LaplaceMinDgg
              ( dip_Image, dip_Image, dip_BoundaryArray, dip_BooleanArray,
                dip_FloatArray, dip_float, dip_DerivativeFlavour );

DIP_ERROR dip_AllocateMultipleDerivativesInfo
              ( dip_Image, dip_DfMdInfo **, dip_DfMdInfo *, dip_BoundaryArray,
                dip_BooleanArray, dip_FloatArray, dip_float,
               dip_DerivativeFlavour, dip_DfMdFlags, dip_Al * );
DIP_ERROR dip_DisposeMultipleDerivativesInfo ( dip_DfMdInfo * );
DIP_ERROR dip_MdDerivative ( dip_Image, dip_DfMdInfo *, dip_IntegerArray );

DIP_ERROR dip_MdGradientMagnitude ( dip_Image, dip_DfMdInfo * );

DIP_ERROR dip_MdLaplace ( dip_Image, dip_DfMdInfo * );
DIP_ERROR dip_MdDgg     ( dip_Image, dip_DfMdInfo * );
DIP_ERROR dip_MdLaplacePlusDgg   ( dip_Image, dip_DfMdInfo * );
DIP_ERROR dip_MdLaplaceMinDgg    ( dip_Image, dip_DfMdInfo * );

DIP_ERROR dip_GradientDirection2D ( dip_Image, dip_Image, dip_BoundaryArray,
                                    dip_BooleanArray, dip_FloatArray, dip_float,
                                        dip_GradientDirectionAtanFlavour,
                                        dip_DerivativeFlavour );
DIP_ERROR dip_MdGradientDirection2D ( dip_Image, dip_DfMdInfo * );

DIP_ERROR dip_Sharpen ( dip_Image, dip_Image, dip_float, dip_BoundaryArray,
   dip_BooleanArray, dip_FloatArray, dip_float, dip_DerivativeFlavour);


#ifdef __cplusplus
}
#endif
#endif
