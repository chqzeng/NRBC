/*
 * Filename: dip_bilateral.h
 *
 * authors
 *    Tuan Pham December 2003
 *
 */
#ifndef TP_BILATERAL
#define TP_BILATERAL

#include "dip_interpolation.h"

#define DIP_BLF_LUSIZE 512
#define DIP_BLF_LUSIGMA 51.1
#define DIP_BLF_TONALTRUNC 10.0


/***************************************************************
 *
 * data structures
 *
 ***************************************************************/

typedef struct
{
   dip_int     dim;
   dip_int    *dims;
   dip_int    *stride;
   dip_sfloat *data;       /* DIP_SFLOAT is used throughout the file */
} dip__ImageParams, *dip_ImageParams;

typedef struct
{
   dip_int     size;
   dip_sfloat  sigma;      /* of this Gaussian LUT */
   dip_sfloat  trunc;
   dip_sfloat  actualSigma;/* of the actual filter, which uses this LUT */
   dip_sfloat *data;       /* data[size-1] = 0 for truncation */
} dip__GaussLUT, *dip_GaussLUT;

typedef struct
{
   dip_int     nimg;
   dip_ImageParams *im;

   dip_int      npix;   /* max size for those arrays below */
   dip_sfloat **ppos;   /* incl. x, y, z,.. length = dim */
   dip_sfloat  *signal;
   dip_sfloat  *weight;

   dipf_Interpolation method;    /* bilinear of bspline */

   /* spatial & tonal LUT: different truncation & resolution */
   dip_GaussLUT slut; /* truncation often = 2 or 3 -> can afford hi-res */
   dip_GaussLUT tlut; /* need large truncation (=10), lo-res is OK */

} dip__ArcFilterParams;

typedef struct
{
   dip_FloatArray sFilter; /* fixed spatial filter (small -> don't need LUT) */
   dip_float      spatialSigma;

   dip_GaussLUT   tlut;       /* look-up kernel for tonal weights */

   dip_sfloat    *pest;       /* pointer to est data (initial estimate for bilateral filtering) */
   dip_int       *eststride;  /* to be allocated & assigned */
   dip_int        dim;

   dip_sfloat    *estline;    /* array to store est along this dimension (tonalCenter) */
} dip_SeparableBilateralParam;

typedef struct
{
   dip_int   dim;             /* dimension of the spatialSigma array */
   dip_float *spatialSigma;
   dip_float tonalSigma;

   dip_int   npix;            /* # pixels in the neighborhood */
   dip_sfloat *spatialFilter; /* size = npix */
   dip_GaussLUT   tlut;       /* look-up kernel for tonal weights */

} dip_BilateralFilterParams;

typedef struct
{
   dip_int   dim;             /* dimension of the spatialSigma array */
   dip_float *spatialSigma;
   dip_float tonalSigma;

   dip_int   npix;            /* # pixels in the neighborhood */
   dip_sfloat *spatialFilter; /* size = npix */
   dip_sfloat ** basisFunctions; /* array of kernels */
   dip_sfloat * estimates;      /* array of images */
   dip_GaussLUT   tlut;       /* look-up kernel for tonal weights */

} dip_BilateralFilterNCParams;


/***************************************************************
 *
 * function exports
 *
 ***************************************************************/

/* Resampling in 2D: linear or b-spline interpolation. */
DIP_ERROR dip__ResampleAt( dip_ImageParams, dip_sfloat **, dip_int,
      dipf_Interpolation, dip_sfloat * );

/* Resampling in 3D: linear interpolation. */
DIP_ERROR dip__ResampleAt3D( dip_ImageParams, dip_sfloat **, dip_int,
      dip_sfloat * );

/* 0-th order only */
DIP_ERROR dip_GaussLUTNew( dip_GaussLUT *lut,  dip_sfloat sigma,
      dip_sfloat truncation,  dip_sfloat actualSigma,  dip_Resources  res);
DIP_ERROR dip_TukeyLUTNew( dip_GaussLUT *lut,  dip_sfloat sigma,
      dip_sfloat actualSigma,  dip_Resources  res);

/* 1D line-like oriented [& curved] filter */
DIP_ERROR dip_ArcFilter( dip_ImageArray in,  dip_ImageArray imParams,
	   dip_ImageArray out,  dip_float tonalSigma,  dip_float truncation,
      dipf_Interpolation method );

/* xy-separable bilateral filter */
DIP_ERROR dip_Bilateral( dip_Image in,  dip_Image est,  dip_Image out,
      dip_BoundaryArray bc,  dip_BooleanArray  process,  dip_FloatArray sigmas,
      dip_float tonalSigma,  dip_float truncation );

/* brute-force bilateral filter */
DIP_ERROR dip_BilateralFilter( dip_Image in,  dip_Image est,  dip_Image out,
   dip_Image cnt,  dip_FloatArray spatialSigma,  dip_float tonalSigma,
   dip_float truncation );
/* filter in image according to tonal data of another (base) image */
DIP_ERROR dip_BilateralFilter2( dip_Image in,  dip_Image est,  dip_Image base,  dip_Image out,
   dip_Image cnt,  dip_FloatArray spatialSigma,  dip_float tonalSigma,
   dip_float truncation );

/* quantized bilateral filter or piecewise-linear bilateral filter */
DIP_ERROR dip_QuantizedBilateralFilter( dip_Image in,  dip_Image est,
	dip_Image out,  dip_FloatArray spatialSigma, dip_float tonalSigma,
   dip_FloatArray tonalBins,  dip_float truncation );


/* texture inpainting by neighborhood search of similar blocks */
/*
DIP_ERROR dip_TextureInpainting( dip_Image in,  dip_Image mask,
   dip_Image out,  dip_IntegerArray matchSize,  dip_IntegerArray searchSize);
*/


/* brute-force bilateral normalized convolution filter */
DIP_ERROR dip_BilateralFilterNC( dip_Image in,  dip_Image certainty, dip_ImageArray basis, dip_Image estimate,  dip_Image out,
   dip_Image cnt,  dip_FloatArray spatialSigma,  dip_float tonalSigma,
   dip_float truncation );


#endif   /* TP_BILATERAL */

