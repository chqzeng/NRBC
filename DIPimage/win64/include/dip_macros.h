/*
 * Filename: dip_macros.h
 *
 * (C) Copyright 1995-2002               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : lucas@ph.tn.tudelft.nl
 *
 *
 * Some macro's
 *
 * AUTHOR
 *    Michael van Ginkel
 *    Geert van Kempen
 *
 */

#ifndef DIP_MACROS_H
#define DIP_MACROS_H
#ifdef __cplusplus
extern "C" {
#endif

/* Preprocessor stuff, first the internals */
#define DIP__EXPAND( x )  x

#define DIP_EXPAND( x )                    DIP__EXPAND( x )
#define DIP_MAKE_STRING( x )               #x
#define DIP_MAKE_STRING_EXPANDED( x )      DIP_MAKE_STRING( x )
#define DIP_CONCATENATE( x, y )            x ## y
#define DIP_CONCATENATE_EXPANDED( x, y )   DIP_CONCATENATE( x, y )

#define DIP___TPI_APPEND( name, ext ) name ## _ ## ext
#define DIP__TPI_APPEND( name, ext ) DIP___TPI_APPEND(name,ext)

/* There might be a better place for these...    - MvG */

#define DIP_HACK(func,type) func ## _ ## type
#define DIP_FUNC(func,type) DIP_HACK(func,type)
#define DIP_DEFINE(ret,func,type) ret DIP_HACK(func,type)
#define DIP_DECLARE(ret,func,type) ret DIP_HACK(func,type)
#define DIP_HACK2(func,type1,type2) func ## _ ## type1 ## _ ## type2
#define DIP_FUNC2(func,type1,type2) DIP_HACK2(func,type1,type2)

/* macro for error handling */
#define DIP_NAME(func,type)      #func ## "_" #type
#define DIP_NAME2(func,type,type2)      #func ## "_" #type "_" #type2
#define DIP_FUNC_NAME(func,type) DIP_NAME(func,type)
#define DIP_FUNC_NAME2(func,type,type2) DIP_NAME2(func,type,type2)

/* Don't forget the trailing ; */
#define DIP_SWAP(x,y,z) z = x; x = y; y = z

/* a collection of miscellaneous macros */
#define DIP_USE_INPUT( a, b, c) (a) ? ((b) = (a)) : ((b) = (c))


/* math macros */
#define DIP_ABS(x)    ((x)<(0) ? (-(x)) : (x))
#define DIP_SIGN(x)    ((x)<(0) ? (-1) : (1))
#define DIP_MAX(x,y)  ((x)>(y) ? (x) : (y))
#define DIP_MIN(x,y)  ((x)<(y) ? (x) : (y))
#define DIP_ROUND(a) ((a)>0 ? (dip_int)((a)+0.5) : -(dip_int)(0.5-(a)))

/* macros for handling complex numbers */
#define DIP_REAL(x)      ((x).re)
#define DIP_IMAGINARY(x) ((x).im)
#define DIP_SQUARE_MODULUS(x) (((x).re) * ((x).re) + ((x).im) * ((x).im))
#define DIP_MODULUS(x)  (sqrt(DIP_SQUARE_MODULUS(x)))
#define DIP_PHASE(x)    (dipm_Atan2( ((x).im), ((x).re) ))

/* macros for making reading and writing binary values easier */
#define DIP_BINARY_MASK(mask,plane)   ((mask) = 1 << (plane))
#define DIP_BINARY_READ(in,mask)   (((in) & (mask)) ? 1 : 0)
#define DIP_BINARY_WRITE(out,val,mask) ((out) = ((val) == 0 ? (out) & ~(mask) : (out) | (mask)))

/* Mike's nuisance fixing macro */
#define DIP_KEEP_THE_BLOODY_COMPILER_HAPPY(x) x = 0

/* pointer offset I/O macro's */
#define DIP_PIXEL_GET( ip, pos, stride, value ) \
   { dip_int _pp, _offset = 0; \
     for( _pp = 0; _pp < pos->size; _pp++ ) \
     { _offset += pos->array[_pp] * stride->array[_pp]; } \
     *value = ip[_offset]; }
#define DIP_PIXEL_SET( ip, pos, stride, value ) \
   { dip_int _pp, _offset = 0; \
     for( _pp = 0; _pp < pos->size; _pp++ ) \
     { _offset += pos->array[_pp] * stride->array[_pp]; } \
     ip[_offset] = value; }
#define DIP_PIXEL_ADD( ip, pos, stride, value ) \
   { dip_int _pp, _offset = 0; \
     for( _pp = 0; _pp < pos->size; _pp++ ) \
     { _offset += pos->array[_pp] * stride->array[_pp]; } \
     ip[_offset] += value; }
#define DIP_PIXEL_SUB( ip, pos, stride, value ) \
   { dip_int _pp, _offset = 0; \
     for( _pp = 0; _pp < pos->size; _pp++ ) \
     { _offset += pos->array[_pp] * stride->array[_pp]; } \
     ip[_offset] -= value; }
#define DIP_PIXEL_MUL( ip, pos, stride, value ) \
   { dip_int _pp, _offset = 0; \
     for( _pp = 0; _pp < pos->size; _pp++ ) \
     { _offset += pos->array[_pp] * stride->array[_pp]; } \
     ip[_offset] *= value; }
#define DIP_PIXEL_DIV( ip, pos, stride, value ) \
   { dip_int _pp, _offset = 0; \
     for( _pp = 0; _pp < pos->size; _pp++ ) \
     { _offset += pos->array[_pp] * stride->array[_pp]; } \
     ip[_offset] /= value; }

#define DIP_BINARY_PIXEL_GET( ip, pos, stride, mask, value ) \
   { dip_int _pp, _offset = 0; \
     for( _pp = 0; _pp < pos->size; _pp++ ) \
     { _offset += pos->array[_pp] * stride->array[_pp]; } \
       *value = DIP_BINARY_READ(ip[_offset],mask); }
#define DIP_BINARY_PIXEL_SET( ip, pos, stride, mask, value ) \
   { dip_int _pp, _offset = 0; \
     for( _pp = 0; _pp < pos->size; _pp++ ) \
     { _offset += pos->array[_pp] * stride->array[_pp]; } \
     DIP_BINARY_WRITE( ip[_offset], value, mask); }


/* N-D loop macros */
#define DIP_MD_LOOP( dm, dims, ii, cor )  \
         for ( ii = 1; ii < dm; ii++ )                   \
         {                                               \
            cor->array[ ii ]++;                          \
            if ( cor->array[ ii ] != dims->array[ ii ] ) \
            {                                            \
               break;                                    \
            }                                            \
            cor->array[ ii ] = 0;                        \
         }                                               \
         if ( ii == dm )                                 \
         {                                               \
            break;                                       \
         }

#define DIP_MD_FULL_LOOP( dm, dims, ii, cor )  \
         for ( ii = 0; ii < dm; ii++ )                   \
         {                                               \
            cor->array[ ii ]++;                          \
            if ( cor->array[ ii ] != dims->array[ ii ] ) \
            {                                            \
               break;                                    \
            }                                            \
            cor->array[ ii ] = 0;                        \
         }                                               \
         if ( ii == dm )                                 \
         {                                               \
            break;                                       \
         }

#define DIP_MD_LOOP_PTR( ptr, dm, dims, stride, ii, cor )  \
         for ( ii = 1; ii < dm; ii++ )                 \
         {                                             \
            cor[ ii ]++;                               \
            ptr += stride[ ii ];                       \
            if ( cor[ ii ] != dims[ ii ] )             \
            {                                          \
               break;                                  \
            }                                          \
            cor[ ii ] = 0;                             \
            ptr -= stride[ ii ] * dims[ ii ];          \
         }                                             \
         if ( ii == dm )                               \
         {                                             \
            break;                                     \
         }

#define DIP_MD_LOOP_PTR2( ptr1, ptr2, dm, dims, stride1, stride2, ii, cor )  \
         for ( ii = 1; ii < dm; ii++ )                                   \
         {                                                               \
            cor[ ii ]++;                                                 \
            ptr1 += stride1[ ii ];                                       \
            ptr2 += stride2[ ii ];                                       \
            if ( cor[ ii ] != dims[ ii ] )                               \
            {                                                            \
               break;                                                    \
            }                                                            \
            cor[ ii ] = 0;                                               \
            ptr1 -= stride1[ ii ] * dims[ ii ];                          \
            ptr2 -= stride2[ ii ] * dims[ ii ];                          \
         }                                                               \
         if ( ii == dm )                                                 \
         {                                                               \
            break;                                                       \
         }

#define DIP_ARRAY_FREE_FUNC( name ) \
dip_Error dip_ ## name ## Free                                          \
(                                                                       \
   dip_ ## name *array                                                  \
)                                                                       \
{                                                                       \
   DIP_FN_DECLARE(DIP_MAKE_STRING(dip_ ## name ## Free));               \
                                                                        \
	if( array && *array )                                                \
	{                                                                    \
   	DIPXJ( dip_Resources ## name ## Handler( *array ));               \
   	array = 0;                                                        \
	}                                                                    \
                                                                        \
dip_error:                                                              \
   DIP_FN_EXIT;                                                         \
}

#define DIP_ARRAY_SET_FUNC( name, type ) \
dip_Error dip_ ## name ## Set                                           \
(                                                                       \
   dip_ ## name array,                                                  \
	type value                                                           \
)                                                                       \
{                                                                       \
   DIP_FN_DECLARE(DIP_MAKE_STRING(dip_ ## name ## Set));                \
   dip_int ii;                                                          \
                                                                        \
	for( ii = 0; ii < array->size; ii++ )                                \
	{                                                                    \
   	array->array[ ii ] = value;                                       \
	}                                                                    \
                                                                        \
   DIP_FN_EXIT;                                                         \
}

#define DIP_ARRAY_COMPARE_FUNC( name ) \
dip_Error dip_ ## name ## Compare                                       \
(                                                                       \
   dip_ ## name array1,                                                 \
   dip_ ## name array2,                                                 \
   dip_Boolean *equal                                                   \
)                                                                       \
{                                                                       \
   DIP_FN_DECLARE(DIP_MAKE_STRING(dip_ ## name ## Compare));            \
   dip_int ii;                                                          \
                                                                        \
   *equal = DIP_FALSE;                                                  \
   if( array1->size == array2->size )                                   \
   {                                                                    \
      *equal = DIP_TRUE;                                                \
      for( ii = 0; ii < array1->size; ii++ )                            \
      {                                                                 \
         if( array1->array[ ii ] != array2->array[ ii ] )               \
         {                                                              \
            *equal = DIP_FALSE;                                         \
            break;                                                      \
         }                                                              \
      }                                                                 \
   }                                                                    \
                                                                        \
   DIP_FN_EXIT;                                                         \
}

#ifndef DIP_VOID_PTR_OFFSET
   #define DIP_VOID_PTR_OFFSET( a, b, o, s) (a)=(void *)((char *)(b)+(o)*(s))
#endif

#ifdef __cplusplus
}
#endif
#endif
