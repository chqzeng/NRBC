/*
 * Filename: dip_imarlut.h
 *
 * (C) Copyright 1995-03                 Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 * Author: Tuan Q. Pham
 *
 */

#ifndef DIP_IMARLUT_H
#define DIP_IMARLUT_H

#include "dip_interpolation.h"

typedef struct
{
   dip_sfloat   *bins;
   dip_sfloat   *vals;        
   dip_int      nbins;
   dipf_Interpolation method; /* see dip_interpolation.h */ 
   dip_sfloat   *spline1;     /* precomputed Bspline coefficients */   
   dip_sfloat   *spline2;     /* for DIP_INTERPOLATION_BSPLINE only */
   dip_sfloat   desiredVal;   /* for dip_InvertedInterpolation1D */
} dip__LUTParams;

dip_Error dip__syncSortBinsVals
( 
   dip_FloatArray bins,          /* vals->size must >= bins->size */
   dip_ImageArray vals, 
   dip_sfloat     *sortedBins,   /* should be pre-allocated */
   dip_ImageArray sortedVals     /* should be pre-allocated */
);
dip_Error dip__syncSortBinsValsFloat
( 
   dip_FloatArray bins,          /* vals->size must >= bins->size */
   dip_FloatArray vals, 
   dip_sfloat     *sortedBins,   /* should be pre-allocated */
   dip_sfloat     *sortedVals    /* should be pre-allocated */
);


/* if bins==NULL -> bins = [0 1 2 ... nbins-1] */
/* supported method: zoh, bilinear (default) or bspline */
DIP_ERROR dip_ImageArrayLUT( dip_Image in,  dip_Image out, 
   dip_FloatArray bins,  dip_ImageArray vals,  dipf_Interpolation method );

DIP_ERROR dip_ArrayLUT( dip_Image in,  dip_Image out,  dip_sfloat *bins, 
   dip_sfloat *vals,  dip_int nbins,  dipf_Interpolation method );

DIP_ERROR dip_ImageArrayInvertedLUT
( 
   dip_FloatArray bins, 
   dip_ImageArray vals,    /* expected to be semi-monotonic */
   dip_float desiredVal, 
   dip_Image out,          /* interpolate bins */
   dipf_Interpolation method  /* default is DIP_INTERPOLATION_LINEAR */
);


/*    NOT SURE IF STILL VALID
it's very important to declare this in .h or prototype it in 
each file that use this function. Otherwise I found that parameters
are passed with wrong values ??? :(
*/

dip_sfloat dip__interp1
(
   dip_sfloat *bins,
   dip_sfloat *vals,
   dip_sfloat *spline1,
   dip_sfloat *spline2,
   dip_int     nbins,
   dip_sfloat  x,
   dipf_Interpolation method
);


#endif
