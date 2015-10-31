/*
 * Filename: dip_error.h
 *
 * (C) Copyright 1995-1999               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 * Definition of the DIPlib error handling mechanism
 *
 * Authors: Michael van Ginkel - original idea to consistently use the
 *                               return value for errors (pre-DIP)
 *          Geert van Kempen   - propagate function name call tree
 *          Michael van Ginkel - clean re-implementation. Combine
 *                               error stuff and resources stuff.
 */

#ifndef DIP_ERROR_H
#define DIP_ERROR_H
#ifdef __cplusplus
extern "C" {
#endif

#ifndef SWIG

/* memory allocation errors */
DIP_EXPORT extern const char dip_errorCouldNotAllocateMemory[];
DIP_EXPORT extern const char dip_errorMemoryInitialisationFailed[];

/* image creation errors */
DIP_EXPORT extern const char dip_errorImageIsLocked[];
DIP_EXPORT extern const char dip_errorImageNotRaw[];
DIP_EXPORT extern const char dip_errorImageNotValid[];
DIP_EXPORT extern const char dip_errorImagesNotUnique[];
DIP_EXPORT extern const char dip_errorImageLockInvalidKey[];

/* image type errors */
DIP_EXPORT extern const char dip_errorIllegalImageType[];
DIP_EXPORT extern const char dip_errorImageTypeDoesNotExist[];
DIP_EXPORT extern const char dip_errorImageTypeAlreadyExists[];
DIP_EXPORT extern const char dip_errorImageTypeNotSupported[];
DIP_EXPORT extern const char dip_errorImageTypeHandlerMissing[];

/* image data type errors */
DIP_EXPORT extern const char dip_errorDataTypeNotSupported[];
DIP_EXPORT extern const char dip_errorIllegalDataType[];

/* image dimensionality and dimensions error */
DIP_EXPORT extern const char dip_errorIllegalDimensionality[];
DIP_EXPORT extern const char dip_errorDimensionalityNotSupported[];
DIP_EXPORT extern const char dip_errorIllegalDimension[];

/* image properties errors */
DIP_EXPORT extern const char dip_errorNonNormalStride[];

/* image roi errors */
DIP_EXPORT extern const char dip_errorImageMustBeRoi[];
DIP_EXPORT extern const char dip_errorImageIsRoi[];
DIP_EXPORT extern const char dip_errorInvalidRoiMap[];

/* error produced by the interface to DIPlib */
DIP_EXPORT extern const char dip_errorInterfaceError[];
DIP_EXPORT extern const char dip_errorInterfaceImageTypeNotSupported[];
DIP_EXPORT extern const char dip_errorInterfaceDataTypeNotSupported[];

/* resource tracking errors */
DIP_EXPORT extern const char dip_errorResourceManagementRequired[];
DIP_EXPORT extern const char dip_errorResourceNotFound[];

/* miscellaneous errors */
DIP_EXPORT extern const char dip_errorNoGlobalStructure[];
DIP_EXPORT extern const char dip_errorSwitchError[];
DIP_EXPORT extern const char dip_errorNotImplemented[];

/* array errors */
DIP_EXPORT extern const char dip_errorArrayIllegalSize[];
DIP_EXPORT extern const char dip_errorArraySizesDontMatch[];
DIP_EXPORT extern const char dip_errorArrayOverflow[];

/* boundary and filter shape errors */
DIP_EXPORT extern const char dip_errorFilterShapeNotSupported[];
DIP_EXPORT extern const char dip_errorBoundaryConditionNotSupported[];

/* dip_ImagesCompareTwo errors */
DIP_EXPORT extern const char dip_errorImageDontMatch[];
DIP_EXPORT extern const char dip_errorTypesDontMatch[];
DIP_EXPORT extern const char dip_errorDataTypesDontMatch[];
DIP_EXPORT extern const char dip_errorDimensionalitiesDontMatch[];
DIP_EXPORT extern const char dip_errorDimensionsDonMatch[];

/* function parameter errors */
DIP_EXPORT extern const char dip_errorInvalidParameter[];
DIP_EXPORT extern const char dip_errorInvalidFlag[];
DIP_EXPORT extern const char dip_errorParameterOutOfRange[];

/* mask error codes */
DIP_EXPORT extern const char dip_errorNoMask[];
DIP_EXPORT extern const char dip_errorMaskIsNotBinary[];

/* pixel table errors */
DIP_EXPORT extern const char dip_errorPixelTableIsNotAllocated[];
DIP_EXPORT extern const char dip_errorPixelTableNotEnoughRuns[];
DIP_EXPORT extern const char dip_errorPixelTableHasNoData[];

/* timer error code */
DIP_EXPORT extern const char dip_errorTimeFailed[];

/* silly errors */
DIP_EXPORT extern const char dip_errorSomethingIsWrong[];


#define DIP_OK 0
#define DIP_E_NO_MEMORY \
   dip_errorCouldNotAllocateMemory
#define DIP_E_NO_GLOBAL_STRUCTURE \
   dip_errorNoGlobalStructure
#define DIP_E_INVALID_PARAMETER \
   dip_errorInvalidParameter
#define DIP_E_INVALID_FLAG \
   dip_errorInvalidFlag
#define DIP_E_RESOURCE_NOT_FOUND \
   dip_errorResourceNotFound
#define DIP_E_IMAGE_IS_LOCKED \
   dip_errorImageIsLocked
#define DIP_E_IMAGE_NOT_RAW \
   dip_errorImageNotRaw
#define DIP_E_ILLEGAL_DIMENSIONALITY \
   dip_errorIllegalDimensionality
#define DIP_E_ILLEGAL_DIMENSION \
   dip_errorIllegalDimension
#define DIP_E_RESOURCE_TRACKING_REQUIRED \
   dip_errorResourceManagementRequired
#define DIP_E_IMAGE_NOT_VALID \
   dip_errorImageNotValid
#define DIP_E_IMAGE_LOCK_INVALID_KEY \
   dip_errorImageLockInvalidKey
#define DIP_E_IMAGE_MUST_BE_ROI \
   dip_errorImageMustBeRoi
#define DIP_E_DATA_TYPE_NOT_SUPPORTED \
   dip_errorDataTypeNotSupported
#define DIP_E_DIMENSIONALITY_NOT_SUPPORTED \
   dip_errorDimensionalityNotSupported
#define DIP_E_IMAGES_DONT_MATCH \
   dip_errorImageDontMatch
#define DIP_E_TYPES_DONT_MATCH \
   dip_errorTypesDontMatch
#define DIP_E_DATA_TYPES_DONT_MATCH \
   dip_errorDataTypesDontMatch
#define DIP_E_DIMENSIONALITIES_DONT_MATCH \
   dip_errorDimensionalitiesDontMatch
#define DIP_E_DIMENSIONS_DONT_MATCH \
   dip_errorDimensionsDonMatch
#define DIP_E_ILLEGAL_IMAGE_TYPE \
   dip_errorIllegalImageType
#define DIP_E_NO_NORMAL_STRIDE \
   dip_errorNonNormalStride
#define DIP_E_IMAGE_IS_ROI \
   dip_errorImageIsRoi
#define DIP_E_IMAGE_TYPE_HANDLER_MISSING \
   dip_errorImageTypeHandlerMissing
#define DIP_E_INVALID_ROI_MAP \
   dip_errorInvalidRoiMap
#define DIP_E_IMAGE_TYPE_DOES_NOT_EXIST \
   dip_errorImageTypeDoesNotExist
#define DIP_E_IMAGE_TYPE_ALREADY_EXISTS \
   dip_errorImageTypeAlreadyExists
#define DIP_E_IMAGE_TYPE_NOT_SUPPORTED \
   dip_errorImageTypeNotSupported
#define DIP_E_IMAGES_NOT_UNIQUE \
   dip_errorImagesNotUnique
#define DIP_E_ARRAY_ILLEGAL_SIZE \
   dip_errorArrayIllegalSize
#define DIP_E_PARAMETER_OUT_OF_RANGE \
   dip_errorParameterOutOfRange
#define DIP_E_NOT_IMPLEMENTED \
   dip_errorNotImplemented
#define DIP_E_FILTER_SHAPE_NOT_SUPPORTED \
   dip_errorFilterShapeNotSupported
#define DIP_E_SWITCH_ERROR \
   dip_errorSwitchError
#define DIP_E_BOUNDARY_CONDITION_NOT_SUPPORTED \
   dip_errorBoundaryConditionNotSupported
#define DIP_E_PIXEL_TABLE_IS_NOT_ALLOCATED \
   dip_errorPixelTableIsNotAllocated
#define DIP_E_PIXEL_TABLE_NOT_ENOUGH_RUNS \
   dip_errorPixelTableNotEnoughRuns
#define DIP_E_PIXEL_TABLE_RUN_HAS_NO_DATA \
   dip_errorPixelTableHasNoData
#define DIP_E_SOMETHING_IS_WRONG \
   dip_errorSomethingIsWrong
#define DIP_E_ARRAY_OVERFLOW \
   dip_errorArrayOverflow
#define DIP_E_TIME_FAILED \
   dip_errorTimeFailed
#define DIP_E_ILLEGAL_DATA_TYPE \
   dip_errorIllegalDataType
#define DIP_E_NO_MASK \
   dip_errorNoMask
#define DIP_E_MASK_IS_NOT_BINARY \
   dip_errorMaskIsNotBinary
#define DIP_E_IF_IMAGE_TYPE_NOT_SUPPORTED \
   dip_errorInterfaceImageTypeNotSupported
#define DIP_E_IF_DATA_TYPE_NOT_SUPPORTED \
   dip_errorInterfaceDataTypeNotSupported
#define DIP_E_INTERFACE_ERROR \
   dip_errorInterfaceError
#define DIP_E_ARRAY_SIZES_DONT_MATCH \
   dip_errorArraySizesDontMatch
#define DIP_E_MEMORY_INIT_FAILED \
   dip_errorMemoryInitialisationFailed

#endif

typedef struct dip_ErrorTag
{
   struct dip_ErrorTag *next;
   struct dip_ErrorTag *up;
   const char *function;
   char *message;
} dip__Error, *dip_Error;

DIP_EXPORT dip_Boolean dip_ErrorWrite( dip_Error, const char *,
													const char *, FILE * );

#define DIPXJ( function ) \
/* Heel storend */ \
   if (( *errorNext = function ) != DIP_OK ) \
   { \
      errorNext = &((*errorNext)->next); \
      goto dip_error; \
   }
#define DIPXC( function ) \
   if (( *errorNext = function ) != DIP_OK ) \
   { \
      errorNext = &((*errorNext)->next); \
   }
#define DIPSJ( message ) \
   { dip_error_message = message; goto dip_error; }
#define DIPJF( message ) \
   { dip_error_message = message; dip_error_free = DIP_TRUE; goto dip_error; }

#define DIPTS( condition, message ) \
   if ( condition ) { dip_error_message = message; goto dip_error; }

#define DIP_FN_DECLARE(name) \
   static const char dip_error_function[]=name; \
   dip_Error error = 0, *errorNext=&error; \
   const char *dip_error_message = 0; \
   dip_Boolean dip_error_free = DIP_FALSE
#define DIP_FN_EXIT \
   return( dip_ErrorExit( error, dip_error_function, dip_error_message, \
                          errorNext, dip_error_free ))

#define DIP_FNR_DECLARE(name) \
   static const char dip_error_function[]=name; \
   dip_Error error = 0, *errorNext=&error; \
   const char *dip_error_message = 0; \
   dip_Boolean dip_error_free = DIP_FALSE; \
   dip_Resources rg = 0
#define DIP_FNR_INITIALISE \
   DIPXJ( dip_ResourcesNew( &rg, 0 ))
#define DIP_FNR_EXIT \
   DIPXC( dip_ResourcesFree( &rg )); \
   return( dip_ErrorExit( error, dip_error_function, dip_error_message, \
                          errorNext, dip_error_free ))

#define DIPPS( function ) \
   if (( *thread_errorNext = function ) != DIP_OK ) \
   { \
      thread_errorNext = &((*thread_errorNext)->next); \
   }

#ifndef MSVC
#define DIP_PS_TESTERR( globvar, locallab ) \
   if ( thread_error != DIP_OK ) \
   { \
      _Pragma("omp critical (DIP_PS_TESTERR)") \
         if( (globvar) == DIP_OK ) \
            (globvar) = *thread_errorNext; \
      goto locallab; \
   }
#else // MSVC
#define DIP_PS_TESTERR( globvar, locallab ) \
   if ( thread_error != DIP_OK ) \
   { \
       __pragma("omp critical (DIP_PS_TESTERR)") \
         if( (globvar) == DIP_OK ) \
            (globvar) = *thread_errorNext; \
      goto locallab; \
	}
#endif // MSVC

#define DIP_PS_DECLARE \
   dip_Error thread_error = 0, *thread_errorNext=&thread_error

#define DIP_PSR_DECLARE \
   dip_Error thread_error = 0, *thread_errorNext=&thread_error; \
   dip_Resources thread_rg = 0
#define DIP_PSR_INITIALISE \
   DIPPS( dip_ResourcesNew( &thread_rg, 0 ))
#define DIP_PSR_FREE \
   DIPPS( dip_ResourcesFree( &thread_rg ))


DIP_ERROR dip_ErrorExit( dip_Error, const char *, const char *,
                         dip_Error *, dip_Boolean );
void DIP_EXPORT dip_ErrorFree( dip_Error );

#ifdef DEBUG
#define DIP_ASSERT( condition, message ) \
   DIPTS( !(condition), "DIPlib assertion failed: " message )
#else
#define DIP_ASSERT( condition, message ) /* Do nothing */
#endif

#define DIP_IF_ERROR if (( error ) || ( dip_error_message ))

#ifdef __cplusplus
}
#endif
#endif
