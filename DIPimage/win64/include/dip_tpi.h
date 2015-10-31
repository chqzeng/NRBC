/*
 * Filename: dip_tpi.h
 *
 * (C) Copyright 1995-1999               Pattern Recognition Group
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
 * author:  Michael van Ginkel
 *
 * history:
 *    19 August 1996     - MvG - created
 */

/* define some short macros for frequently used function types */
#define DIP_TPI_FUNC(func)        DIP_FUNC(func,DIP_TPI_EXTENSION)
#define DIP_TPI_DEFINE(func)      DIP_DEFINE(dip_Error,func,DIP_TPI_EXTENSION)
#define DIP_TPI_DECLARE(func)     DIP_DECLARE(dip_Error,func,DIP_TPI_EXTENSION)
/* the HP-UX aCC compiler won't swallow this
#define DIP_TPI_NAME(func)       DIP_FUNC_NAME(func, DIP_TPI_EXTENSION)
but does swallow this: */
#define DIP_TPI_ROUNDOFF(x)  ((x)<(0) ? (x - DIP_TPI_ROUNDOFF_BIAS) : (x + DIP_TPI_ROUNDOFF_BIAS))
#define DIP_TPI_APPEND( name ) DIP__TPI_APPEND(name,DIP_TPI_EXTENSION)
#define DIP_TPI_NAME(func)       DIP_MAKE_STRING_EXPANDED(DIP_TPI_APPEND(func))


#ifdef DIP_TPI_TYPES
   #define _DIP_TPI_TYPES (DIP_TPI_TYPES)
#else
   #ifdef DIP_TPI_FORCE
      #ifdef DIP_TPI_ALLOW
         #define _DIP_TPI_TYPES (( DIP_DTGID_ALL & (DIP_TPI_ALLOW) ) | \
                                  (DIP_TPI_FORCE) )
      #else
         #define _DIP_TPI_TYPES ( DIP_DTGID_ALL | (DIP_TPI_FORCE) )
      #endif
   #else
      #ifdef DIP_TPI_ALLOW
         #define _DIP_TPI_TYPES ( DIP_DTGID_ALL & (DIP_TPI_ALLOW) )
      #else
         #define _DIP_TPI_TYPES DIP_DTGID_ALL
      #endif
   #endif
#endif

#define DIP_TPI_READ( in, mask ) (in)
#define DIP_TPI_WRITE( out, val, mask ) (out) = (val)

#if ( _DIP_TPI_TYPES & DIP_DTID_UINT8 )
   #define DIP_TPI dip_uint8
   #define DIP_TPI_EXTENSION DIP_UINT8_EXTENSION
   #define DIP_TPI_IDENTIFIER DIP_DTID_UINT8
   #define DIP_TPI_DATA_TYPE DIP_DT_UINT8
   
   #define DIP_TPI_IS_REAL
   #define DIP_TPI_IS_UNSIGNED
   #define DIP_TPI_IS_INTEGER
   #define DIP_TPI_MAX_PRECISION    dip_uint32
   #define DIP_TPI_MAX_IDENTIFIER   DIP_DTID_UINT32
   #define DIP_TPI_MAX_EXTENSION    DIP_UINT32_EXTENSION
   #define DIP_TPI_MAXVALUE         DIP_MAX_UINT8
   #define DIP_TPI_MINVALUE         DIP_MIN_UINT8
   #define DIP_TPI_ROUNDOFF_BIAS    (0.5)
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_MAX_IDENTIFIER
   #undef DIP_TPI_MAX_EXTENSION
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_REAL
   #undef DIP_TPI_IS_INTEGER
   #undef DIP_TPI_IS_UNSIGNED
   #undef DIP_TPI_MAX_PRECISION
   #undef DIP_TPI_MAXVALUE
   #undef DIP_TPI_MINVALUE
   #undef DIP_TPI_ROUNDOFF_BIAS
#endif


