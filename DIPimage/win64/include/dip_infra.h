/*
 * Filename: dip_infra.h
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
 * Defines and functions for the infrastructure library
 *
 * AUTHOR
 *    Michael van Ginkel
 *
 * HISTORY
 *    September 1995     - MvG - created
 *    September 1995     - GvK - addition of DIP_MAXDIM
 */

#ifndef DIP_INFRA_H
#define DIP_INFRA_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_string.h"
#include "dip_registry.h"

/* Definition of DIPlib Image */


typedef struct
{
   void *image;
} dip__Image, *dip_Image;

#ifndef SWIG
/*
 * These are our predefined channel types, read the DIPlib manual for
 * information on these
 */

typedef dip_int dip_ImageType;

#define DIP_IMTP_SCALAR  ((dip_ImageType) 1)
#define DIP_IMTP_ALIEN   ((dip_ImageType) 2)
#define DIP_IMTP_MAXIMUM ((dip_ImageType) 3)

typedef enum
{
	DIP_IMST_RAW                     = 0x0,
   DIP_IMST_IS_VALID                = 0x01,
   DIP_IMST_IS_ROI                  = 0x02,
   DIP_IMST_ROI_MODIFIED            = 0x04,
   DIP_IMST_ROI_DATA_MODIFIED       = 0x08,
   DIP_IMST_ROI_STRUCTURAL_CHANGE   = 0x10,
   DIP__IMST_ROI_WHAT_WAS_MODIFIED  = 0x18,
   DIP_IMST_ROI_PARENT_MODIFIED     = 0x20,
   DIP_IMST_ROI_CHILD_MODIFIED      = 0x40,
   DIP__IMST_ROI_WHO_WAS_MODIFIED   = 0x60,
   DIP_IMST_LOCKED                  = 0x80,
   DIP_IMST_ORPHAN                  = 0x100,
   DIP_IMST_MAXIMUM_TYPE_MODE       = 0x200,
   DIP_IMST_STRIDE_OVERRIDE         = 0x400
} dip_ImageState;


typedef dip_Error (*dip_ImageForgeHandler)( dip_Image );
typedef dip_Error (*dip_ImageStripHandler)( dip_Image );
typedef dip_Error (*dip_ImageFreeHandler)( dip_Image );

/* typedef dip_int  dip_BitPlane; */

#define DIP_IMPL_PLANES           8
#define DIP_IMPL_ILLEGAL         -1
#define DIP_IMPL_RESERVED_PLANE1  6
#define DIP_IMPL_RESERVED_PLANE2  7
#define DIP_IMPL_RESERVED_MASK1   0x40U
#define DIP_IMPL_RESERVED_MASK2   0x80U

/* Matches the definition in SCIL's image.h ( struct RGB ) */

typedef struct
{
   dip_uint8 red;
   dip_uint8 green;
   dip_uint8 blue;
   dip_uint8 extra;
} dip_ScilRGB;


/* this enum is not used (yet), since C++ makes fuss about casting int to enum
   I have "rendered" this enum to be a int, GvK 18/8/2000
typedef enum
{
   DIP_IGDT_NONE = 1
} dipf_ImageGetData;
*/
#define dipf_ImageGetData dip_int


/* CG stands for _C_ompare _G_lits */

typedef enum
{
   DIP_CPIM_DEFAULT                     =  0x0,
   DIP_CPIM_DIMENSIONALITIES_MATCH      =  0x01,
   DIP_CPIM_DIMENSIONS_MATCH            =  0x02,
   DIP_CPIM_SIZE_MATCH                  =  0x03,
   DIP_CPIM_TYPES_MATCH                 =  0x04,
   DIP_CPIM_DATA_TYPES_MATCH            =  0x08,
   DIP_CPIM_MATCH_ALL_STANDARD          =  0x0F,
   DIP_CPIM_FULL_MATCH                  =  0x10,
   DIP_CPIM_STRIDES_MATCH               =  0x20
} dipf_ImagesCompare;


typedef enum
{
	DIP_ROI_DEFAULT = 0,
   DIP_ROI_COPY    = 1,
   DIP_ROI_TRUE    = 2
} dipf_DefineRoi;

typedef enum
{
	DIP_CKIM_DEFAULT                = 0x00,
	DIP_CKIM_NOTHING                = 0x00,
   DIP_CKIM_MAX_PRECISION_MATCH    = 0x01,
   DIP_CKIM_CASTING_TYPE_MATCH     = 0x02,
	DIP_CKIM_IGNORE_NULL_DIM_IMAGES = 0x04

} dipf_ImagesCheck;


