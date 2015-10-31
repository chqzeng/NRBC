#ifndef DIP_ANALYSIS_H
#define DIP_ANALYSIS_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_distribution.h"
#include "dip_morphology.h"

/* MSF stands for _M_orphological _S_ieve _F_lavour */
typedef enum
{
   DIP_MSF_CLOSING = 0,
   DIP_MSF_OPENING,
   DIP_MSF_MFILTER,
   DIP_MSF_NFILTER
} dip_MorphologicalSieveFlavour;

DIP_ERROR dip_KMeansClustering   ( dip_Image, dip_Image, dip_int );

DIP_ERROR dip_IsodataThreshold   ( dip_Image, dip_Image, dip_Image,
                                   dip_int, dip_FloatArray );

typedef struct
{
   char *separator;
   dip_Boolean info;
   dip_Boolean labels;
   dip_Boolean results;
   dip_Boolean labelAlign;
} dip_WriteFormat;

typedef struct
{
   dip_int probes;
   dip_Boolean raw;
   dip_FloatArray *correlation;
   dip_FloatArray *counts;
   dip_FloatArray normalisation;
   dip_IntegerArray phases;
   dip_Resources resources;
} dip__CorrelationFunction, *dip_CorrelationFunction;

typedef enum
{
   DIP_CORRELATION_ESTIMATOR_RANDOM = 0,
   DIP_CORRELATION_ESTIMATOR_DEFAULT = DIP_CORRELATION_ESTIMATOR_RANDOM,
   DIP_CORRELATION_ESTIMATOR_GRID   = 1
} dipf_CorrelationEstimator;

typedef enum
{
   DIP_CORRELATION_NORMALISATION_NONE = 0,
   DIP_CORRELATION_NORMALISATION_VOLUME_FRACTION = 1,
   DIP_CORRELATION_NORMALISATION_VOLUME_FRACTION_SQUARE = 2
} dipf_CorrelationNormalisation;

DIP_ERROR dip_PairCorrelation ( dip_Image, dip_Image, dip_Distribution,
                                dip_int, dip_int, dipf_CorrelationEstimator,
                                dip_Boolean, dipf_CorrelationNormalisation );
DIP_ERROR dip_ProbabilisticPairCorrelation ( dip_ImageArray, dip_Image,
                                dip_Distribution, dip_int, dip_int,
                                dipf_CorrelationEstimator, dip_Boolean,
                                 dipf_CorrelationNormalisation );
DIP_ERROR dip_ChordLength     ( dip_Image, dip_Image, dip_Distribution,
                                dip_int, dip_int, dipf_CorrelationEstimator );
DIP_ERROR dip_RadialDistribution( dip_Image, dip_Image, dip_Distribution, dip_int );
DIP_ERROR dip_CorrelationWrite( dip_DistributionArray, dip_PhysicalDimensions,
                                FILE *, dip_WriteFormat );
DIP_ERROR dip_StructureAnalysis ( dip_Image, dip_Distribution,
                              dip_FloatArray, dip_float, dip_BoundaryArray );

DIP_EXPORT dip_int dip_PairCorrelationID( void );
DIP_EXPORT dip_int dip_ProbabilisticPairCorrelationID( void );
DIP_EXPORT dip_int dip_ChordLengthID( void );
DIP_EXPORT dip_int dip_RadialDistributionID( void );
DIP_EXPORT dip_int dip_StructureAnalysisID ( void );


typedef enum
{
	DIP_SEM_DEFAULT = 0,   /* == DIP_SEM_PARABOLIC_SEPARABLE */
	DIP_SEM_LINEAR = 1,
   DIP_SEM_PARABOLIC_SEPARABLE = 2,
   DIP_SEM_GAUSSIAN_SEPARABLE = 3,
   DIP_SEM_BSPLINE = 4,
	DIP_SEM_PARABOLIC = 5,
	DIP_SEM_GAUSSIAN = 6
} dipf_SubpixelExtremumMethod;

typedef enum
{
	DIP_SEP_MAXIMUM = 0,
	DIP_SEP_MINIMUM = 1
} dipf_SubpixelExtremumPolarity;

DIP_ERROR dip_SubpixelMaxima   ( dip_Image, dip_Image, dip_Image, dip_Image,
                                 dipf_SubpixelExtremumMethod );
DIP_ERROR dip_SubpixelMinima   ( dip_Image, dip_Image, dip_Image, dip_Image,
                                 dipf_SubpixelExtremumMethod );
DIP_ERROR dip_SubpixelLocation ( dip_Image, dip_IntegerArray, dip_FloatArray,
                                 dip_float*, dipf_SubpixelExtremumMethod,
                                 dipf_SubpixelExtremumPolarity );

/* Not exported ( == private functions ) */
dip_Boolean dip__subpixmax_quadratic_3x3   ( dip_float*, dip_float*, dip_float*, dip_float* );
dip_Boolean dip__subpixmax_quadratic_3x3x3 ( dip_float*, dip_float*, dip_float*, dip_float*, dip_float* );

#ifdef __cplusplus
}
#endif
#endif