#if ( _DIP_TPI_TYPES & DIP_DTID_UINT16 )
   #define DIP_TPI dip_uint16
   #define DIP_TPI_EXTENSION DIP_UINT16_EXTENSION
   #define DIP_TPI_IDENTIFIER DIP_DTID_UINT16
   #define DIP_TPI_DATA_TYPE DIP_DT_UINT16
   
   #define DIP_TPI_IS_REAL
   #define DIP_TPI_IS_UNSIGNED
   #define DIP_TPI_IS_INTEGER
   #define DIP_TPI_MAX_PRECISION    dip_uint32
   #define DIP_TPI_MAX_IDENTIFIER   DIP_DTID_UINT32
   #define DIP_TPI_MAX_EXTENSION    DIP_UINT16_EXTENSION
   #define DIP_TPI_MAXVALUE         DIP_MAX_UINT16
   #define DIP_TPI_MINVALUE         DIP_MIN_UINT16
   #define DIP_TPI_ROUNDOFF_BIAS    (0.5)
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_MAX_IDENTIFIER
   #undef DIP_TPI_MAX_EXTENSION
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_REAL
   #undef DIP_TPI_IS_INTEGER
   #undef DIP_TPI_IS_UNSIGNED
   #undef DIP_TPI_MAX_PRECISION
   #undef DIP_TPI_MAXVALUE
   #undef DIP_TPI_MINVALUE
   #undef DIP_TPI_ROUNDOFF_BIAS
#endif


#if ( _DIP_TPI_TYPES & DIP_DTID_UINT32 )
   #define DIP_TPI dip_uint32
   #define DIP_TPI_EXTENSION DIP_UINT32_EXTENSION
   #define DIP_TPI_IDENTIFIER DIP_DTID_UINT32
   #define DIP_TPI_DATA_TYPE DIP_DT_UINT32
   
   #define DIP_TPI_IS_REAL
   #define DIP_TPI_IS_UNSIGNED
   #define DIP_TPI_IS_INTEGER
   #define DIP_TPI_MAX_PRECISION    dip_uint32
   #define DIP_TPI_MAX_IDENTIFIER   DIP_DTID_UINT32
   #define DIP_TPI_MAX_EXTENSION    DIP_UINT32_EXTENSION
   #define DIP_TPI_MAXVALUE         DIP_MAX_UINT32
   #define DIP_TPI_MINVALUE         DIP_MIN_UINT32
   #define DIP_TPI_ROUNDOFF_BIAS    (0.5)
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_MAX_IDENTIFIER
   #undef DIP_TPI_MAX_EXTENSION
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_REAL
   #undef DIP_TPI_IS_INTEGER
   #undef DIP_TPI_IS_UNSIGNED
   #undef DIP_TPI_MAX_PRECISION
   #undef DIP_TPI_MAXVALUE
   #undef DIP_TPI_MINVALUE
   #undef DIP_TPI_ROUNDOFF_BIAS
#endif


#if ( _DIP_TPI_TYPES & DIP_DTID_SINT8 )
   #define DIP_TPI dip_sint8
   #define DIP_TPI_EXTENSION DIP_SINT8_EXTENSION
   #define DIP_TPI_IDENTIFIER DIP_DTID_SINT8
   #define DIP_TPI_DATA_TYPE DIP_DT_SINT8
   
   #define DIP_TPI_IS_REAL
   #define DIP_TPI_IS_INTEGER
   #define DIP_TPI_MAX_PRECISION    dip_sint32
   #define DIP_TPI_MAX_IDENTIFIER   DIP_DTID_SINT32
   #define DIP_TPI_MAX_EXTENSION    DIP_SINT32_EXTENSION
   #define DIP_TPI_MAXVALUE         DIP_MAX_SINT8
   #define DIP_TPI_MINVALUE         DIP_MIN_SINT8
   #define DIP_TPI_ROUNDOFF_BIAS    (0.5)
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_MAX_IDENTIFIER
   #undef DIP_TPI_MAX_EXTENSION
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_REAL
   #undef DIP_TPI_IS_INTEGER
   #undef DIP_TPI_MAX_PRECISION
   #undef DIP_TPI_MAXVALUE
   #undef DIP_TPI_MINVALUE
   #undef DIP_TPI_ROUNDOFF_BIAS
#endif


#if ( _DIP_TPI_TYPES & DIP_DTID_SINT16 )
   #define DIP_TPI dip_sint16
   #define DIP_TPI_EXTENSION DIP_SINT16_EXTENSION
   #define DIP_TPI_IDENTIFIER DIP_DTID_SINT16
   #define DIP_TPI_DATA_TYPE DIP_DT_SINT16
   
   #define DIP_TPI_IS_REAL
   #define DIP_TPI_IS_INTEGER
   #define DIP_TPI_MAX_PRECISION    dip_sint32
   #define DIP_TPI_MAX_IDENTIFIER   DIP_DTID_SINT32
   #define DIP_TPI_MAX_EXTENSION    DIP_SINT32_EXTENSION
   #define DIP_TPI_MAXVALUE         DIP_MAX_SINT16
   #define DIP_TPI_MINVALUE         DIP_MIN_SINT16
   #define DIP_TPI_ROUNDOFF_BIAS    (0.5)
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_MAX_IDENTIFIER
   #undef DIP_TPI_MAX_EXTENSION
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_REAL
   #undef DIP_TPI_IS_INTEGER
   #undef DIP_TPI_MAX_PRECISION
   #undef DIP_TPI_MAXVALUE
   #undef DIP_TPI_MINVALUE
