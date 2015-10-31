/*
 * Filename: dip_types.h
 *
 * (C) Copyright 1995-1997               Pattern Recognition Group
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
 * Definition of the DIPlib types by including an archicture dependent
 * include file if the typically correct definitions are not correct for
 * the current architecture. This file is the supported way of defining the
 * DIPlib types, NEVER include the architecture dependent include files
 * directly.
 *
 * AUTHOR:
 *    Michael van Ginkel
 *    Geert van Kempen
 */

#ifndef DIP_TYPES_H
#define DIP_TYPES_H
#ifdef __cplusplus
extern "C" {
#endif

/* Definition of the floating point (float) types */
typedef float        dip_sfloat;
typedef double       dip_dfloat;

/* Definition of the complex floating point (complex) types */
typedef struct
{
   dip_sfloat re;
   dip_sfloat im;
} dip_scomplex;

typedef struct
{
   dip_dfloat re;
   dip_dfloat im;
} dip_dcomplex;


/* Definition of the binary types */
typedef dip_uint8    dip_bin8;
typedef dip_uint16   dip_bin16;
typedef dip_uint32   dip_bin32;
typedef dip_bin8     dip_binary;

/* Generic types */
typedef dip_dfloat   dip_float;
typedef dip_dcomplex dip_complex;

#ifndef SWIG

typedef enum
{
   DIP_FALSE = 0,
   DIP_TRUE = 1
} dip_Boolean;


/* Flags representing data types */

#define DIP_DTID_UINT8    (1<<0)
#define DIP_DTID_UINT16   (1<<1)
#define DIP_DTID_UINT32   (1<<2)
#define DIP_DTID_SINT8    (1<<3)
#define DIP_DTID_SINT16   (1<<4)
#define DIP_DTID_SINT32   (1<<5)
#define DIP_DTID_SFLOAT   (1<<6)
#define DIP_DTID_DFLOAT   (1<<7)
#define DIP_DTID_SCOMPLEX (1<<8)
#define DIP_DTID_DCOMPLEX (1<<9)
#define DIP_DTID_BIN8     (1<<10)
#define DIP_DTID_BIN16    (1<<11)
#define DIP_DTID_BIN32    (1<<12)
#define DIP_DTID_FLOAT    DIP_DTID_DFLOAT
#define DIP_DTID_COMPLEX  DIP_DTID_DCOMPLEX
#ifdef DIP_DTI_INT_IS_INT32
   #define DIP_DTID_SINT     DIP_DTID_SINT32
#else
   #define DIP_DTID_SINT     (1<<13)
#endif

#define DIP_DTGID_UINT      (DIP_DTID_UINT8|DIP_DTID_UINT16|DIP_DTID_UINT32)
#define DIP_DTGID_UNSIGNED  DIP_DTGID_UINT
#define DIP_DTGID_SINT      (DIP_DTID_SINT8|DIP_DTID_SINT16|DIP_DTID_SINT32)
#define DIP_DTGID_INT       (DIP_DTGID_UINT|DIP_DTGID_SINT)
#define DIP_DTGID_INTEGER   DIP_DTGID_INT
#define DIP_DTGID_FLOAT     (DIP_DTID_SFLOAT|DIP_DTID_DFLOAT)
#define DIP_DTGID_REAL      (DIP_DTGID_INT|DIP_DTGID_FLOAT)
#define DIP_DTGID_COMPLEX   (DIP_DTID_SCOMPLEX|DIP_DTID_DCOMPLEX)
#define DIP_DTGID_SIGNED    (DIP_DTGID_SINT|DIP_DTGID_FLOAT|DIP_DTGID_COMPLEX)
#define DIP_DTGID_BINARY    (DIP_DTID_BIN8|DIP_DTID_BIN16|DIP_DTID_BIN32)
#define DIP_DTGID_NONBINARY (DIP_DTGID_REAL|DIP_DTGID_COMPLEX)
#define DIP_DTGID_NONCOMPLEX (DIP_DTGID_REAL|DIP_DTGID_BINARY)
#define DIP_DTGID_ALL       (DIP_DTGID_NONBINARY|DIP_DTGID_BINARY)
#define DIP_DTGID_CALCULATION_TYPES   (DIP_DTID_UINT32|DIP_DTID_SINT32| \
                                       DIP_DTID_DFLOAT|DIP_DTID_DCOMPLEX| \
                                       DIP_DTGID_BINARY)

#define DIP_UINT8_EXTENSION      u8
#define DIP_UINT16_EXTENSION     u16
#define DIP_UINT32_EXTENSION     u32
#define DIP_SINT8_EXTENSION      s8
#define DIP_SINT16_EXTENSION     s16
#define DIP_SINT32_EXTENSION     s32
#define DIP_SFLOAT_EXTENSION     sfl
#define DIP_DFLOAT_EXTENSION     dfl
#define DIP_SCOMPLEX_EXTENSION   scx
#define DIP_DCOMPLEX_EXTENSION   dcx
#define DIP_BIN8_EXTENSION       b8
#define DIP_BIN16_EXTENSION      b16
#define DIP_BIN32_EXTENSION      b32
#define DIP_BINARY_EXTENSION     b8
#define DIP_DT_INT_NON_SINT32_EXTENSION si
#ifdef DIP_DTI_INT_IS_INT32
   #define DIP_DT_SINT_EXTENSION   s32
#else
   #define DIP_DT_SINT_EXTENSION   DIP_DT_INT_NON_SINT32_EXTENSION
#endif

#endif /* !SWIG */

#ifdef __cplusplus
}
#endif
#endif