typedef dip_uint32 dip_ImageKey;

typedef enum
{
   DIP_GLAP_SHARE = 1,
   DIP_GLAP_DONT_ALLOCATE = 2
} dip_AllocatePlaneFlags;


/* binary defines */
#define DIP_BINARY_BINARY_PLANES     8
#define DIP_BINARY_ILLEGAL_PLANE    -1
#define DIP_BINARY_RESERVED_PLANE1   6
#define DIP_BINARY_RESERVED_PLANE2   7
#define DIP_BINARY_RESERVED_MASK1    0x40U
#define DIP_BINARY_RESERVED_MASK2    0x80U


typedef struct
{
   dip_int size;
   dip_Image *array;
}  dip__ImageArray, *dip_ImageArray;


typedef struct
{
   dip_int size;
   dipf_ImageGetData *array;
}  dipf__ImageGetDataArray, *dipf_ImageGetDataArray;


/* from dip_glaccess.c */
DIP_ERROR dip_ImageGetState          ( dip_Image, dip_ImageState * );
DIP_ERROR dip_ImageLocked            ( dip_Image, dip_Boolean * );
/*DIP_ERROR dip_ImageModifiable        ( dip_Image, dip_Boolean * );*/
DIP_ERROR dip_ImageValid             ( dip_Image, dip_Boolean * );
DIP_ERROR dip_ImageGetType           ( dip_Image, dip_ImageType * );
DIP_ERROR dip_ImageSetType           ( dip_Image, dip_ImageType );
DIP_ERROR dip_ImageGetDataType       ( dip_Image, dip_DataType * );
DIP_ERROR dip_ImageSetDataType       ( dip_Image, dip_DataType );
DIP_ERROR dip_ImageGetDimensionality ( dip_Image, dip_int * );
DIP_ERROR dip_ImageSetDimensions     ( dip_Image, dip_IntegerArray );
DIP_ERROR dip_ImageGetDimensions     ( dip_Image, dip_IntegerArray *,
                                      dip_Resources );
DIP_ERROR dip_ImageGetSize           ( dip_Image, dip_int * );
DIP_ERROR dip_ImageGetData           ( dip_ImageArray, dip_VoidPointerArray *,
                                       dipf_ImageGetDataArray,
                                       dip_ImageArray, dip_VoidPointerArray *,
                                       dipf_ImageGetDataArray,
                                       dipf_ImageGetData, dip_Resources );

DIP_ERROR dip_ImageGetPlane          ( dip_Image, dip_int * );
DIP_ERROR dip_ImageGetStride         ( dip_Image, dip_IntegerArray *,
                                       dip_Resources );
DIP_ERROR dip_ImageSetRoi            ( dip_Image, dip_Image, dip_Boolean );
DIP_ERROR dip_ImageSetOrigin         ( dip_Image, dip_IntegerArray );
DIP_ERROR dip_ImageSetStride         ( dip_Image, dip_IntegerArray );
DIP_ERROR dip_ImageSetMap            ( dip_Image, dip_IntegerArray );
DIP_ERROR dip_ImageGetID             ( dip_Image, dip_int * );
DIP_ERROR dip_ImageGetName           ( dip_Image, dip_String *, dip_Resources );
DIP_ERROR dip_ImageSetName           ( dip_Image, dip_String );
DIP_ERROR dip_ImageLock              ( dip_Image, dip_int );
DIP_ERROR dip_ImageUnlock            ( dip_Image, dip_int );
DIP_ERROR dip_ResourcesImageSubscribe  ( dip_Image, dipf_RmSubscribe,
                                         dip_Resources );
/*DIP_ERROR dip_ResourceUnsubscribeImage ( dip_Image, dip_Resources );*/



/* from dip_glmanip.c */
DIP_ERROR dip_ImageNew     ( dip_Image *, dip_Resources );
DIP_ERROR dip_ImageForge   ( dip_Image );
DIP_ERROR dip_ImageStrip   ( dip_Image );
DIP_ERROR dip_ImageFree    ( dip_Image * );
DIP_ERROR dip_ImagesSwap   ( dip_Image, dip_Image );
DIP_ERROR dip_ImageReplace ( dip_Image *, dip_Image );
DIP_ERROR dip_ImageAssimilate ( dip_Image, dip_Image );
DIP_ERROR dip_ImageClone   ( dip_Image, dip_Image *, dip_Resources );
DIP_ERROR dip_Copy        ( dip_Image, dip_Image );
DIP_ERROR dip_ImageCopyProperties ( dip_Image, dip_Image );
DIP_ERROR dip_Clear       ( dip_Image );
DIP_ERROR dip_Flatten     ( dip_Image, dip_Image );
DIP_ERROR dip_DefineRoi   ( dip_Image *, dip_Image, dip_Image, dip_IntegerArray,
                            dip_IntegerArray, dip_IntegerArray,
                            dip_IntegerArray, dipf_DefineRoi, dip_Resources );
