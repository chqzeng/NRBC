/*
 * Filename: dip_limits.h
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
 * Definition of the limits on the DIPlib types.
 *
 */

#ifndef DIP_LIMITS_H
#define DIP_LIMITS_H
#ifdef __cplusplus
extern "C" {
#endif

/* I've copied these values from limits.h on my 64-bit Linux distribution (CL, 2014-04-03)
 * The values in limits.h vary from system to system, hence we have to fix these values
 * here. The previous version of this file contained constants in hexadecimal format,
 * which did not work well with negative constants. */

#define DIP_MAX_UINT8     255
#define DIP_MIN_UINT8     0
#define DIP_MAX_UINT16    65535
#define DIP_MIN_UINT16    0
#define DIP_MAX_UINT32    4294967295U
#define DIP_MIN_UINT32    0
#ifdef DIP_64BITS
#define DIP_MAX_UINT64    18446744073709551615UL
#define DIP_MIN_UINT64    0
#endif

#define DIP_MAX_SINT8     127
#define DIP_MIN_SINT8     (-128)
#define DIP_MAX_SINT16    32767
#define DIP_MIN_SINT16    (-32768)
#define DIP_MAX_SINT32    2147483647
#define DIP_MIN_SINT32    (-DIP_MAX_SINT32-1)
#ifdef DIP_64BITS
#define DIP_MAX_SINT64    9223372036854775807L
#define DIP_MIN_SINT64    (-DIP_MAX_SINT64-1L)
#endif

#define DIP_MAX_FLOAT32   3.40282346638528860E+38
#define DIP_MIN_FLOAT32   -DIP_MAX_FLOAT32
#define DIP_UND_FLOAT32   1.17549435E-38
#define DIP_MAX_FLOAT64   1.7976931348623157E+308
#define DIP_MIN_FLOAT64   -DIP_MAX_FLOAT64
#define DIP_UND_FLOAT64   2.2250738585072014E-308
#define DIP_MAX_SFLOAT    DIP_MAX_FLOAT32
#define DIP_MIN_SFLOAT    DIP_MIN_FLOAT32
#define DIP_UND_SFLOAT    DIP_UND_FLOAT32
#define DIP_MAX_DFLOAT    DIP_MAX_FLOAT64
#define DIP_MIN_DFLOAT    DIP_MIN_FLOAT64
#define DIP_UND_DFLOAT    DIP_UND_FLOAT64

/* Effing pollution of the name space! (CL, 02-10-2006)
#define DIP_MAX_uint8     DIP_MAX_UINT8
#define DIP_MIN_uint8     DIP_MIN_UINT8
#define DIP_MAX_uint16    DIP_MAX_UINT16
#define DIP_MIN_uint16    DIP_MIN_UINT16
#define DIP_MAX_uint32    DIP_MAX_UINT32
#define DIP_MIN_uint32    DIP_MIN_UINT32

#define DIP_MAX_sint8     DIP_MAX_SINT8
#define DIP_MIN_sint8     DIP_MIN_SINT8
#define DIP_MAX_sint16    DIP_MAX_SINT16
#define DIP_MIN_sint16    DIP_MIN_SINT16
#define DIP_MAX_sint32    DIP_MAX_SINT32
#define DIP_MIN_sint32    DIP_MIN_SINT32

#define DIP_MAX_float32   DIP_MAX_FLOAT32
#define DIP_MIN_float32   DIP_MIN_FLOAT32
#define DIP_UND_float32   DIP_UND_FLOAT32
#define DIP_MAX_float64   DIP_MAX_FLOAT64
#define DIP_MIN_float64   DIP_MIN_FLOAT64
#define DIP_UND_float64   DIP_UND_FLOAT64
*/

#ifdef DIP_64BITS
#define DIP_MIN_INT       DIP_MIN_SINT64
#define DIP_MAX_INT       DIP_MAX_SINT64
#define DIP_MIN_UINT      DIP_MIN_UINT64
#define DIP_MAX_UINT      DIP_MAX_UINT64
#else
#define DIP_MIN_INT       DIP_MIN_SINT32
#define DIP_MAX_INT       DIP_MAX_SINT32
#define DIP_MIN_UINT      DIP_MIN_UINT32
#define DIP_MAX_UINT      DIP_MAX_UINT32
#endif
#define DIP_MIN_FLOAT     DIP_MIN_FLOAT64
#define DIP_MAX_FLOAT     DIP_MAX_FLOAT64

#ifdef __cplusplus
}
#endif
#endif
