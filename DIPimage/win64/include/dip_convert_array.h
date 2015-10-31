/*
 * Filename: dip_convert_array.h
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
 * AUTHOR
 *    Geert M.P. van Kempen
 *
 */
#ifndef DIP_TPI_INC_ODT

  #ifndef DIP_TPI_INC_IDT

    #ifndef DIP_CONVERT_ARRAY_H
    #define DIP_CONVERT_ARRAY_H
    #ifdef __cplusplus
    extern "C" {
    #endif

    /* define some short macros for many used function types */
    #define DIP_TWO_FUNC(func,a,b)   DIP_FUNC(DIP_FUNC(func,a),b)
    #define DIP_TWO_DEFINE(func,a,b) DIP_DEFINE(dip_Error,DIP_FUNC(func,a),b)
    #define DIP_TWO_DECLARE(func) 	DIP_DECLARE(dip_Error,DIP_FUNC(func,T),T)
    #define DIP_TWO_NAME(func,a,b)   DIP_FUNC_NAME(DIP_NAME(func,a), b)

	typedef dip_Error (*dip_ConvertArrayFunction) ( void *, dip_int,
								dip_int, void *, dip_int, dip_int, dip_int );


    #define DIP_TPI_INC_IDT_FORCE DIP_DTID_MASK_MAXIMUM_PRECISION
    #define  DIP_TPI_INC_IDT_FILE "dip_convert_array.h"
    #include "dip_tpi_inc_idt.h"

    #ifdef __cplusplus
    }
    #endif
    #endif

  #else

    #define DIP_TPI_INC_ODT_FORCE DIP_DTID_MASK_MAXIMUM_PRECISION
    #define DIP_TPI_INC_ODT_FILE "dip_convert_array.h"
    #include "dip_tpi_inc_odt.h"

  #endif

#else

	DIP_ERROR DIP_FUNC2(dip_ConvertArray,DIP_TPI_INC_IDT_EXTENSION,DIP_TPI_INC_ODT_EXTENSION)
		( void *, dip_int, dip_int, void *, dip_int, dip_int, dip_int );

#endif