#endif


#if ( _DIP_TPI_TYPES & DIP_DTID_SINT32 )
   #define DIP_TPI dip_sint32
   #define DIP_TPI_EXTENSION DIP_SINT32_EXTENSION
   #define DIP_TPI_IDENTIFIER DIP_DTID_SINT32
   #define DIP_TPI_DATA_TYPE DIP_DT_SINT32
   
   #define DIP_TPI_IS_REAL
   #define DIP_TPI_IS_INTEGER
   #define DIP_TPI_MAX_PRECISION    dip_sint32
   #define DIP_TPI_MAX_IDENTIFIER   DIP_DTID_SINT32
   #define DIP_TPI_MAX_EXTENSION    DIP_SINT32_EXTENSION
   #define DIP_TPI_MAXVALUE         DIP_MAX_SINT32
   #define DIP_TPI_MINVALUE         DIP_MIN_SINT32
   #define DIP_TPI_ROUNDOFF_BIAS    (0.5)
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_MAX_IDENTIFIER
   #undef DIP_TPI_MAX_EXTENSION
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_REAL
   #undef DIP_TPI_IS_INTEGER
   #undef DIP_TPI_MAX_PRECISION
   #undef DIP_TPI_MAXVALUE
   #undef DIP_TPI_MINVALUE
   #undef DIP_TPI_ROUNDOFF_BIAS
#endif


#if ((!defined(DIP_DTI_INT_IS_INT32)) && ( _DIP_TPI_TYPES & DIP_DTID_SINT ))
   #define DIP_TPI dip_sint
   #define DIP_TPI_EXTENSION DIP_DT_INT_NON_SINT32_EXTENSION
   #define DIP_TPI_IDENTIFIER DIP_DTID_SINT
   #define DIP_TPI_DATA_TYPE DIP_DT_SINT
   
   #define DIP_TPI_IS_REAL
   #define DIP_TPI_IS_SIGNED
   #define DIP_TPI_IS_INTEGER
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_REAL
   #undef DIP_TPI_IS_INTEGER
   #undef DIP_TPI_IS_UNSIGNED
#endif


#if ( _DIP_TPI_TYPES & DIP_DTID_SFLOAT )
   #define DIP_TPI dip_sfloat
   #define DIP_TPI_EXTENSION DIP_SFLOAT_EXTENSION
   #define DIP_TPI_IDENTIFIER DIP_DTID_SFLOAT
   #define DIP_TPI_DATA_TYPE DIP_DT_SFLOAT
   
   #define DIP_TPI_IS_FLOAT
   #define DIP_TPI_IS_REAL
   #define DIP_TPI_CAST_R2C dip_scomplex
   #define DIP_TPI_CAST_R2C_EXTENSION DIP_SCOMPLEX_EXTENSION
   #define DIP_TPI_MAX_PRECISION    dip_dfloat
   #define DIP_TPI_MAX_IDENTIFIER   DIP_DTID_DFLOAT
   #define DIP_TPI_MAX_EXTENSION    DIP_DFLOAT_EXTENSION
   #define DIP_TPI_MAXVALUE         DIP_MAX_FLOAT32
   #define DIP_TPI_MINVALUE         DIP_MIN_FLOAT32
   #define DIP_TPI_ROUNDOFF_BIAS    (0.0)
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_MAX_IDENTIFIER
   #undef DIP_TPI_MAX_EXTENSION
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_FLOAT
   #undef DIP_TPI_IS_REAL
   #undef DIP_TPI_CAST_R2C
   #undef DIP_TPI_CAST_R2C_EXTENSION
   #undef DIP_TPI_MAX_PRECISION
   #undef DIP_TPI_MAXVALUE
   #undef DIP_TPI_MINVALUE
   #undef DIP_TPI_ROUNDOFF_BIAS
#endif


