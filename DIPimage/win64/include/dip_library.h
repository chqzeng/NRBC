/*
 * Filename: dip_library.h
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
 * Defines and functios for the infrastructure library
 *
 * Authors
 *    Michael van Ginkel
 *    Geert van Kempen
 *
 * History
 *    March 1997     - MvG - created ( from older include files /
 *                                     internal reorganization )
 *    September 1999 - CL - changed allocation routines to use user-specified
 *                          malloc, free and realloc.
 *
 *    July 2008      = CL - added CoordinateArray.
 */

#ifndef DIP_LIBRARY_H
#define DIP_LIBRARY_H
#ifdef __cplusplus
extern "C" {
#endif

/* Definition of the DIPlib Image data types */

typedef dip_int dip_DataType;

/* The unsigned integer image types : */

#define DIP_DT_UINT8      ((dip_DataType)  1)
#define DIP_DT_UINT16     ((dip_DataType)  2)
#define DIP_DT_UINT32     ((dip_DataType)  3)

/* The signed integer image types : */

#define DIP_DT_SINT8      ((dip_DataType)  4)
#define DIP_DT_SINT16     ((dip_DataType)  5)
#define DIP_DT_SINT32     ((dip_DataType)  6)

/* The floating point image types : */

#define DIP_DT_SFLOAT     ((dip_DataType)  7)
#define DIP_DT_DFLOAT     ((dip_DataType)  8)
#define DIP_DT_FLOAT      DIP_DT_DFLOAT

/* The complex image types : */

#define DIP_DT_SCOMPLEX   ((dip_DataType)  9)
#define DIP_DT_DCOMPLEX   ((dip_DataType) 10)
#define DIP_DT_COMPLEX    DIP_DT_DCOMPLEX

/* Binary images : */

#define DIP_DT_BIN8       ((dip_DataType) 11)
#define DIP_DT_BIN16      ((dip_DataType) 12)
#define DIP_DT_BIN32      ((dip_DataType) 13)
#define DIP_DT_BINARY     DIP_DT_BIN8

#ifndef DIP_64BITS
#define DIP_DT_UINT       DIP_DT_UINT32
#define DIP_DT_SINT       DIP_DT_SINT32
#define DIP_DT_INT        DIP_DT_SINT32
#else
#define DIP_DT_UINT64     ((dip_DataType) 14)
#define DIP_DT_SINT64     ((dip_DataType) 15)
#define DIP_DT_BIN64      ((dip_DataType) 16)
#define DIP_DT_UINT       DIP_DT_UINT64
#define DIP_DT_SINT       DIP_DT_SINT64
#define DIP_DT_INT        DIP_DT_SINT64
#endif

/* Some meta image types, useful only in very few functions! : */
#define DIP_DT_MINIMUM    ((dip_DataType)  -1) /* use the smallest data type suitable */
#define DIP_DT_FLEX       ((dip_DataType)  -2) /* use a flexible type, i.e. floats */
#define DIP_DT_FLEXBIN    ((dip_DataType)  -3) /* flexible, but allow purely binary ops */
#define DIP_DT_DIPIMAGE   DIP_DT_FLEXBIN       /* follow the DIPimage convention */

typedef enum
{
   DIP_DT_INFO_VALID ,
   DIP_DT_INFO_SIZEOF,
   DIP_DT_INFO_C2R,
   DIP_DT_INFO_PROPS,
   DIP_DT_INFO_R2C,
   DIP_DT_INFO_BITS,
   DIP_DT_INFO_SIZEOF_PTR,
   DIP_DT_INFO_GET_MAXIMUM_PRECISION,
   DIP_DT_INFO_MAXIMUM_VALUE,
   DIP_DT_INFO_MINIMUM_VALUE,
   DIP_DT_INFO_GET_DATATYPE_NAME,
   DIP__DT_INFO_GET_SUBTYPE_INDEX,
   DIP__DT_INFO_GET_MAJORTYPE_INDEX,
   DIP_DT_INFO_SUGGEST_1,
   DIP_DT_INFO_SUGGEST_2, /* for use in dyadic operations with a dip_complex scalar */
   DIP_DT_INFO_TO_FLEX,   /* returns dip_Xfloat or dip_Xcomplex */
   DIP_DT_INFO_TO_FLOAT,
   DIP_DT_INFO_SUGGEST_4,
   DIP_DT_INFO_SUGGEST_5, /* for use in dyadic operations with a dip_int or dip_float scalar */
   DIP_DT_INFO_SUGGEST_6, /* returns dip_dfloat or dip_dcomplex */
   DIP_DT_INFO_GET_SIGNED,
   DIP_DT_INFO_BIN_TO_INT,
   DIP_DT_INFO_TO_DIPIMAGE /* returns dip_bin8, dip_Xfloat or dip_Xcomplex */
} dipf_DataTypeGetInfo;


typedef enum
{
   DIP_DT_NONE        =   0,
   DIP_DT_IS_UINT     =   1,
   DIP_DT_IS_UNSIGNED =   2,
   DIP_DT_IS_SINT     =   4,
   DIP_DT_IS_INT      =   8,
   DIP_DT_IS_INTEGER  =   8,
   DIP_DT_IS_FLOAT    =  16,
   DIP_DT_IS_REAL     =  32,
   DIP_DT_IS_COMPLEX  =  64,
   DIP_DT_IS_SIGNED   = 128,
   DIP_DT_IS_BINARY   = 256,
   DIP_DT_ANY         = 512-1
} dip_DataTypeProperties;

#ifndef SWIG

/* Definition for Resource Management */

typedef struct
{
   void *resources;
} dip__Resources, *dip_Resources;

typedef dip_Error (*dip_ResourcesFreeHandler)( void * );

typedef enum
{
   DIP_RMRS_DEFAULT         = 0,
   DIP_RMRS_FREE_ON_FAILURE = 1
} dipf_RmSubscribe;


typedef struct
{
   dip_int size;
   void *array;
   dip_int elementSize;
   dip_DataType type;
}  dip__Array, *dip_Array;

typedef struct
{
   dip_int size;
   dip_int *array;
}  dip__IntegerArray, *dip_IntegerArray;

typedef struct
{
   dip_int size;
   dip_float *array;
}  dip__FloatArray, *dip_FloatArray;

typedef struct
{
   dip_int size;
   dip_complex *array;
}  dip__ComplexArray, *dip_ComplexArray;

typedef struct
{
   dip_int size;
   dip_Boolean *array;
}  dip__BooleanArray, *dip_BooleanArray;

typedef struct
{
   dip_int size;
   void **array;
}  dip__VoidPointerArray, *dip_VoidPointerArray;


typedef struct
{
   dip_int size;
   dip_DataType *array;
}  dip__DataTypeArray, *dip_DataTypeArray;

typedef struct
{
   dip_int ndims;
   dip_int size;
   dip_int **array; /* first dimension is ndims, second one is size: ca->array[dim][index] */
}  dip__CoordinateArray, *dip_CoordinateArray;


DIP_ERROR dip_ArrayNew         ( dip_Array *, dip_int, dip_int, dip_Resources );
DIP_ERROR dip_IntegerArrayNew  ( dip_IntegerArray *, dip_int,
                                 dip_int, dip_Resources );
DIP_ERROR dip_FloatArrayNew    ( dip_FloatArray *, dip_int,
                                 dip_float, dip_Resources );
DIP_ERROR dip_ComplexArrayNew  ( dip_ComplexArray *, dip_int,
                                 dip_complex,  dip_Resources );
DIP_ERROR dip_BooleanArrayNew  ( dip_BooleanArray *, dip_int,
                                 dip_Boolean, dip_Resources );
DIP_ERROR dip_DataTypeArrayNew ( dip_DataTypeArray *, dip_int,
                                 dip_DataType, dip_Resources );
DIP_ERROR dip_VoidPointerArrayNew
                               ( dip_VoidPointerArray *, dip_int,
                                 dip_Resources );
DIP_ERROR dip_CoordinateArrayNew
                               ( dip_CoordinateArray *, dip_int,
                                 dip_int, dip_Resources );

DIP_ERROR dip_IntegerArrayCopy  ( dip_IntegerArray *, dip_IntegerArray,
                                  dip_Resources );
DIP_ERROR dip_FloatArrayCopy    ( dip_FloatArray *, dip_FloatArray,
                                  dip_Resources );
DIP_ERROR dip_IntToFloatArrayCopy
                                ( dip_FloatArray *, dip_IntegerArray,
                                  dip_Resources );
DIP_ERROR dip_ComplexArrayCopy  ( dip_ComplexArray *, dip_ComplexArray,
                                  dip_Resources );
DIP_ERROR dip_BooleanArrayCopy  ( dip_BooleanArray *, dip_BooleanArray,
                                  dip_Resources );
DIP_ERROR dip_DataTypeArrayCopy ( dip_DataTypeArray *, dip_DataTypeArray,
                                  dip_Resources );
DIP_ERROR dip_VoidPointerArrayCopy
                                ( dip_VoidPointerArray *,
                                  dip_VoidPointerArray, dip_Resources );

DIP_ERROR dip_IntegerArrayFind  ( dip_IntegerArray, dip_int, dip_int *,
                                  dip_Boolean * );
DIP_ERROR dip_FloatArrayFind    ( dip_FloatArray, dip_float, dip_int *,
                                  dip_Boolean * );
DIP_ERROR dip_ComplexArrayFind  ( dip_ComplexArray, dip_complex, dip_int *,
                                  dip_Boolean * );
DIP_ERROR dip_DataTypeArrayFind ( dip_DataTypeArray, dip_DataType, dip_int *,
                                  dip_Boolean * );
DIP_ERROR dip_BooleanArrayFind  ( dip_BooleanArray, dip_Boolean, dip_int *,
                                  dip_Boolean * );
DIP_ERROR dip_VoidPointerArrayFind
                                ( dip_VoidPointerArray, void *, dip_int *,
                                  dip_Boolean * );
                                  
/* defined in dip_library/array.c with a MACRO, CL */
DIP_ERROR dip_IntegerArraySet   ( dip_IntegerArray, dip_int );
DIP_ERROR dip_FloatArraySet     ( dip_FloatArray, dip_float );
DIP_ERROR dip_ComplexArraySet   ( dip_ComplexArray, dip_complex );
DIP_ERROR dip_BooleanArraySet   ( dip_BooleanArray, dip_Boolean );
DIP_ERROR dip_DataTypeArraySet  ( dip_DataTypeArray, dip_DataType );

/* defined in dip_library/array.c with a MACRO, CL */
DIP_ERROR dip_IntegerArrayCompare   ( dip_IntegerArray, dip_IntegerArray, dip_Boolean* );
DIP_ERROR dip_FloatArrayCompare     ( dip_FloatArray, dip_FloatArray, dip_Boolean* );
/*DIP_ERROR dip_ComplexArrayCompare ( dip_ComplexArray, dip_ComplexArray, dip_Boolean* ); */
DIP_ERROR dip_BooleanArrayCompare   ( dip_BooleanArray, dip_BooleanArray, dip_Boolean* );
DIP_ERROR dip_DataTypeArrayCompare  ( dip_DataTypeArray, dip_DataTypeArray, dip_Boolean* );

/* defined in dip_library/array.c with a MACRO, GVK */
DIP_ERROR dip_ArrayFree            ( dip_Array * );
DIP_ERROR dip_IntegerArrayFree     ( dip_IntegerArray * );
DIP_ERROR dip_FloatArrayFree       ( dip_FloatArray * );
DIP_ERROR dip_ComplexArrayFree     ( dip_ComplexArray * );
DIP_ERROR dip_BooleanArrayFree     ( dip_BooleanArray * );
DIP_ERROR dip_VoidPointerArrayFree ( dip_VoidPointerArray * );
DIP_ERROR dip_DataTypeArrayFree    ( dip_DataTypeArray * );
DIP_ERROR dip_CoordinateArrayFree  ( dip_CoordinateArray * );

/* Allocation routines used by DIPlib */
typedef void* (*dip_MemoryNewFunction)(size_t size);
typedef void* (*dip_MemoryReallocateFunction)(void *ptr, size_t size);
typedef void (*dip_MemoryFreeFunction)(void *ptr);

/* DIPlib memory allocation functions */
DIP_ERROR dip_MemoryNew        ( void **, size_t, dip_Resources );
DIP_ERROR dip_MemoryReallocate ( void **, size_t, dip_Resources );
DIP_ERROR dip_MemoryFree       ( void * );
DIP_ERROR dip_MemoryInitialise ( void );
DIP_ERROR dip_MemoryFunctionsSet ( dip_MemoryNewFunction,
                                   dip_MemoryReallocateFunction,
                                   dip_MemoryFreeFunction );
DIP_ERROR dip_MemoryTrack        ( void *, dipf_RmSubscribe, dip_Resources );
DIP_EXPORT void *dip_AllocateMemory   ( size_t );
DIP_EXPORT void dip_FreeMemory        ( void *);
DIP_EXPORT void dip_MemoryCopy        ( void *, void *, dip_int );

DIP_EXPORT dip_Boolean dip_InvertBoolean       ( dip_Boolean );

/* Resource Management */
DIP_ERROR dip_ResourcesNew            ( dip_Resources *, dip_int );
DIP_ERROR dip_ResourcesFree           ( dip_Resources * );
DIP_ERROR dip_ResourcesUnsubscribeAll ( dip_Resources * );
DIP_ERROR dip_ResourcesMerge          ( dip_Resources, dip_Resources * );
DIP_ERROR dip_ResourceSubscribe       ( void *, dip_ResourcesFreeHandler,
                                        dip_Resources );
DIP_ERROR dip_ResourceUnsubscribe     ( void *, dip_Resources );

/* Data type stuff */
DIP_ERROR dip_DataTypeGetInfo          ( dip_DataType, void *,
                                         dipf_DataTypeGetInfo );
DIP_ERROR dip_DetermineCalculationType ( dip_DataType, dip_DataType,
                                         dip_DataType * );
DIP_ERROR dip_DataTypeDyadicOutput     ( dip_DataType, dip_DataType,
                                         dip_DataType * );
DIP_ERROR dip_DataTypeDyadicWithConstant ( dip_DataType, dip_DataType,
                                           dip_DataType * );
DIP_ERROR dip_DataTypeDyadicLogicOutput  ( dip_DataType, dip_DataType,
                                           dip_DataType * );

DIP_ERROR dip_AddOffsetToPointer ( void **, dip_int,
                                   dip_DataType );
DIP_ERROR dip_DataTypeAllowed    ( dip_DataType, dip_Boolean,
                                   dip_DataTypeProperties, dip_Boolean * );

#endif /* !SWIG */

#ifdef __cplusplus
}
#endif
#endif

