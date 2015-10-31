/*
 * Filename: dip_manipulation.h
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
 * Author: M van Ginkel
 *
 */

#ifndef DIP_TPI_INC

   #ifndef DIP_MANIPULATION_H
   #define DIP_MANIPULATION_H
   #ifdef __cplusplus
   extern "C" {
   #endif

   #define DIP_TPI_INC_FILE "dip_manipulation.h"
   #define DIP_TPI_INC_ALLOW DIP_DTGID_NONBINARY
   #define DIP_TPI_INC_FORCE DIP_DTID_SINT
   #include "dip_tpi_inc.h"


   DIP_ERROR dip_GetSlice( dip_Image, dip_Image, dip_IntegerArray,
		dip_int, dip_int );
   DIP_ERROR dip_PutSlice( dip_Image, dip_Image, dip_IntegerArray, dip_int, dip_int );
   DIP_ERROR dip_PutSubSpace( dip_Image, dip_Image, dip_IntegerArray,
		dip_IntegerArray );
   DIP_ERROR dip_GetLine( dip_Image, dip_Image, dip_IntegerArray, dip_int );
   DIP_ERROR dip_PutLine( dip_Image, dip_Image, dip_IntegerArray, dip_int );
   DIP_ERROR dip_Set( dip_Image, dip_Image, dip_IntegerArray, dip_Boolean );
   DIP_ERROR dip_SetInteger( dip_Image, dip_int, dip_IntegerArray,
		dip_Boolean );
   DIP_ERROR dip_SetFloat  ( dip_Image, dip_float,
		dip_IntegerArray, dip_Boolean );
   DIP_ERROR dip_SetComplex( dip_Image, dip_complex,
		dip_IntegerArray, dip_Boolean );
   DIP_ERROR dip_Get( dip_Image, dip_Image, dip_IntegerArray, dip_Boolean );
   DIP_ERROR dip_GetInteger( dip_Image, dip_int *, dip_IntegerArray );
   DIP_ERROR dip_GetFloat  ( dip_Image, dip_float *, dip_IntegerArray );
   DIP_ERROR dip_GetComplex( dip_Image, dip_complex *, dip_IntegerArray );

   DIP_ERROR dip_ExtendRegion( dip_Image, dip_IntegerArray, dip_IntegerArray,
                            dip_BoundaryArray, dip_IntegerArray, dip_Image * );

   DIP_ERROR dip_Shift( dip_Image, dip_Image, dip_FloatArray, dip_Boolean );
   DIP_ERROR dip_Map ( dip_Image, dip_Image, dip_IntegerArray,
			dip_BooleanArray );
   DIP_ERROR dip_MapView ( dip_Image, dip_Image *, dip_IntegerArray,
			dip_BooleanArray, dip_Resources );
   DIP_ERROR dip_Mirror ( dip_Image, dip_Image, dip_BooleanArray );
   DIP_ERROR dip_MirrorView ( dip_Image, dip_Image *, dip_BooleanArray,
                              dip_Resources );
   DIP_ERROR dip_Crop ( dip_Image, dip_Image, dip_IntegerArray,
   			dip_IntegerArray );
   DIP_ERROR dip_CropToBetterFourierSize( dip_Image, dip_Image,
                                          dip_BooleanArray );
   DIP_ERROR dip_Wrap ( dip_Image, dip_Image, dip_IntegerArray );
	DIP_ERROR dip_ResamplingFT ( dip_Image, dip_Image, dip_FloatArray );

   DIP_ERROR dip_ChangeByteOrder( dip_Image, dip_Image, dip_IntegerArray );
   /* Temporary backwards compatibility hack */
   DIP_ERROR dip_SetPixelByIndex( dip_Image, dip_int, dip_float );
   DIP_ERROR dip_SetPixelComplexByIndex( dip_Image, dip_int, dip_complex );
   DIP_ERROR dip_GetPixelByIndex( dip_Image, dip_int, dip_float * );

   #ifdef __cplusplus
   }
   #endif
   #endif

#else

   DIP_TPI_INC_DECLARE(dip_WrapData)( void *, void *, dip_int, dip_int );
   #if DIP_TPI_INC_EXTENSION != DIP_DT_INT_NON_SINT32_EXTENSION 
   DIP_TPI_INC_DECLARE(dip_Set)( dip_Image, DIP_TPI_INC, dip_IntegerArray,
		dip_Boolean );
   DIP_TPI_INC_DECLARE(dip_Get)( dip_Image, DIP_TPI_INC *, dip_IntegerArray );
   DIP_TPI_INC_DECLARE(dip_ExtendRegion)( void *, dip_int, dip_IntegerArray,
      dip_IntegerArray, dip_IntegerArray, dip_IntegerArray, dip_IntegerArray,
      dip_BoundaryArray, dip_IntegerArray, void *,
      dip_IntegerArray, dip_IntegerArray );
   #endif
#endif