#if ( _DIP_TPI_TYPES & DIP_DTID_DFLOAT )
   #define DIP_TPI dip_dfloat
   #define DIP_TPI_EXTENSION DIP_DFLOAT_EXTENSION
   #define DIP_TPI_IDENTIFIER DIP_DTID_DFLOAT
   #define DIP_TPI_DATA_TYPE DIP_DT_DFLOAT
   
   #define DIP_TPI_IS_FLOAT
   #define DIP_TPI_IS_REAL
   #define DIP_TPI_CAST_R2C dip_dcomplex
   #define DIP_TPI_CAST_R2C_EXTENSION DIP_DCOMPLEX_EXTENSION
   #define DIP_TPI_MAX_PRECISION    dip_dfloat
   #define DIP_TPI_MAX_IDENTIFIER   DIP_DTID_DFLOAT
   #define DIP_TPI_MAX_EXTENSION    DIP_DFLOAT_EXTENSION
   #define DIP_TPI_MAXVALUE         DIP_MAX_FLOAT64
   #define DIP_TPI_MINVALUE         DIP_MIN_FLOAT64
   #define DIP_TPI_ROUNDOFF_BIAS    (0.0)
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_MAX_IDENTIFIER
   #undef DIP_TPI_MAX_EXTENSION
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_FLOAT
   #undef DIP_TPI_IS_REAL
   #undef DIP_TPI_CAST_R2C
   #undef DIP_TPI_CAST_R2C_EXTENSION
   #undef DIP_TPI_MAX_PRECISION
   #undef DIP_TPI_MAXVALUE
   #undef DIP_TPI_MINVALUE
   #undef DIP_TPI_ROUNDOFF_BIAS
#endif


#undef  DIP_TPI_READ
#undef  DIP_TPI_WRITE
#define DIP_TPI_READ( in, mask ) (in)
#define DIP_TPI_WRITE( out, val, mask ) (out).re = (val).re; (out).im = (val).im;


#if ( _DIP_TPI_TYPES & DIP_DTID_SCOMPLEX )
   #define DIP_TPI dip_scomplex
   #define DIP_TPI_EXTENSION DIP_SCOMPLEX_EXTENSION
   #define DIP_TPI_IDENTIFIER DIP_DTID_SCOMPLEX
   #define DIP_TPI_DATA_TYPE DIP_DT_SCOMPLEX
   
   #define DIP_TPI_IS_COMPLEX
   #define DIP_TPI_CAST_C2R             dip_sfloat
   #define DIP_TPI_FLOAT                dip_sfloat
   #define DIP_TPI_MAX_PRECISION_C2R    dip_dfloat
   #define DIP_TPI_MAX_PRECISION        dip_dcomplex
   #define DIP_TPI_MAX_IDENTIFIER       DIP_DTID_DCOMPLEX
   #define DIP_TPI_MAX_EXTENSION        DIP_DCOMPLEX_EXTENSION
   #define DIP_TPI_C2R_MAXVALUE         DIP_MAX_FLOAT32
   #define DIP_TPI_C2R_MINVALUE         DIP_MIN_FLOAT32
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_MAX_IDENTIFIER
   #undef DIP_TPI_MAX_EXTENSION
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_COMPLEX
   #undef DIP_TPI_CAST_C2R
   #undef DIP_TPI_FLOAT
   #undef DIP_TPI_MAX_PRECISION_C2R
   #undef DIP_TPI_MAX_PRECISION
   #undef DIP_TPI_C2R_MAXVALUE
   #undef DIP_TPI_C2R_MINVALUE
#endif


#if ( _DIP_TPI_TYPES & DIP_DTID_DCOMPLEX )
   #define DIP_TPI dip_dcomplex
   #define DIP_TPI_EXTENSION DIP_DCOMPLEX_EXTENSION
   #define DIP_TPI_IDENTIFIER DIP_DTID_DCOMPLEX
   #define DIP_TPI_DATA_TYPE DIP_DT_DCOMPLEX
   
   #define DIP_TPI_IS_COMPLEX
   #define DIP_TPI_CAST_C2R             dip_dfloat
   #define DIP_TPI_FLOAT                dip_dfloat
   #define DIP_TPI_MAX_PRECISION_C2R    dip_dfloat
   #define DIP_TPI_MAX_PRECISION        dip_dcomplex
   #define DIP_TPI_MAX_IDENTIFIER       DIP_DTID_DCOMPLEX
   #define DIP_TPI_MAX_EXTENSION        DIP_DCOMPLEX_EXTENSION
   #define DIP_TPI_C2R_MAXVALUE         DIP_MAX_FLOAT64
   #define DIP_TPI_C2R_MINVALUE         DIP_MIN_FLOAT64
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_MAX_IDENTIFIER
   #undef DIP_TPI_MAX_EXTENSION
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_COMPLEX
   #undef DIP_TPI_CAST_C2R
   #undef DIP_TPI_FLOAT
   #undef DIP_TPI_MAX_PRECISION_C2R
   #undef DIP_TPI_MAX_PRECISION
   #undef DIP_TPI_C2R_MAXVALUE
   #undef DIP_TPI_C2R_MINVALUE
