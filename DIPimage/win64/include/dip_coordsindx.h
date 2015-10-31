/*
 * Filename: dip_coordsindx.h
 *
 * (C) Copyright 1995-2008               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : lucas@ph.tn.tudelft.nl
 *
 * Conversion of coordinates to linear index and back
 *
 */


#ifndef DIP_COORDSINDX_H
#define DIP_COORDSINDX_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_sort.h"

/* To convert an index to a pixel into coordinates for that pixel, we need to
   know not only the strides, but also the image size. This is because singleton
   dimensions (dimensions where the image has size 1) need to be treated differently.
   These dimensions can have any value for the stride, but we don't want to use
   these in our calculations.

   In this bit of code, we sort all non-singleton dimensions by the value of their
   strides, large values first. Later, when computing the coordinates, we use each
   of these strides in turn to compute the coordinate along the corresponding
   dimension. The singleton dimensions are computed at the end, when "residue"
   should be 0, resulting in those coordinates being 0 as well.

   To use these macros, put DIP_INDEX_TO_COORDINATE_DECL in your list of variable
   declarations. This one declares a variable that holds the dimension indices.
   Once you know the size and strides of your image, call DIP_INDEX_TO_COORDINATE_INIT.
   This one will allocate the variable declared above, and initialise it as described
   above. DIP_INDEX_TO_COORDINATE then uses this variable to compute the coordinates.

   By using these macros instead of dip_IndexToCoordinate(), you avoid creating
   the sorted list of dimensions every time you need to compute coordinates.

   dip_IndexToCoordinate() does not handle singleton dimensions correctly.
   dip_IndexToCoordinateWithSingletons() implements the calculations correctly, but
   has an additional input argument (the image size).

   DIP_COORDINATE_TO_INDEX does the same as dip_CoordinateToIndex(), does not require
   any initialisation, and therefore is not much more efficient than the function
   call, except avoiding the function call.
*/

#define DIP_INDEX_TO_COORDINATE_DECL( ix ) \
   dip_sint32 *ix

#define DIP_INDEX_TO_COORDINATE_INIT( imsize, stride, ix, rg ) { \
   dip_int ii, nelem; void *vp; /* local variables */ \
   DIPXJ( dip_MemoryNew( &vp, stride->size * sizeof( dip_sint32 ), rg )); \
   ix = (dip_sint32 *) vp; \
   nelem = 0; \
   for( ii = 0; ii < stride->size; ii++ ) { \
      if( imsize->array[ ii ] != 1 ) { \
         ix[ nelem ] = ii; \
         nelem++; \
   }} \
   /* Code copied from dip_InsertionSortIndices( stride->array, ix, nelem ), but sorting in reverse order. */ \
   for( ii = 1; ii < nelem; ii++ ) { \
      dip_sint32 keepIndex = ix[ ii ]; \
      dip_int key = stride->array[ keepIndex ]; \
      dip_int jj  = ii - 1; \
      if( stride->array[ ix[ jj ]] < key ) { \
         while(( jj >= 0 ) && ( stride->array[ ix[ jj ]] < key )) { \
            ix[ jj + 1 ] = ix[ jj ]; \
            jj--; \
         } \
         ix[ jj + 1 ] = keepIndex; \
   }} \
   for( ii = 0; ii < stride->size; ii++ ) { \
      if( imsize->array[ ii ] == 1 ) { \
         ix[ nelem ] = ii; \
         nelem++; \
   }}}

#define DIP_INDEX_TO_COORDINATE_INIT_NOSIZE( stride, ix, rg ) { \
   dip_int ii; void *vp; /* local variables */ \
   DIPXJ( dip_MemoryNew( &vp, stride->size * sizeof( dip_sint32 ), rg )); \
   ix = (dip_sint32 *) vp; \
   for( ii = 0; ii < stride->size; ii++ ) { \
      ix[ ii ] = ii; \
   } \
   /* Code copied from dip_InsertionSortIndices( stride->array, ix, stride->size ), but sorting in reverse order. */ \
   for( ii = 1; ii < stride->size; ii++ ) { \
      dip_sint32 keepIndex = ix[ ii ]; \
      dip_int key = stride->array[ keepIndex ]; \
      dip_int jj  = ii - 1; \
      if( stride->array[ ix[ jj ]] < key ) { \
         while(( jj >= 0 ) && ( stride->array[ ix[ jj ]] < key )) { \
            ix[ jj + 1 ] = ix[ jj ]; \
            jj--; \
         } \
         ix[ jj + 1 ] = keepIndex; \
   }}}

#define DIP_INDEX_TO_COORDINATE( index, coordinates, stride, ix ) { \
   dip_int ii, jj, residue = index; /* local variables */ \
   for( ii = 0; ii < stride->size; ii++ ) { \
      jj = ix[ ii ]; \
      coordinates->array[ jj ] = residue / stride->array[ jj ]; \
      residue = residue - stride->array[ jj ] * coordinates->array[ jj ]; \
   }}

#define DIP_COORDINATE_TO_INDEX(coordinates, index, stride) { \
   dip_int ii; /* local variable */ \
   index = 0; \
   for ( ii = 0; ii < stride->size; ii++ ) { \
      index += coordinates->array[ ii ] * stride->array[ ii ]; \
   }}

DIP_ERROR dip_IndexToCoordinateWithSingletons( dip_int, dip_IntegerArray, dip_IntegerArray, dip_IntegerArray );
DIP_ERROR dip_IndexToCoordinate( dip_int, dip_IntegerArray, dip_IntegerArray );
DIP_ERROR dip_CoordinateToIndex( dip_IntegerArray, dip_int *, dip_IntegerArray );

#ifdef __cplusplus
}
#endif
#endif
