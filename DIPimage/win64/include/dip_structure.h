/*
 * Filename: dip_structure.h
 *
 * (C) Copyright 1995-2005               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 * Author:
 *
 */

#ifndef DIP_STRUCTURE_H
#define DIP_STRUCTURE_H
#ifdef __cplusplus
extern "C" {
#endif

#ifndef DIP_DERIVATIVES_H
#include "dip_derivatives.h"
#endif

typedef struct
{
   dip_float power;
   dip_float sigma;
} dip_RARadialPoweredGaussianInfo;

typedef struct
{
   dip_float sigmaSquared;
} dip_RARadialGaussianInfo;

typedef struct
{
   dip_int   order;
} dip_RAAngularPsincInfo;

typedef struct
{
   dip_float sigmaScale;
} dip_RAAngularGaussianInfo;

typedef struct
{
   dip_int order;
} dip_RAAngularDerivativeInfo;

typedef struct
{
   dip_float scale;
} dip_RAAngularCosineInfo;

typedef struct
{
   dip_float displacement;
} dip_RALineEndingsInfo;

typedef enum
{
   DIP_OR_ORIENTATION = 0,
   DIP_OR_DIRECTION = 1
} dipf_Orientation;


typedef enum
{
   DIP_OS_SLICES_NORMAL       = 1,
   DIP_OS_SLICES_CRITICAL     = 2,
   DIP_OS_SLICES_EXPLICIT     = 3,
   DIP_OS_SLICES_USE          = 4,
   DIP_OS_SLICES_ORDER        = 5,
   DIP_OS_SLICES_DOUBLE_ORDER = 6,
   DIP__OS_SLICES_MASK        = 7,

   DIP_OS_USE_DELTA_PHI = 1<<3,

   DIP_OS_ANGULAR_PSINC = 1<<4,
   DIP_OS_ANGULAR_GAUSS = 2<<4,
   DIP_OS_ANGULAR_COS   = 3<<4,
   DIP_OS_ANGULAR_ONE   = 4<<4,
   DIP_OS_ANGULAR_DERIVATIVE = 5<<4,
   DIP_OS_ANGULAR_TRUE_DERIVATIVE = 6<<4,
   DIP__OS_ANGULAR_MASK = 7<<4,

   DIP_OS_RADIAL_ONE = 1<<7,
   DIP_OS_RADIAL_GAUSSIAN = 2<<7,
   DIP__OS_RADIAL_MASK = 3<<7,

   DIP_OS_SPATIAL        = 1<< 9,
   DIP_OS_LINES          = 1<<10,
   DIP_OS_EDGES          = 1<<11,

   DIP_OS_PROJECT_ABS          = 1<<12,
   DIP_OS_PROJECT_BRIGHT_LINES = 1<<13,
   DIP_OS_PROJECT_DARK_LINES   = 1<<14,
   DIP_OS_PROJECT_BRIGHT_EDGES = 1<<15,
   DIP_OS_PROJECT_DARK_EDGES   = 1<<16,

   DIP_OS_USE_RADIAL_SCALE  = 1<<17,
   DIP_OS_USE_TANGENT_SCALE = 1<<18,

   DIP_OS_LINE_ENDINGS = 1<<19
} dipf_OrientationSpace;


typedef struct
{
   dip_int   os_sz;
   dip_float os_or;
   dip_float os_sc;
} dip_OrientationSpaceDescriptor;


typedef struct
{
   dip_float rad;
   dip_float ang;
   dip_float xx;
   dip_float yy;
} dip_FtRACoordinates;

typedef dip_Error (*dip_FtRAFunction)
                        ( dip_FtRACoordinates *, void *, dip_complex * );

DIP_ERROR dip_FtRadialAngularSeparableFilter( dip_Image, dip_Image,
                                              dip_FtRAFunction, void *,
                                              dip_FtRAFunction, void *,
                                              dip_FtRAFunction, void *,
                                              dip_float, dip_float, dip_float,
                                              dip_float, dip_float );
DIP_ERROR dip_RARadialPoweredGaussian( dip_FtRACoordinates *,
                                       void *,dip_complex * );
DIP_ERROR dip_RARadialGaussian( dip_FtRACoordinates *,
                                void *,dip_complex * );
DIP_ERROR dip_RAAngularPsinc( dip_FtRACoordinates *, void *, dip_complex * );
DIP_ERROR dip_RAAngularGaussian( dip_FtRACoordinates *, void *, dip_complex * );
DIP_ERROR dip_RAAngularDerivative
                     ( dip_FtRACoordinates *, void *, dip_complex * );
DIP_ERROR dip_RAAngularTrueDerivative
                     ( dip_FtRACoordinates *, void *, dip_complex * );
DIP_ERROR dip_RAAngularCosine( dip_FtRACoordinates *, void *, dip_complex * );
DIP_ERROR dip_RALineEndings( dip_FtRACoordinates *, void *, dip_complex * );
DIP_ERROR dip_OrientationSpace( dip_Image, dip_Image,
                                dip_OrientationSpaceDescriptor **,
                                dip_int, dip_int,
                                dip_float, dip_float, dip_float, dip_float,
                                dip_FloatArray,
                                dipf_OrientationSpace, dip_Resources );
DIP_ERROR dip_ExtendedOrientationSpace( dip_Image, dip_Image,
                                dip_OrientationSpaceDescriptor **,
                                dip_int, dip_int,
                                dip_float, dip_float, dip_float, dip_float,
                                dip_float, dip_float, dip_float,
                                dip_FloatArray,
                                dipf_OrientationSpace, dip_Resources );
/*
DIP_ERROR dip_OrientationTensor( dip_Image, dip_Image, dip_Image, dip_Image,
                                 dip_Image, dip_Image, dip_float *,
                                 dip_BoundaryArray,
                                 dip_DerivativeSpec *, dip_FloatArray,
                                 dip_DerivativeSpec *, dip_FloatArray );
*/
DIP_ERROR dip_StructureTensor2D( dip_Image, dip_Image, dip_Image, dip_Image,
                                 dip_Image, dip_Image, dip_Image, dip_Image,
                                 dip_Image, dip_BoundaryArray,
                                 dip_DerivativeSpec *, dip_FloatArray,
                                 dip_DerivativeSpec *, dip_FloatArray,
                                 dip_DerivativeSpec *, dip_FloatArray );
DIP_ERROR dip_StructureDerivatives2D( dip_Image, dip_Image,
                                 dip_Image, dip_Image, dip_Image, dip_Image,
                                 dip_BoundaryArray,
                                 dip_DerivativeSpec *, dip_FloatArray,
                                 dip_DerivativeSpec *, dip_FloatArray );
DIP_ERROR dip_StructureTensor3D( dip_Image, dip_Image, dip_Image, dip_Image,
                                 dip_Image, dip_Image, dip_Image, dip_Image,
                                 dip_Image, dip_Image, dip_Image, dip_Image,
                                 dip_Image, dip_Image, dip_BoundaryArray,
                                 dip_DerivativeSpec *, dip_FloatArray,
                                 dip_DerivativeSpec *, dip_FloatArray );
DIP_ERROR dip_StructureDerivatives3D( dip_Image, dip_Image,
                                 dip_Image, dip_Image, dip_Image,
                                 dip_Image, dip_Image, dip_Image,
                                 dip_Image, dip_BoundaryArray,
                                 dip_DerivativeSpec *, dip_FloatArray,
                                 dip_DerivativeSpec *, dip_FloatArray );
DIP_ERROR dip_CurvatureFromTilt( dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_OSEmphasizeLinearStructures( dip_Image, dip_Image,
                                           dip_OrientationSpaceDescriptor *,
                                           dip_float, dip_float );
DIP_ERROR dip_DanielsonLineDetector( dip_Image, dip_Image, dip_Image,
                                     dip_Image, dip_BoundaryArray,
                                     dip_FloatArray, dip_float,
                                     dip_DerivativeFlavour );

#ifdef __cplusplus
}
#endif
#endif
