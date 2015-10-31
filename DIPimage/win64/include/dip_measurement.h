#ifndef DIP_MEASUREMENT_H
#define DIP_MEASUREMENT_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_uuid.h"
#include "dip_chaincode.h"
#include "dip_histogram.h"
#include "dip_registry.h"

/* default angle stepsize of the feret diameter measure function */
#define DIP_MSR_FERET_ACCURACY   2.0 /* unit: degrees */

/* measurement feature class identifier */
dip_int dip_RegistryMeasurementClass( void );
dip_int dip_RegistryFeatureClass( void );
#define DIP_REGISTRY_CLASS_MEASUREMENT    dip_RegistryMeasurementClass()
#define DIP_REGISTRY_CLASS_FEATURE        dip_RegistryFeatureClass()

typedef struct
{
   dipf_Select decision;
   dip_FloatArray bound;
} dip_FeaturesSelectParameters;

typedef enum
{
   DIP_MSR_FUNCTION_LINE_BASED = 1,
   DIP_MSR_FUNCTION_IMAGE_BASED,
   DIP_MSR_FUNCTION_CHAINCODE_BASED,
   DIP_MSR_FUNCTION_CONVHULL_BASED,
   DIP_MSR_FUNCTION_COMPOSITE
} dipf_FeatureMeasureFunction;

typedef enum
{
   DIP_MSR_VALUE_FORMAT_INTEGER = 1,
   DIP_MSR_VALUE_FORMAT_FLOAT,
   DIP_MSR_VALUE_FORMAT_INTEGER_ARRAY,
   DIP_MSR_VALUE_FORMAT_FLOAT_ARRAY
} dipf_MeasurementValueFormat;

typedef struct
{
   void *measurement;
} dip__Measurement, *dip_Measurement;

typedef struct dipFeatureDescription
{
   void *data;
} dip__FeatureDescription, *dip_FeatureDescription;


typedef dip_Error (*dip_FeatureCreateFunction)
                            ( dip_Measurement, dip_int, dip_Image, dip_Image,
                              dip_PhysicalDimensions, void *, void **,
                              dip_Resources );
typedef dip_Error (*dip_FeatureComposeFunction)
                            ( dip_Measurement, dip_int, dip_Image, dip_Image,
                              dip_IntegerArray *, dip_Resources );
typedef dip_Error (*dip_FeatureLineFunction)
                            ( dip_Measurement, dip_int, dip_sint32 *, dip_float *,
                              dip_int, dip_IntegerArray, dip_int, dip_int );
typedef dip_Error (*dip_FeatureImageFunction)
                            ( dip_Measurement, dip_int, dip_Image, dip_Image,
                              dip_IntegerArray, dip_int );
typedef dip_Error (*dip_FeatureChainCodeFunction)
                            ( dip_Measurement, dip_int,
                              dip_int, dip_ChainCode, dip_int );
typedef dip_Error (*dip_FeatureConvHullFunction)
                            ( dip_Measurement, dip_int,
                              dip_int, dip_Polygon, dip_int );
typedef dip_Error (*dip_FeatureCompositeFunction)
                            ( dip_Measurement, dip_int,
                              dip_int, dip_Measurement, dip_int );
typedef dip_Error (*dip_FeatureValueFunction)
                            ( dip_Measurement, dip_int, dip_int,
                              dip_PhysicalDimensions, void **,
                              dipf_MeasurementValueFormat *, dip_Resources );
typedef dip_Error (*dip_FeatureDescriptionFunction)
                            ( dip_Measurement, dip_int, dip_PhysicalDimensions,
                              dip_FeatureDescription *, dip_Resources );
typedef dip_Error (*dip_FeatureConvertFunction)
                            ( dip_Measurement, dip_int, dip_int,
                              dip_Measurement, dip_int, dip_Resources );


typedef dip_Error (*dip_FeaturesSelectFunction)  ( dip_Measurement,
                                                   dip_IntegerArray, dip_int,
                                                   void *, dip_Boolean * );

typedef union
{
   dip_FeatureLineFunction      line;
   dip_FeatureImageFunction     image;
   dip_FeatureChainCodeFunction chaincode;
   dip_FeatureConvHullFunction  convhull;
   dip_FeatureCompositeFunction composite;
} dip_FeatureMeasureFunction;

typedef struct
{
   dip_Identifier id;
   dipf_FeatureMeasureFunction    type;
   dip_FeatureCreateFunction      create;
   dip_FeatureComposeFunction     compose;
   dip_FeatureMeasureFunction     measure;
   dip_FeatureValueFunction       value;
   dip_FeatureDescriptionFunction description;
   dip_FeatureConvertFunction     convert;
   dip_int                        iterations;
   dip_Boolean                    needIntensityIm;
} dip_MeasurementFeatureRegistry;

