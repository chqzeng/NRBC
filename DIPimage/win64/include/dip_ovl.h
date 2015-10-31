/*
 * Filename: dip_ovl.h
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
 * Provide a crude form of overloading
 *
 * AUTHOR
 *    Michael van Ginkel
 *
 * NOTE
 *    This file was inspired by Geert's dip_overload.h, but I think this way
 *    is nicer. This is a subjective feeling however, so use whichever method
 *    you prefer: the end result is the same - MvG
 */


#ifdef DIP_OVL_TYPES
   #define _DIP_OVL_TYPES (DIP_OVL_TYPES)
#else
   #ifdef DIP_OVL_FORCE
      #ifdef DIP_OVL_ALLOW
         #define _DIP_OVL_TYPES (( DIP_DTGID_ALL & (DIP_OVL_ALLOW) ) | \
                                  (DIP_OVL_FORCE) )
      #else
         #define _DIP_OVL_TYPES ( DIP_DTGID_ALL | (DIP_OVL_FORCE) )
      #endif
   #else
      #ifdef DIP_OVL_ALLOW
         #define _DIP_OVL_TYPES ( DIP_DTGID_ALL & (DIP_OVL_ALLOW) )
      #else
         #define _DIP_OVL_TYPES DIP_DTGID_ALL
      #endif
   #endif
#endif

#ifndef DIP_OVL_ARGS
#define DIP_OVL_ARGS
#endif

#ifndef DIP_OVL_BINARY_ARGS
#define DIP_OVL_BINARY_ARGS DIP_OVL_ARGS
#endif

#ifndef DIP_OVL_DATA_TYPE
#define DIP_OVL_DATA_TYPE ovlDataType
#endif

#if ( !defined( DIP_OVL_BINARY_ASSIGN ) && defined( DIP_OVL_ASSIGN ))
#define DIP_OVL_BINARY_ASSIGN DIP_OVL_ASSIGN
#endif

#ifdef DIP_OVL_ASSIGN
#define _DIP_OVL_CALL(x,y)  case x: DIP_OVL_ASSIGN DIP_FUNC( DIP_OVL_FUNC, y ) DIP_OVL_ARGS; break;
#else
#define _DIP_OVL_CALL(x,y)  case x: DIPXJ( DIP_FUNC( DIP_OVL_FUNC, y ) DIP_OVL_ARGS ) break;
#endif

#ifdef DIP_OVL_BINARY_ASSIGN
#define _DIP_OVL_BINARY_CALL(x,y)  case x: DIP_OVL_BINARY_ASSIGN DIP_FUNC( DIP_OVL_FUNC, y ) DIP_OVL_BINARY_ARGS; break;
#else
#define _DIP_OVL_BINARY_CALL(x,y)  case x: DIPXJ( DIP_FUNC( DIP_OVL_FUNC, y ) DIP_OVL_BINARY_ARGS ) break;
#endif


   switch( DIP_OVL_DATA_TYPE )
   {
#if ( _DIP_OVL_TYPES & DIP_DTID_UINT8 )
         _DIP_OVL_CALL( DIP_DT_UINT8, DIP_UINT8_EXTENSION )
#endif
#if ( _DIP_OVL_TYPES & DIP_DTID_UINT16 )
         _DIP_OVL_CALL( DIP_DT_UINT16, DIP_UINT16_EXTENSION )
#endif
#if ( _DIP_OVL_TYPES & DIP_DTID_UINT32 )
         _DIP_OVL_CALL( DIP_DT_UINT32, DIP_UINT32_EXTENSION )
#endif



#if ( _DIP_OVL_TYPES & DIP_DTID_SINT8 )
         _DIP_OVL_CALL( DIP_DT_SINT8, DIP_SINT8_EXTENSION )
#endif
#if ( _DIP_OVL_TYPES & DIP_DTID_SINT16 )
         _DIP_OVL_CALL( DIP_DT_SINT16, DIP_SINT16_EXTENSION )
#endif
#if ( _DIP_OVL_TYPES & DIP_DTID_SINT32 )
         _DIP_OVL_CALL( DIP_DT_SINT32, DIP_SINT32_EXTENSION )
#endif
#ifndef DIP_DTI_INT_IS_INT32
   #if ( _DIP_OVL_TYPES & DIP_DTID_SINT )
            _DIP_OVL_CALL( DIP_DT_SINT, DIP_DT_SINT_EXTENSION )
   #endif
#endif



#if ( _DIP_OVL_TYPES & DIP_DTID_SFLOAT )
         _DIP_OVL_CALL( DIP_DT_SFLOAT, DIP_SFLOAT_EXTENSION )
#endif
#if ( _DIP_OVL_TYPES & DIP_DTID_DFLOAT )
         _DIP_OVL_CALL( DIP_DT_DFLOAT, DIP_DFLOAT_EXTENSION )
#endif




#if ( _DIP_OVL_TYPES & DIP_DTID_SCOMPLEX )
         _DIP_OVL_CALL( DIP_DT_SCOMPLEX, DIP_SCOMPLEX_EXTENSION )
#endif
#if ( _DIP_OVL_TYPES & DIP_DTID_DCOMPLEX )
         _DIP_OVL_CALL( DIP_DT_DCOMPLEX, DIP_DCOMPLEX_EXTENSION )
#endif




#if ( _DIP_OVL_TYPES & DIP_DTID_BIN8 )
         _DIP_OVL_BINARY_CALL( DIP_DT_BIN8, DIP_BIN8_EXTENSION )
#endif
#if ( _DIP_OVL_TYPES & DIP_DTID_BIN16 )
         _DIP_OVL_BINARY_CALL( DIP_DT_BIN16, DIP_BIN16_EXTENSION )
#endif
#if ( _DIP_OVL_TYPES & DIP_DTID_BIN32 )
         _DIP_OVL_BINARY_CALL( DIP_DT_BIN32, DIP_BIN32_EXTENSION )
#endif




      default:
         DIPSJ( DIP_E_DATA_TYPE_NOT_SUPPORTED );
         break;
   }


/* Make sure we can use this file a second time ! */

#undef DIP_OVL_FORCE
#undef DIP_OVL_ALLOW
#undef DIP_OVL_FUNC
#undef DIP_OVL_ARGS
#undef DIP_OVL_DATA_TYPE
#undef DIP_OVL_ASSIGN
#undef DIP_OVL_NONE
#undef DIP_OVL_BINARY_ARGS
#undef DIP_OVL_BINARY_ASSIGN
#undef _DIP_OVL_TYPES
#undef _DIP_OVL_CALL
#undef _DIP_OVL_BINARY_CALL

