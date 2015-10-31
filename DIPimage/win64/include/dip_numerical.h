/*
 * filename: dip_numerical.h
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
 * Author: Michael van Ginkel, Geert van Kempen
 *
 */


#ifndef DIP_NUMERICAL_H
#define DIP_NUMERICAL_H
#ifdef __cplusplus
extern "C" {
#endif

typedef enum
{
   DIP_NT_IRCNT_DEFAULT = 0,
   DIP_NT_IRCNT_INVERT  = 1
} dipf_NtReverseRadixCount;

dip_int    dip_GetLog2                ( dip_int );
DIP_ERROR  dip_GetCeilingLog2         ( dip_int, dip_int * );
DIP_ERROR  dip_FactorNumber           ( dip_int, dip_int *, dip_int **,
                                        dip_Resources );
DIP_ERROR  dip_FactorNumberToImage    ( dip_Image, dip_int );
DIP_ERROR  dip_SolveDiophantine       ( dip_int, dip_int, dip_int *,
                                        dip_int *, dip_int * );
void       dip_InvertPermutationTable ( dip_int *, dip_int *, dip_int );
DIP_ERROR  dip_ReverseRadixCount      ( dip_int *, dip_int, dip_int,
                                        dip_int, dip_int *,
                                        dipf_NtReverseRadixCount );

typedef enum
{
   DIP_FIT_EMGS_DEFAULT        = 0,
   DIP_FIT_EMGS_USE_INDICATORS = 1
} dipf_EmFitGaussians;


typedef enum
{
   DIP_NUM_SMPGSF_BACKWARDS_COMPATIBLE = 0,
   DIP_NUM_SMPGSG_USE_RANGE = 4,
   DIP__NUM_SMPGSF_NON_PERIODICAL = 1,
   DIP_NUM_SMPGSF_PERIOD_PI = 2,
   DIP_NUM_SMPGSF_PERIOD_2PI = 3,
   DIP__NUM_SMPGSF_PERIOD_MASK = 3,
   DIP_NUM_SMPGSF_NON_PERIODICAL = DIP__NUM_SMPGSF_NON_PERIODICAL |
                                   DIP_NUM_SMPGSG_USE_RANGE,
   DIP_NUM_SMPGSF_EM = 8,
   DIP_NUM_SMPGSF_USE_INDICATORS = 16,
   DIP_NUM_SMPGSF_NO_SUBPIXEL = 32,
   DIP_NUM_SMPGSF_GAUSSIAN_FIT = 64
} dipf_SimpleGaussFitImage;


DIP_ERROR dip_SimpleGaussFitImage( dip_Image, dip_Image, dip_int, dip_float,
                                   dipf_SimpleGaussFitImage,
                                   dip_float, dip_float );
DIP_ERROR dip_EmFitGaussians( dip_float *, dip_int, dip_int, dip_float *,
                              dip_float *, dip_float *, dip_float *, dip_int,
                              dip_float *, dipf_EmFitGaussians );
DIP_ERROR dip_EmGaussTest( dip_Image, dip_Image, dip_Image, dip_float, dip_float,
                           dip_float, dip_float, dip_float, dip_float,
                           dip_int );

typedef dip_Error (*dip_OneDimensionalSearchFunction)
		( dip_float, dip_float *,  void * );

typedef enum 
{
	DIP_NUMERICAL_SEARCH_MINIMUM = 1,
	DIP_NUMERICAL_SEARCH_ZERO_CROSSING
} dipf_OneDimensionalSearch;

DIP_ERROR dip_OneDimensionalSearch( dip_float *, dip_float, dip_float,
											dip_float, dip_OneDimensionalSearchFunction,
											dip_OneDimensionalSearchFunction,
											void *, dipf_OneDimensionalSearch );

#ifdef __cplusplus
}
#endif
#endif