DIP_ERROR dip_AttachRoi   ( dip_Image );
DIP_ERROR dip_DetachRoi   ( dip_Image );

DIP_ERROR dip_ImagesCompareTwo    ( dip_Image, dip_Image, dipf_ImagesCompare,
                                    dipf_ImagesCompare * );
DIP_ERROR dip_ImagesCompare       ( dip_ImageArray, dipf_ImagesCompare,
                                    dipf_ImagesCompare * );
DIP_ERROR dip_ImageCheck          ( dip_Image, dip_ImageType,
                                    dip_DataTypeProperties );
DIP_ERROR dip_ImagesCheckTwo      ( dip_Image, dip_Image, dip_ImageType,
                                    dip_DataTypeProperties, dipf_ImagesCompare,
                                    dipf_ImagesCheck );
DIP_ERROR dip_ImagesCheck         ( dip_ImageArray, dip_ImageType,
                                    dip_DataTypeProperties, dipf_ImagesCompare,
                                    dipf_ImagesCheck );
DIP_ERROR dip_ImagesCheckDyadic   ( dip_Image, dip_Image, dip_Image*, dip_Image*,
                                    dip_ImageType, dip_DataTypeProperties,
                                    dip_Resources );

DIP_ERROR dip_ImageArrayNew       ( dip_ImageArray *, dip_int, dip_Resources );
DIP_ERROR dip_ImageArrayFree      ( dip_ImageArray * );
DIP_ERROR dip_ImagesUnique        ( dip_Image, dip_Image, dip_Boolean * );
DIP_ERROR dip_MarkInplace        ( dip_ImageArray, dip_ImageArray,
                                   dip_BooleanArray *, dip_BooleanArray,
                                   dip_Resources );
DIP_ERROR dip_PrepareForOutput   ( dip_ImageArray, dip_ImageArray *,
                                   dip_BooleanArray, dip_Resources );
DIP_ERROR dip_ImagesSeparate     ( dip_ImageArray, dip_ImageArray,
                                   dip_ImageArray *, dip_BooleanArray,
                                   dip_Resources );
DIP_ERROR dip_ChangeDataType     ( dip_Image, dip_Image, dip_DataType );
DIP_ERROR dip_ChangeTo0d         ( dip_Image, dip_Image, dip_DataType );
DIP_ERROR dip_ChangeDimensions   ( dip_Image, dip_IntegerArray );
DIP_ERROR dip_ImageGetStride0dAs1d   ( dip_Image, dip_IntegerArray *,
                                       dip_Resources );
DIP_ERROR dip_HasNormalStride    ( dip_Image, dip_Boolean * );
DIP_ERROR dip_HasContiguousData  ( dip_Image, dip_Boolean * );
DIP_ERROR dip_IsBinary           ( dip_Image, dip_Boolean * );
DIP_ERROR dip_IsInteger          ( dip_Image, dip_Boolean * );
DIP_ERROR dip_IsFloat            ( dip_Image, dip_Boolean * );
DIP_ERROR dip_IsComplex          ( dip_Image, dip_Boolean * );
DIP_ERROR dip_IsReal             ( dip_Image, dip_Boolean * );
DIP_ERROR dip_IsSigned           ( dip_Image, dip_Boolean * );
DIP_ERROR dip_IsUnsigned         ( dip_Image, dip_Boolean * );

DIP_ERROR dip_DetermineDataType  ( dip_Image, dip_DataType,
                                   dipf_DataTypeGetInfo,
                                   dip_DataType * );


/* Registry functions for the dip_Image data structure */
DIP_ERROR dip_ImageRegistryList      ( dip_IntegerArray *, dip_Resources );
DIP_ERROR dip_ImageRegistryGet       ( dip_int, dip_Image * );
DIP_ERROR dip_ImageRegistryFree      ( dip_int );

/* this function is used by histogram new/free functions */
dip_Error dip_ImageInitialise  ( void );
dip_Error dip__ImageUnregister ( dip_Image );

#endif /* !SWIG */
#ifdef __cplusplus
}
#endif
#endif