DIP_ERROR dip_MeasurementNew      ( dip_Measurement *, dip_Resources );
DIP_ERROR dip_MeasurementFree     ( dip_Measurement * );
DIP_ERROR dip_Measure             ( dip_Measurement, dip_IntegerArray,
                                    dip_VoidPointerArray, dip_IntegerArray,
                                    dip_Image, dip_Image, dip_int,
                                    dip_PhysicalDimensions );
DIP_ERROR dip_ObjectToMeasurement ( dip_Image, dip_Image, dip_Image, dip_int,
                                    dip_IntegerArray, dip_int, dip_int );
DIP_ERROR dip_MeasurementToHistogram ( dip_Histogram, dip_Measurement,
                                     dip_IntegerArray, dip_FloatArray,
                                     dip_FloatArray, dip_FloatArray,
                                     dip_Boolean, dip_Boolean );
DIP_ERROR dip_SmallObjectsRemove ( dip_Image, dip_Image, dip_int );
DIP_ERROR dip_MeasurementToImage  ( dip_Measurement, dip_Image,
                                    dip_IntegerArray, dip_IntegerArray );

/* more or less internal measurement functions */
DIP_ERROR dip_MeasurementForge          ( dip_Measurement, dip_IntegerArray,
                                          dip_IntegerArray );
DIP_ERROR dip_MeasurementIsValid        ( dip_Measurement, dip_Boolean * );
DIP_ERROR dip_MeasurementID             ( dip_Measurement, dip_int * );
DIP_ERROR dip_MeasurementSetName        ( dip_Measurement, dip_String );
DIP_ERROR dip_MeasurementGetName        ( dip_Measurement, dip_String *,
                                          dip_Resources );
DIP_ERROR dip_MeasurementSetPhysicalDimensions
                                        ( dip_Measurement, dip_PhysicalDimensions );
DIP_ERROR dip_MeasurementGetPhysicalDimensions
                                        ( dip_Measurement, dip_PhysicalDimensions *,
                                          dip_Resources );

DIP_ERROR dip_MeasurementNumberOfFeatures   ( dip_Measurement, dip_int * );
DIP_ERROR dip_MeasurementFeatures           ( dip_Measurement,
                                              dip_IntegerArray *,
                                              dip_Resources );
DIP_ERROR dip_MeasurementFeatureValid       ( dip_Measurement, dip_int,
                                              dip_Boolean * );
DIP_ERROR dip_MeasurementFeatureConvert     ( dip_Measurement, dip_int, dip_int,
                                              dip_Measurement, dip_int,
                                              dip_Resources );
DIP_ERROR dip_MeasurementFeatureDescription ( dip_Measurement, dip_int,
                                              dip_FeatureDescription *,
                                              dip_Resources );
DIP_ERROR dip_MeasurementFeatureFormat      ( dip_Measurement, dip_int,
                                              dipf_MeasurementValueFormat * );
DIP_ERROR dip_MeasurementFeatureSize        ( dip_Measurement, dip_int,
                                              dip_int * );

DIP_ERROR dip_MeasurementNumberOfObjects    ( dip_Measurement, dip_int * );
DIP_ERROR dip_MeasurementObjects            ( dip_Measurement, dip_int,
                                              dip_IntegerArray *,
                                              dip_Resources );
DIP_ERROR dip_MeasurementObjectValid        ( dip_Measurement, dip_int,
                                              dip_int, dip_Boolean * );
DIP_ERROR dip_MeasurementObjectData         ( dip_Measurement, dip_int,
                                              dip_int, void **, dip_Boolean * );
DIP_ERROR dip_MeasurementObjectValue        ( dip_Measurement, dip_int,
                                              dip_int, void **,
                                              dipf_MeasurementValueFormat *,
                                              dip_Resources );

DIP_ERROR dip_FeatureDescriptionNew            ( dip_FeatureDescription *,
                                                 dip_Resources );
DIP_ERROR dip_FeatureDescriptionFree           ( dip_FeatureDescription * );
DIP_ERROR dip_FeatureDescriptionSetName        ( dip_FeatureDescription,
                                                 char * );
DIP_ERROR dip_FeatureDescriptionGetName        ( dip_FeatureDescription,
                                                 dip_String *, dip_Resources );
DIP_ERROR dip_FeatureDescriptionSetDescription ( dip_FeatureDescription,
                                                 char * );
DIP_ERROR dip_FeatureDescriptionGetDescription ( dip_FeatureDescription,
                                                 dip_String *, dip_Resources );