#endif


#undef  DIP_TPI_READ
#undef  DIP_TPI_WRITE
#define DIP_TPI_READ( in, mask) DIP_BINARY_READ( in, mask)
#define DIP_TPI_WRITE( out, val, mask) DIP_BINARY_WRITE( out, val, mask)


#if ( _DIP_TPI_TYPES & DIP_DTID_BIN8 )
   #define DIP_TPI dip_bin8
   #define DIP_TPI_EXTENSION DIP_BIN8_EXTENSION
   #define DIP_TPI_IDENTIFIER DIP_DTID_BIN8
   #define DIP_TPI_DATA_TYPE DIP_DT_BIN8
   
   #define DIP_TPI_IS_BINARY
   #define DIP_TPI_IS_PLANE
   #define DIP_TPI_MAX_PRECISION   dip_bin8
   #define DIP_TPI_MAX_IDENTIFIER  DIP_DTID_BIN8
   #define DIP_TPI_MAX_EXTENSION   DIP_BIN8_EXTENSION
   #define DIP_TPI_MAXVALUE        1
   #define DIP_TPI_MINVALUE        0
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_MAX_IDENTIFIER
   #undef DIP_TPI_MAX_EXTENSION
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_BINARY
   #undef DIP_TPI_IS_PLANE
   #undef DIP_TPI_MAX_PRECISION
   #undef DIP_TPI_MAXVALUE
   #undef DIP_TPI_MINVALUE
#endif

#if ( _DIP_TPI_TYPES & DIP_DTID_BIN16 )
   #define DIP_TPI dip_bin16
   #define DIP_TPI_EXTENSION b16
   #define DIP_TPI_IDENTIFIER DIP_DTID_BIN16
   #define DIP_TPI_DATA_TYPE DIP_DT_BIN16
   
   #define DIP_TPI_IS_BINARY
   #define DIP_TPI_IS_PLANE
   #define DIP_TPI_MAX_PRECISION   dip_bin16
   #define DIP_TPI_MAX_IDENTIFIER  DIP_DTID_BIN16
   #define DIP_TPI_MAX_EXTENSION   DIP_BIN16_EXTENSION
   #define DIP_TPI_MAXVALUE        1
   #define DIP_TPI_MINVALUE        0
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_MAX_IDENTIFIER
   #undef DIP_TPI_MAX_EXTENSION
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_BINARY
   #undef DIP_TPI_IS_PLANE
   #undef DIP_TPI_MAX_PRECISION
   #undef DIP_TPI_MAXVALUE
   #undef DIP_TPI_MINVALUE
#endif

#if ( _DIP_TPI_TYPES & DIP_DTID_BIN32 )

   #define DIP_TPI dip_bin32
   #define DIP_TPI_EXTENSION DIP_BIN32_EXTENSION
   #define DIP_TPI_IDENTIFIER DIP_DTID_BIN32
   #define DIP_TPI_DATA_TYPE DIP_DT_BIN32
   
   #define DIP_TPI_IS_BINARY
   #define DIP_TPI_IS_PLANE
   #define DIP_TPI_MAX_PRECISION   dip_bin32
   #define DIP_TPI_MAX_IDENTIFIER  DIP_DTID_BIN32
   #define DIP_TPI_MAX_EXTENSION   DIP_BIN32_EXTENSION
   #define DIP_TPI_MAXVALUE        1
   #define DIP_TPI_MINVALUE        0
   #include DIP_TPI_FILE
   #undef DIP_TPI
   #undef DIP_TPI_EXTENSION
   #undef DIP_TPI_IDENTIFIER
   #undef DIP_TPI_MAX_IDENTIFIER
   #undef DIP_TPI_MAX_EXTENSION
   #undef DIP_TPI_DATA_TYPE
   
   #undef DIP_TPI_IS_BINARY
   #undef DIP_TPI_IS_PLANE
   #undef DIP_TPI_MAX_PRECISION
   #undef DIP_TPI_MAXVALUE
   #undef DIP_TPI_MINVALUE
#endif


#undef DIP_TPI_READ
#undef DIP_TPI_WRITE
#undef _DIP_TPI_TYPES
#undef DIP_TPI_FILE
#undef DIP_TPI_ALLOW
#undef DIP_TPI_FORCE
#undef DIP_TPI_FUNC
#undef DIP_TPI_DEFINE
#undef DIP_TPI_NAME
#undef DIP_ROUNDOFF
#undef DIP_TPI_APPEND
