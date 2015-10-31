/*
 * Filename: dip_distribution.h
 *
 * Defines and functions for the distribution datastructure
 *
 * AUTHOR
 *    Geert van Kempen, Unilever Research Vlaardingen, 1999
 */

#ifndef DIP_DISTRIBUTION_H
#define DIP_DISTRIBUTION_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_string.h"
#include "dip_registry.h"
#include "dip_uuid.h"

/* Definition of DIPlib Distribution */

typedef struct
{
   void *distribution;
} dip__Distribution, *dip_Distribution;

typedef struct
{
   dip_int size;
   dip_Distribution *array;
}  dip__DistributionArray, *dip_DistributionArray;

typedef enum
{
   DIP_DBST_IS_RAW    = 0x00,
   DIP_DBST_IS_VALID  = 0x01
} dip_DistributionState;

typedef enum
{
   DIP_DB_SAMPLING_LINEAR       = 0x00,
   DIP_DB_SAMPLING_NATURAL_LOG  = 0x01
} dipf_DistributionSampling;

DIP_ERROR dip_DistributionArrayNew  ( dip_DistributionArray *, dip_int,
                                      dip_Resources );
DIP_ERROR dip_DistributionArrayCopy ( dip_DistributionArray *,
                                      dip_DistributionArray, dip_Resources );
/*
DIP_ERROR dip_DistributionArrayFree ( dip_DistributionArray * );
*/

DIP_ERROR dip_DistributionGetState       ( dip_Distribution,
                                           dip_DistributionState * );
DIP_ERROR dip_DistributionValid          ( dip_Distribution, dip_Boolean * );
DIP_ERROR dip_DistributionRaw            ( dip_Distribution, dip_Boolean * );

DIP_ERROR dip_DistributionGetNumberOfBins( dip_Distribution,
                                           dip_IntegerArray *, dip_Resources );
DIP_ERROR dip_DistributionGetBinSize     ( dip_Distribution, dip_FloatArray *,
                                           dip_Resources );
DIP_ERROR dip_DistributionGetMaximum     ( dip_Distribution, dip_FloatArray *,
                                           dip_Resources );
DIP_ERROR dip_DistributionGetMinimum     ( dip_Distribution, dip_FloatArray *,
                                           dip_Resources );
DIP_ERROR dip_DistributionSetNumberOfBins( dip_Distribution, dip_IntegerArray );
DIP_ERROR dip_DistributionSetBinSize     ( dip_Distribution, dip_FloatArray );
DIP_ERROR dip_DistributionSetMinimum     ( dip_Distribution, dip_FloatArray );
DIP_ERROR dip_DistributionSetMaximum     ( dip_Distribution, dip_FloatArray );

DIP_ERROR dip_DistributionGetImage       ( dip_Distribution, dip_Image * );
DIP_ERROR dip_DistributionGetDataType    ( dip_Distribution, dip_DataType * );
DIP_ERROR dip_DistributionSetDataType    ( dip_Distribution, dip_DataType );
DIP_ERROR dip_DistributionGetSize        ( dip_Distribution, dip_int * );
DIP_ERROR dip_DistributionGetData        ( dip_Distribution, void ** );
DIP_ERROR dip_DistributionGetResources   ( dip_Distribution, dip_Resources * );
DIP_ERROR dip_DistributionGetDimensions  ( dip_Distribution, dip_IntegerArray *,
                                           dip_Resources );
DIP_ERROR dip_DistributionGetDimensionality( dip_Distribution, dip_int * );
DIP_ERROR dip_DistributionGetID          ( dip_Distribution, dip_int * );
DIP_ERROR dip_DistributionSetName        ( dip_Distribution, dip_String );
DIP_ERROR dip_DistributionGetName        ( dip_Distribution, dip_String *,
                                           dip_Resources );
DIP_ERROR dip_DistributionSetSampling    ( dip_Distribution,
                                           dipf_DistributionSampling );
DIP_ERROR dip_DistributionGetSampling    ( dip_Distribution,
                                           dipf_DistributionSampling * );
DIP_ERROR dip_DistributionSetTypeID      ( dip_Distribution, dip_int );
DIP_ERROR dip_DistributionGetTypeID      ( dip_Distribution, dip_int * );
DIP_ERROR dip_DistributionSetTypeData    ( dip_Distribution, void * );
DIP_ERROR dip_DistributionGetTypeData    ( dip_Distribution, void ** );

DIP_ERROR dip_DistributionGetFloat       ( dip_Distribution, dip_FloatArray,
                                           dip_float * );
DIP_ERROR dip_DistributionSetFloat       ( dip_Distribution, dip_FloatArray,
                                           dip_float );
DIP_ERROR dip_DistributionAddFloat       ( dip_Distribution, dip_FloatArray,
                                           dip_float );

DIP_ERROR dip_DistributionNew            ( dip_Distribution *, dip_Resources );
DIP_ERROR dip_DistributionFree           ( dip_Distribution * );
DIP_ERROR dip_DistributionForge          ( dip_Distribution );
DIP_ERROR dip_DistributionStrip          ( dip_Distribution );

DIP_ERROR dip_DistributionCopy           ( dip_Distribution, dip_Distribution );
DIP_ERROR dip_DistributionCopyProperties ( dip_Distribution, dip_Distribution ); /* Do not call if the example distribution doesn't have all fields set -- this is not tested for!!! */
DIP_ERROR dip_DistributionAssimilate     ( dip_Distribution, dip_Distribution );
DIP_ERROR dip__DistributionForge         ( dip_Distribution, dip_Image,
                                           dip_Resources * );

DIP_ERROR dip_DistributionToImage        ( dip_Distribution, dip_Image );

DIP_EXPORT dip_int dip_ChordLengthID           ( void );
DIP_EXPORT dip_int dip_PairCorrelationID       ( void );
/*
DIP_EXPORT dip_int dip_RandomPairCorrelationID ( void );
*/

/* Registry functions for the dip_Distribution data structure */
DIP_ERROR dip_DistributionRegistryList  ( dip_IntegerArray *, dip_Resources );
DIP_ERROR dip_DistributionRegistryGet   ( dip_int, dip_Distribution * );
DIP_ERROR dip_DistributionRegistryFree  ( dip_int );

dip_Error dip_DistributionInitialise    ( void );
dip_int dip_RegistryDistributionClass   ( void );
#define DIP_REGISTRY_CLASS_DISTRIBUTION dip_RegistryDistributionClass()

#ifdef __cplusplus
}
#endif
#endif