DIP_ERROR dip_FeatureDescriptionSetLabels      ( dip_FeatureDescription,
                                                 dip_Measurement, dip_int,
                                                 dip_StringArray, char * );
DIP_ERROR dip_FeatureDescriptionGetLabels      ( dip_FeatureDescription,
                                                 dip_StringArray *,
                                                 dip_Resources );
DIP_ERROR dip_FeatureDescriptionSetLabel       ( dip_FeatureDescription,
                                                 dip_int, char * );
DIP_ERROR dip_FeatureDescriptionSetUnits       ( dip_FeatureDescription,
                                                 dip_Measurement, dip_int,
                                                 dip_StringArray, char * );
DIP_ERROR dip_FeatureDescriptionGetUnits       ( dip_FeatureDescription,
                                                 dip_StringArray *,
                                                 dip_Resources );
DIP_ERROR dip_FeatureDescriptionSetUnit        ( dip_FeatureDescription,
                                                 dip_int, char * );
DIP_ERROR dip_FeatureDescriptionSetDimensionLabels ( dip_FeatureDescription,
                                                     dip_Measurement, dip_int,
                                                     char * );

DIP_ERROR dip_SurfaceArea                   ( dip_Image, dip_IntegerArray,
                                              dip_FloatArray *, dip_Resources);


/* measurement registry functions */
DIP_ERROR dip_MeasurementFeatureRegister        ( dip_MeasurementFeatureRegistry );
DIP_ERROR dip_MeasurementFeatureRegistryList    ( dip_IntegerArray *, dip_Resources );
DIP_ERROR dip_MeasurementFeatureRegistryGet     ( dip_int, dip_MeasurementFeatureRegistry * );
DIP_ERROR dip_MeasurementFeatureRegistryFeatureDescription
                                                ( dip_int, dip_FeatureDescription *,
                                                  dip_Resources );
DIP_ERROR dip_MeasurementFeatureRegistryFeatureNeedsIntensityImage
                                                ( dip_int, dip_Boolean * );


/* ID functions of standard measurement functions */
DIP_EXPORT dip_int dip_FeatureAnisotropy2DID ( void );
DIP_EXPORT dip_int dip_FeatureBendingEnergyID( void );
DIP_EXPORT dip_int dip_FeatureCenterID       ( void );
DIP_EXPORT dip_int dip_FeatureChainCodeBendingEnergyID( void );
DIP_EXPORT dip_int dip_FeatureConvexAreaID   ( void );
DIP_EXPORT dip_int dip_FeatureConvexPerimeterID( void );
DIP_EXPORT dip_int dip_FeatureConvexityID    ( void );
DIP_EXPORT dip_int dip_FeatureDimensionID    ( void );
DIP_EXPORT dip_int dip_FeatureExcessKurtosisID( void );
DIP_EXPORT dip_int dip_FeatureFeretID        ( void );
DIP_EXPORT dip_int dip_FeatureGinertiaID     ( void );
DIP_EXPORT dip_int dip_FeatureGmuID          ( void );
DIP_EXPORT dip_int dip_FeatureGravityID      ( void );
DIP_EXPORT dip_int dip_FeatureInertiaID      ( void );
DIP_EXPORT dip_int dip_FeatureLongestChaincodeRunID( void );
DIP_EXPORT dip_int dip_FeatureMassID         ( void );
DIP_EXPORT dip_int dip_FeatureMaxValID       ( void );
DIP_EXPORT dip_int dip_FeatureMaximumID      ( void );
DIP_EXPORT dip_int dip_FeatureMeanID         ( void );
DIP_EXPORT dip_int dip_FeatureMinValID       ( void );
DIP_EXPORT dip_int dip_FeatureMinimumID      ( void );
DIP_EXPORT dip_int dip_FeatureMuID           ( void );
DIP_EXPORT dip_int dip_FeatureOrientation2DID( void );
DIP_EXPORT dip_int dip_FeatureP2AID          ( void );
DIP_EXPORT dip_int dip_FeaturePerimeterID    ( void );
DIP_EXPORT dip_int dip_FeatureRadiusID       ( void );
DIP_EXPORT dip_int dip_FeatureShapeID        ( void );
DIP_EXPORT dip_int dip_FeatureSizeID         ( void );
DIP_EXPORT dip_int dip_FeatureSkewnessID     ( void );
DIP_EXPORT dip_int dip_FeatureStdDevID       ( void );
DIP_EXPORT dip_int dip_FeatureSumID          ( void );
DIP_EXPORT dip_int dip_FeatureSurfaceAreaID  ( void );

/* this function should not be exported: its called by dip_Initialise() */
dip_Error dip_MeasurementInitialise ( void );

#ifdef __cplusplus
}
#endif
#endif
