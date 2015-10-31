/*
 * Filename: dip_framework.h
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
 * Definition of the 3DPro FrameWork functions
 *
 * Author: Geert M.P. van Kempen
 *
 */

#ifndef DIP_FRAMEWORK_H
#define DIP_FRAMEWORK_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_pixel_table.h"

/*
 * this defines specifies the number of images are stored in one stride buffer
 */
#define DIP_FRAMEWORK_BUFFER_NUMBER_OF_LINES 32
#define DIP_FRAMEWORK_BUFFER_SKEW 8

#define DIP_MONADIC_OPTIMAL_DIMENSION -1
#define DIP_MONADIC_FLOAT_COMPLEX -1

typedef enum
{
	DIP_FRAMEWORK_DEFAULT_OPERATION    = 0,
	DIP_FRAMEWORK_IN_PLACE             = 1,
	DIP_FRAMEWORK_NO_IN_BORDER         = 2,
	DIP_FRAMEWORK_OUT_BORDER           = 4,
	DIP_FRAMEWORK_WRITE_INPUT          = 8,
	DIP_FRAMEWORK_OUTPUT_ACCESS        = 16,
	DIP_FRAMEWORK_USE_BUFFER_TYPES     = 64,
	DIP_FRAMEWORK_NO_BUFFER_STRIDE     = 128,
	DIP_FRAMEWORK_DO_NOT_ADJUST        = 256,
	DIP_FRAMEWORK_USE_OUTPUT_TYPE      = 512,
	DIP_FRAMEWORK_MULTI_THREADING_SAFE = 1024,
	DIP_FRAMEWORK_AS_LINEAR_ARRAY      = 2048
} dipf_FrameWorkOperation;

typedef struct
{
	void             *functionParameters;
	dip_int          dimension;
	dip_int          processNumber;
	dip_DataType     inType;
	dip_int          inStride;
	dip_int          inPlane;
	dip_DataType     outType;
	dip_int          outStride;
	dip_int          outPlane;
	dip_int          outDimension;
	dip_IntegerArray position;
} dip_SeparableFilterParameters;

#define DIP_FW_SEPFILTER_PARAMS_DEFAULT { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }

typedef struct
{
	void             *functionParameters;
	dip_int          dimension;
	dip_int          processNumber;
	dip_DataType     inType;
	dip_int          inStride;
	dip_int          inPlane;
	dip_DataType     outType;
	dip_int          outStride;
	dip_int          outPlane;
	dip_int          outDimension;
	dip_IntegerArray position;
} dip_TwoLinesSeparableFilterParameters;

#define DIP_FW_TWOFILTER_PARAMS_DEFAULT { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }

typedef struct
{
	void             *functionParameters;
	dip_int          dimension;
	dip_int          processNumber;
	dip_DataType     type;
	dip_int          stride;
	dip_int          plane;
	dip_IntegerArray position;
} dip_SingleOutputFilterParameters;

#define DIP_FW_SINGLE_PARAMS_DEFAULT { 0, 0, 0, 0, 0, 0, 0 }

typedef struct
{
	dip_DataType     inType;
	dip_int          inStride;
	dip_int          inPlane;
	dip_DataType     outType;
	dip_int          outStride;
	dip_int          outPlane;
	dip_IntegerArray position;
	void             *functionParameters;
	dip_IntegerArray offset;
	dip_IntegerArray length;
} dip_PixelTableFilterParameters;

typedef struct
{
   dip_DataType     inType;
   dip_IntegerArray inStride;
   dip_IntegerArray inPlane;
   dip_DataType     outType;
   dip_IntegerArray outStride;
   dip_IntegerArray outPlane;
   dip_IntegerArray position;
   void             *functionParameters;
   dip_IntegerArray *offset;
   dip_IntegerArray *length;
} dip_PixelTableArrayFilterParameters;

typedef struct
{
	void              *functionParameters;
	dip_int           dimension;
	dip_int           processNumber;
	dip_DataTypeArray inType;
	dip_IntegerArray  inStride;
	dip_IntegerArray  inPlane;
	dip_DataTypeArray outType;
	dip_IntegerArray  outStride;
	dip_IntegerArray  outPlane;
	dip_int           outDimension;
	dip_IntegerArray  position;
} dip_ScanFrameWorkFilterParameters;


/* typedef of the FrameWorkFilter functions */
typedef dip_Error (*dip_SeparableFilter) (void *, void *, dip_int,
								dip_SeparableFilterParameters );

typedef dip_Error (*dip_TwoLinesSeparableFilter)
                       ( void *, void *, void *, void *, dip_int,
                        dip_TwoLinesSeparableFilterParameters );

typedef dip_Error (*dip_SingleOutputFilter) ( void *, dip_int,
								dip_SingleOutputFilterParameters );

typedef dip_Error (*dip_PixelTableFilter)
	( void *, void *, dip_int, dip_PixelTableFilterParameters );

typedef dip_Error (*dip_PixelTableArrayFilter)
   ( dip_VoidPointerArray, dip_VoidPointerArray, dip_int,
      dip_PixelTableArrayFilterParameters );


