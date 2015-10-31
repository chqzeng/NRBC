/*
 * Filename: dip_histogram.h
 *
 * Defines and functions for the histogram datastructure
 *
 * AUTHOR
 *    Geert van Kempen, Unilever Research Vlaardingen, 1999
 */

#ifndef DIP_HISTOGRAM_H
#define DIP_HISTOGRAM_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_distribution.h"

/* Definition of DIPlib Histogram */

#define dip__Histogram dip__Distribution
#define dip_Histogram dip_Distribution

#define DIP_HGST_IS_RAW DIP_DBST_IS_RAW
#define DIP_HGST_IS_VALID DIP_DBST_IS_VALID
#define dip_HistogramState dip_DistributionState

/* Definitions for Multi-Dimensional Histograms */
#define DIP_MDH_LOWER                 0
#define DIP_MDH_UPPER                 1
#define DIP_MDH_LOWER_UPPER_BINS      2
#define DIP_MDH_LOWER_UPPER_BINSIZE   3
#define DIP__MDH_RANGE_MASK           3
#define DIP_MDH_LOWER_PERCENTILE      4
#define DIP_MDH_LOWER_CENTRE          8
#define DIP_MDH_UPPER_PERCENTILE     16
#define DIP_MDH_UPPER_CENTRE         32
#define DIP_MDH_NO_CORRECTION        64

#define dip_HistogramGetState( hist, hs )            dip_DistributionGetState( hist, hs )
#define dip_HistogramValid( hist, b )                dip_DistributionValid( hist, b )
#define dip_HistogramRaw( hist, b )                  dip_DistributionRaw( hist, b )

#define dip_HistogramGetBinSize( hist, fa, res )     dip_DistributionGetBinSize( hist, fa, res )
#define dip_HistogramGetMaximum( hist, fa, res )     dip_DistributionGetMaximum( hist, fa, res )
#define dip_HistogramGetMinimum( hist, fa, res )     dip_DistributionGetMinimum( hist, fa, res )
#define dip_HistogramSetBinSize( hist, fa )          dip_DistributionSetBinSize( hist, fa )
#define dip_HistogramSetMaximum( hist, fa )          dip_DistributionSetMaximum( hist, fa )
#define dip_HistogramSetMinimum( hist, fa )          dip_DistributionSetMinimum( hist, fa )

#define dip_HistogramGetImage( hist, im )            dip_DistributionGetImage( hist, im )
#define dip_HistogramGetDataType( hist, dt )         dip_DistributionGetDataType( hist, dt )
#define dip_HistogramSetDataType( hist, dt )         dip_DistributionSetDataType( hist, dt )
#define dip_HistogramGetSize( hist, i )              dip_DistributionGetSize( hist, i )
#define dip_HistogramGetData( hist, vp )             dip_DistributionGetData( hist, vp )
#define dip_HistogramGetDimensions( hist, ia, res )  dip_DistributionGetDimensions( hist, ia, res )
#define dip_HistogramGetDimensionality( hist, i )    dip_DistributionGetDimensionality( hist, i )
#define dip_HistogramGetID( hist, i )                dip_DistributionGetID( hist, i )
#define dip_HistogramSetName( hist, s )              dip_DistributionSetName( hist, s )
#define dip_HistogramGetName( hist, s, res )         dip_DistributionGetName( hist, s, res )

#define dip_HistogramGetFloat( hist, fs, f )         dip_DistributionGetFloat( hist, fs, f )
#define dip_HistogramSetFloat( hist, fs, f )         dip_DistributionSetFloat( hist, fs, f )
#define dip_HistogramAddFloat( hist, fs, f )         dip_DistributionAddFloat( hist, fs, f )

#define dip_HistogramNew( hist, res )                dip_DistributionNew( hist, res )
#define dip_HistogramFree( hist )                    dip_DistributionFree( hist )
#define dip_HistogramForge( hist )                   dip_DistributionForge( hist )
#define dip_HistogramStrip( hist )                   dip_DistributionStrip( hist )

#define dip_HistogramCopyProperties( hist1, hist2 )    dip_DistributionCopyProperties( hist1, hist2 )
#define dip_HistogramAssimilate( hist1, hist2 )        dip_DistributionAssimilate( hist1, hist2 )
DIP_ERROR dip_HistogramFill             ( dip_Histogram, dip_Image, dip_Image ); /* !!! */
DIP_ERROR dip_ImageHistogramCount       ( dip_Image, dip_Image, dip_Histogram ); /* !!! */

DIP_ERROR dip_ImageToHistogram          ( dip_Image, dip_Histogram, dip_Image,   /* !!! */
                                          dip_float, dip_float, dip_float,
                                          dip_Boolean );
#define dip_HistogramToImage( hist, im )             dip_DistributionToImage( hist, im )

/* Registry functions for the dip_Histogram data structure */
/*
#define dip_HistogramRegistryList( ia, res )  dip_DistributionRegistryList( ia, res )
#define dip_HistogramRegistryGet( i, hist )   dip_DistributionRegistryGet( i, hist )
#define dip_HistogramRegistryFree( i )        dip_DistributionRegistryFree( i )
*/
/*
#define dip_HistogramInitialise()             0
*/

/* Multi-dimensional histogram */
DIP_ERROR dip_MultiDimensionalHistogram(
              dip_Image, dip_BooleanArray, dip_Image, dip_Distribution,
              dip_IntegerArray, dip_FloatArray,
              dip_FloatArray, dip_FloatArray );
DIP_ERROR dip_MultiDimensionalHistogramMap(
              dip_Image, dip_BooleanArray, dip_Image, dip_Image, dip_Image,
              dip_IntegerArray, dip_FloatArray,
              dip_FloatArray, dip_FloatArray );
DIP_ERROR dip_HistogramRangeConvert(
              dip_float *, dip_float *, dip_int *, dip_int,
              dip_float, dip_float, dip_float, dip_float );
DIP_ERROR dip_ArMultiDimensionalHistogram(
              dip_ImageArray, dip_Image, dip_Distribution, dip_IntegerArray,
              dip_FloatArray, dip_FloatArray, dip_FloatArray );
DIP_ERROR dip_ArMultiDimensionalHistogramMap(
              dip_ImageArray, dip_Image, dip_Image, dip_Image,
              dip_IntegerArray, dip_FloatArray, dip_FloatArray,
              dip_FloatArray );

#ifdef __cplusplus
}
#endif
#endif
