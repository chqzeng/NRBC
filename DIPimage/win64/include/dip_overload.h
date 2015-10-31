/*
 * Filename: dip_overload.h
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
 *
 * author: Geert M.P. van Kempen
 *
 */

#ifndef DIP_OVERLOAD_H
#define DIP_OVERLOAD_H

#ifndef DIP_OVL_ALLOW
#define DIP_OVL_ALLOW 0xFFFFF
#endif

#if ( DIP_DTGID_ALL & DIP_OVL_ALLOW & DIP_DTID_BIN8 )
#define DIP_OVL_FUNC_BIN8(func, args ) DIPXJ( DIP_FUNC( func, b8 ) args );
#else
#define DIP_OVL_FUNC_BIN8(func, args ) DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED );
#endif

#if ( DIP_DTGID_ALL & DIP_OVL_ALLOW & DIP_DTID_BIN16 )
#define DIP_OVL_FUNC_BIN16(func, args ) DIPXJ( DIP_FUNC( func, b16 ) args );
#else
#define DIP_OVL_FUNC_BIN16(func, args ) DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED );
#endif

#if ( DIP_DTGID_ALL & DIP_OVL_ALLOW & DIP_DTID_BIN32 )
#define DIP_OVL_FUNC_BIN32(func, args ) DIPXJ( DIP_FUNC( func, b32 ) args );
#else
#define DIP_OVL_FUNC_BIN32(func, args ) DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED );
#endif

#if ( DIP_DTGID_ALL & DIP_OVL_ALLOW & DIP_DTID_UINT8 )
#define DIP_OVL_FUNC_UINT8(func, args ) DIPXJ( DIP_FUNC( func, u8 ) args );
#else
#define DIP_OVL_FUNC_UINT8(func, args ) DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED );
#endif

#if ( DIP_DTGID_ALL & DIP_OVL_ALLOW & DIP_DTID_UINT16 )
#define DIP_OVL_FUNC_UINT16(func, args ) DIPXJ( DIP_FUNC( func, u16 ) args );
#else
#define DIP_OVL_FUNC_UINT16(func, args ) DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED );
#endif

#if ( DIP_DTGID_ALL & DIP_OVL_ALLOW & DIP_DTID_UINT32 )
#define DIP_OVL_FUNC_UINT32(func, args ) DIPXJ( DIP_FUNC( func, u32 ) args );
#else
#define DIP_OVL_FUNC_UINT32(func, args ) DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED );
#endif

#if ( DIP_DTGID_ALL & DIP_OVL_ALLOW & DIP_DTID_SINT8 )
#define DIP_OVL_FUNC_SINT8(func, args ) DIPXJ( DIP_FUNC( func, s8 ) args );
#else
#define DIP_OVL_FUNC_SINT8(func, args ) DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED );
#endif

#if ( DIP_DTGID_ALL & DIP_OVL_ALLOW & DIP_DTID_SINT16 )
#define DIP_OVL_FUNC_SINT16(func, args ) DIPXJ( DIP_FUNC( func, s16 ) args );
#else
#define DIP_OVL_FUNC_SINT16(func, args ) DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED );
#endif

#if ( DIP_DTGID_ALL & DIP_OVL_ALLOW & DIP_DTID_SINT32 )
#define DIP_OVL_FUNC_SINT32(func, args ) DIPXJ( DIP_FUNC( func, s32 ) args );
#else
#define DIP_OVL_FUNC_SINT32(func, args ) DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED );
#endif

#if ( DIP_DTGID_ALL & DIP_OVL_ALLOW & DIP_DTGID_SFLOAT )
#define DIP_OVL_FUNC_SFLOAT(func, args ) DIPXJ( DIP_FUNC( func, sfl ) args );
#else
#define DIP_OVL_FUNC_SFLOAT(func, args ) DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED );
#endif

#if ( DIP_DTGID_ALL & DIP_OVL_ALLOW & DIP_DTGID_DFLOAT )
#define DIP_OVL_FUNC_DFLOAT(func, args ) DIPXJ( DIP_FUNC( func, dfl ) args );
#else
#define DIP_OVL_FUNC_DFLOAT(func, args ) DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED );
#endif

#if ( DIP_DTGID_ALL & DIP_OVL_ALLOW & DIP_DTGID_SCOMPLEX )
#define DIP_OVL_FUNC_SCOMPLEX(func, args ) DIPXJ( DIP_FUNC( func, scx ) args );
#else
#define DIP_OVL_FUNC_SCOMPLEX(func, args ) DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED );
#endif

#if ( DIP_DTGID_ALL & DIP_OVL_ALLOW & DIP_DTGID_DCOMPLEX )
#define DIP_OVL_FUNC_DCOMPLEX(func, args ) DIPXJ( DIP_FUNC( func, dcx ) args );
#else
#define DIP_OVL_FUNC_DCOMPLEX(func, args ) DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED );
#endif



#define DIP_OVERLOAD_FUNC( func, args, type ) switch( type ) \
{ \
case DIP_DT_BIN8: \
   DIP_OVL_FUNC_BIN8(func, args ) \
   break; \
\
case DIP_DT_BIN16: \
   DIP_OVL_FUNC_BIN16(func, args ) \
   break; \
\
case DIP_DT_BIN32: \
   DIP_OVL_FUNC_BIN32(func, args ) \
   break; \
\
case DIP_DT_UINT8: \
   DIP_OVL_FUNC_UINT8(func, args ) \
   break; \
\
case DIP_DT_UINT16: \
   DIP_OVL_FUNC_UINT16(func, args ) \
   break; \
\
case DIP_DT_UINT32: \
   DIP_OVL_FUNC_UINT32(func, args ) \
   break; \
\
case DIP_DT_SINT8: \
   DIP_OVL_FUNC_SINT8(func, args ) \
   break; \
\
case DIP_DT_SINT16: \
   DIP_OVL_FUNC_SINT16(func, args ) \
   break; \
\
case DIP_DT_SINT32: \
   DIP_OVL_FUNC_SINT32(func, args ) \
   break; \
\
case DIP_DT_SFLOAT: \
   DIP_OVL_FUNC_SFLOAT(func, args ) \
   break; \
\
case DIP_DT_DFLOAT: \
   DIP_OVL_FUNC_DFLOAT(func, args ) \
   break; \
\
case DIP_DT_SCOMPLEX: \
   DIP_OVL_FUNC_SCOMPLEX(func, args ) \
   break; \
\
case DIP_DT_DCOMPLEX: \
   DIP_OVL_FUNC_DCOMPLEX(func, args ) \
   break; \
\
default: \
   DIPTS( DIP_E_DATA_TYPE_NOT_SUPPORTED ); \
   break; \
}

#endif