typedef dip_Error (*dip_ScanFrameWorkFilter) (dip_VoidPointerArray,
	dip_VoidPointerArray, dip_int, dip_ScanFrameWorkFilterParameters );


/* enum with to specify the different FrameWorkFunctions */
typedef enum
{
   DIP_FRAMEWORK_SEPARABLE_FILTER = 1,
   DIP_FRAMEWORK_TWO_LINES_SEPARABLE_FILTER = 2,
   DIP_FRAMEWORK_SINGLE_OUTPUT_FILTER = 3,
   DIP_FRAMEWORK_PIXEL_TABLE_FILTER = 4,
   DIP_FRAMEWORK_PIXEL_TABLE_ARRAY_FILTER = 5,
   DIP_FRAMEWORK_SCAN_FILTER = 6
} dipf_FrameWorkFilter;

typedef union
{
   dip_SeparableFilter             separableFilter;
   dip_TwoLinesSeparableFilter     twoLinesSeparableFilter;
   dip_SingleOutputFilter          singleOutputFilter;
   dip_PixelTableFilter            pixelTableFilter;
   dip_PixelTableArrayFilter       pixelTableArrayFilter;
   dip_ScanFrameWorkFilter         scanFrameWorkFilter;
} dip_FrameWorkFilter;

typedef union
{
   dip_SeparableFilterParameters          separableParameters;
   dip_TwoLinesSeparableFilterParameters  twoLinesSeparableParameters;
   dip_SingleOutputFilterParameters       singleOutputParameters;
   dip_PixelTableFilterParameters         pixelTableParameters;
   dip_ScanFrameWorkFilterParameters      scanFrameWorkParameters;
} dip_FrameWorkFilterParameters;

typedef struct
{
   dip_Boolean            process;
   dip_int                dimension;
   dipf_FrameWorkFilter   filterType;
   dip_FrameWorkFilter    filter;
   void                   *parameters;
   dip_DataType           inputBufferType;
   dip_DataType           outputBufferType;
   dip_int                border;
} dip_LineFilter;

typedef struct
{
	dip_int size;
	dip_LineFilter *array;
} dip__LineFilterArray, *dip_LineFilterArray;

typedef struct
{
	dipf_FrameWorkOperation operation;
	dip_DataType            outputType;
	dip_LineFilterArray     filter;
} dip__FrameWorkProcess, *dip_FrameWorkProcess;

typedef dip_float   (*dip_MonadicFloatFunction)   ( dip_float );
typedef dip_complex (*dip_MonadicComplexFunction) ( dip_complex );
typedef dip_float   (*dip_MonadicDataFloatFunction)
								( dip_float, dip_IntegerArray, void * );
typedef dip_complex (*dip_MonadicDataComplexFunction)
								( dip_complex, dip_IntegerArray, void * );
typedef dip_float   (*dip_SingleOutputFloatFunction)
								( dip_IntegerArray, void * );
typedef dip_complex (*dip_SingleOutputComplexFunction)
								( dip_IntegerArray, void * );

/* the dip_FrameWork function prototypes */
DIP_ERROR dip_FrameWorkProcessNew ( dip_FrameWorkProcess *,
                                    dip_int, dip_Resources );

DIP_ERROR dip_SeparableFrameWork ( dip_Image, dip_Image, dip_BoundaryArray,
	dip_FrameWorkProcess );

DIP_ERROR dip_MonadicFrameWork ( dip_Image, dip_Image, dip_Boundary,
	dip_FrameWorkProcess );

DIP_ERROR dip_SingleOutputFrameWork ( dip_Image, dip_Boundary,
	dip_FrameWorkProcess );

DIP_ERROR dip_PixelTableFrameWork ( dip_Image, dip_Image, dip_BoundaryArray,
	dip_FrameWorkProcess, dip_PixelTable );

DIP_ERROR dip_PixelTableArrayFrameWork ( dip_ImageArray, dip_ImageArray,
   dip_BoundaryArray, dip_FrameWorkProcess, dip_PixelTable );

DIP_ERROR dip_ScanFrameWork ( dip_ImageArray, dip_ImageArray,
	dip_FrameWorkProcess, dip_BoundaryArray, dip_IntegerArray,
	dip_DataTypeArray, dip_DataTypeArray, dip_DataTypeArray );

DIP_ERROR dip_MonadicPoint ( dip_Image, dip_Image, dip_MonadicFloatFunction,
	dip_MonadicComplexFunction, dip_DataTypeProperties, dip_DataType );

DIP_ERROR dip_MonadicPointData ( dip_Image, dip_Image,
	dip_MonadicDataFloatFunction, dip_MonadicDataComplexFunction,
	void *, dip_DataTypeProperties, dip_DataType );

DIP_ERROR dip_SingleOutputPoint ( dip_Image,
	dip_SingleOutputFloatFunction, dip_SingleOutputComplexFunction,
	void *, dip_DataTypeProperties, dip_DataType );

#ifdef __cplusplus
}
#endif
#endif
