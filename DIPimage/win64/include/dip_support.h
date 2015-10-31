/*
 * Filename: dip_support.h
 *
 * (C) Copyright 1995-1997               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : lucas@ph.tn.tudelft.nl
 *
 * Some general DIPlib support functions
 *
 */


#ifndef DIP_TPI_INC

#ifndef DIP_SUPPORT_H
#define DIP_SUPPORT_H
#ifdef __cplusplus
extern "C" {
#endif

/* definition of the library info flags */
typedef enum
{
   DIP_LIB_INFO_DEFAULT = 0
} dip_LibraryInfoFlags;

/* CFS stands for _C_heck _F_ilter _S_ize */
typedef enum
{
   DIP_CFS_ODD   = 1,
   DIP_CFS_EVEN  = 2,
   DIP_CFS_MATCH = 4
} dip_CheckFilterSizeFlags;

/* BC stands for _B_oundary _C_ondition */
typedef enum
{
	DIP_BC_DEFAULT                  =  0,
   DIP_BC_SYMMETRIC_MIRROR         =  0,
   DIP_BC_ASYMMETRIC_MIRROR        =  1,
   DIP_BC_PERIODIC                 =  2,
   DIP_BC_ASYMMETRIC_PERIODIC      =  3,
   DIP_BC_ADD_ZEROS                =  4,
   DIP_BC_ADD_MAX_VALUE            =  5,
   DIP_BC_ADD_MIN_VALUE            =  6,
   DIP_BC_ADD_VALUE                =  7,
   DIP_BC_ZERO_ORDER_EXTRAPOLATE   =  8,
   DIP_BC_FIRST_ORDER_EXTRAPOLATE  =  9,
   DIP_BC_SECOND_ORDER_EXTRAPOLATE = 10
} dip_Boundary;


/* definition of the filter shape enumerator */
typedef enum
{
   DIP_FLT_SHAPE_RECTANGULAR = 1,
	DIP_FLT_SHAPE_DEFAULT     = DIP_FLT_SHAPE_RECTANGULAR,
   DIP_FLT_SHAPE_ELLIPTIC    = 2,
   DIP_FLT_SHAPE_DIAMOND     = 3,
   DIP_FLT_SHAPE_PARABOLIC   = 4,
   DIP_FLT_SHAPE_STRUCTURING_ELEMENT = 5,
	/* Different line elements. Parameters are { length, angle [, angle [, ...] ] } */
	DIP_FLT_SHAPE_INTERPOLATED_LINE,
	DIP_FLT_SHAPE_DISCRETE_LINE,
	DIP_FLT_SHAPE_PERIODIC_LINE
} dip_FilterShape;

typedef enum
{
   DIP_INFRA_CS_COSINE = 1,
   DIP_INFRA_CS_SINE   = 2
} dipf_CreateCoSineTable;

typedef enum
{
   DIP_SC_NONE      = 0,
   DIP_SC_ROUND     = 1,
   DIP_SC_REAL      = 0<<1,
   DIP_SC_IMAGINARY = 1<<1,
   DIP_SC_MODULUS   = 2<<1,
   DIP_SC_PHASE     = 3<<1,
   DIP__SC_COMPLEX_MASK = 3<<1,
   DIP_SC_THRESHOLD = 8
} dipf_ScalarConvert;

typedef enum
{
   DIP_DS_GET = 1,
   DIP_DS_GET_VALID,
   DIP_DS_SET_VALID
} dip_DescriptorMaintainer;


typedef struct
{
	dip_int size;
	dip_Boundary *array;
}  dip__BoundaryArray, *dip_BoundaryArray;

/* structure to describe the physical dimensions/sizes of pixels */
typedef struct
{
	dip_FloatArray dimensions;       /* distance betwee pixels in phys. units */
	dip_FloatArray origin;           /* pos. of pixel[0]..[0] in phys. units */
	dip_StringArray dimensionUnits;  /* phys. units of dimensions[] */
	dip_float intensity;             /* scaling of intensities */
	dip_float offset;                /* offset of intensities */
	dip_String intensityUnit;        /* phys. units of intensities */
	dip_Resources resources;
} dip__PhysicalDimensions, *dip_PhysicalDimensions;

typedef enum
{
   DIP_GVSO_HIGH_FIRST,
   DIP_GVSO_LOW_FIRST
} dipf_GreyValueSortOrder;

#define DIP_WRITE_FORMAT_DEFAULT {",",DIP_TRUE,DIP_TRUE,DIP_TRUE,DIP_TRUE}

DIP_ERROR dip_PhysicalDimensionsFree ( dip_PhysicalDimensions * );
DIP_ERROR dip_PhysicalDimensionsNew  ( dip_PhysicalDimensions *, dip_int,
                                       dip_float, dip_float, char *, dip_float,
                                       dip_float, char *, dip_Resources );
DIP_ERROR dip_PhysicalDimensionsCopy ( dip_PhysicalDimensions *,
                                       dip_PhysicalDimensions, dip_Resources );
DIP_ERROR dip_PhysicalDimensionsIsIsotropic ( dip_PhysicalDimensions,
                                              dip_Boolean * );


DIP_ERROR dip_Initialise( void );
DIP_ERROR dip_Exit( void );

DIP_ERROR dip_BoundaryArrayNew        ( dip_BoundaryArray *, dip_int,
													 dip_Boundary, dip_Resources );
DIP_ERROR dip_BoundaryArrayFree       ( dip_BoundaryArray * );

DIP_ERROR dip_ImageCheckIntegerArray  ( dip_Image, dip_IntegerArray,
                                        dip_Boolean * );
DIP_ERROR dip_ImageCheckFloatArray    ( dip_Image, dip_FloatArray,
                                        dip_Boolean * );
DIP_ERROR dip_ImageCheckComplexArray  ( dip_Image, dip_ComplexArray,
                                        dip_Boolean * );
DIP_ERROR dip_ImageCheckBoundaryArray ( dip_Image, dip_BoundaryArray,
                                           dip_Boolean * );
DIP_ERROR dip_ImageCheckDataTypeArray ( dip_Image, dip_DataTypeArray,
                                           dip_Boolean * );
DIP_ERROR dip_ImageCheckBooleanArray  ( dip_Image, dip_BooleanArray,
                                           dip_Boolean * );

DIP_ERROR dip_BooleanArrayUseParameter  ( dip_BooleanArray *, dip_Image,
                                          dip_BooleanArray, dip_Boolean,
                                          dip_Resources );
DIP_ERROR dip_IntegerArrayUseParameter  ( dip_IntegerArray *, dip_Image,
                                          dip_IntegerArray, dip_int,
                                          dip_Resources );
DIP_ERROR dip_FloatArrayUseParameter    ( dip_FloatArray *, dip_Image,
                                          dip_FloatArray, dip_int,
                                          dip_Resources );
DIP_ERROR dip_BoundaryArrayUseParameter ( dip_BoundaryArray *, dip_Image,
                                          dip_BoundaryArray, dip_Resources );

DIP_ERROR dip_ImageIgnoreSingletonDims( dip_Image, dip_BooleanArray,
                                          dip_BooleanArray*, dip_Resources );

DIP_ERROR dip_GetObjectLabels     ( dip_Image, dip_Image, dip_IntegerArray *,
                                    dip_Boolean, dip_Resources );
/*
DIP_ERROR dip_FindObjectLabel     ( dip_IntegerArray, dip_int, dip_int *,
                                    dip_Boolean * );
*/

DIP_ERROR dip__PixelGetInteger ( void *, dip_DataType, dip_IntegerArray,
                                 dip_IntegerArray, dip_int, dip_int *);
DIP_ERROR dip__PixelGetFloat   ( void *, dip_DataType, dip_IntegerArray,
                                 dip_IntegerArray, dip_int, dip_float *);

DIP_ERROR dip__PixelSetInteger ( dip_int, void *, dip_DataType,
                                 dip_IntegerArray, dip_IntegerArray, dip_int);
DIP_ERROR dip__PixelSetFloat   ( dip_float, void *, dip_DataType,
                                 dip_IntegerArray, dip_IntegerArray, dip_int);

DIP_ERROR dip__PixelAddInteger ( dip_int, void *, dip_DataType,
                                 dip_IntegerArray, dip_IntegerArray, dip_int);
DIP_ERROR dip__PixelAddFloat   ( dip_float, void *, dip_DataType,
                                 dip_IntegerArray, dip_IntegerArray, dip_int);
DIP_ERROR dip__PixelSubFloat   ( dip_float, void *, dip_DataType,
                                 dip_IntegerArray, dip_IntegerArray, dip_int);
DIP_ERROR dip__PixelMulFloat   ( dip_float, void *, dip_DataType,
                                 dip_IntegerArray, dip_IntegerArray, dip_int);
DIP_ERROR dip__PixelDivFloat   ( dip_float, void *, dip_DataType,
                                 dip_IntegerArray, dip_IntegerArray, dip_int);

/* some other useful macros */
#define DIP_DISPLAY                 if( !display ) ; else printf
#define DIP_POINTER(x,y)            if( x != 0) { *x = y; }

/* DIPlib general support functions */
DIP_ERROR dip_GetUniqueNumber       ( dip_int * );
DIP_ERROR dip_CreateCoSineTable     ( dip_DataType, void *, void *,
                                      dip_float, dip_float, dip_int,
                                      dipf_CreateCoSineTable );

DIP_ERROR dip_ScalarConvert( void *, dip_DataType, dip_int, dip_int,
                             void *, dip_DataType, dip_int, dip_int,
                             dip_int, dipf_ScalarConvert );

/* GvK: I need this function pointer in framework */
typedef dip_Error (*dip_FillBoundaryArrayFunction)
               ( void *, dip_int, dip_int, void *, dip_int, dip_int,
                 dip_int, dip_int, dip_Boundary );

#define DIP_TPI_INC_FILE "dip_support.h"
#include "dip_tpi_inc.h"

#ifdef __cplusplus
}
#endif
#endif

#else

DIP_EXPORT DIP_TPI_INC_DECLARE(dip_FillBoundaryArray)
            ( void *, dip_int, dip_int, void *, dip_int, dip_int,
              dip_int, dip_int, dip_Boundary );

#endif
