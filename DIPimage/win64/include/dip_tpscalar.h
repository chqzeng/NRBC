/*
 * Filename: dip_tpscalar.h
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
 * Definitions and prototypes for the DIP_IMTP_SCALAR type
 *
 * AUTHOR
 *    Michael van Ginkel
 *
 * HISTORY
 *    December 1996 - MvG - Created
 *
 */

#ifndef DIP_TPI_INC

 #ifndef DIP_TPSCALAR_H
 #define DIP_TPSCALAR_H
 #ifdef __cplusplus
 extern "C" {
 #endif


 typedef enum
 {
    DIP_SCMD_IN_PLACE       = 1,
    DIP_SCMD_FORCE_IN_PLACE = 2
 } dipf_ScMould1to1;

 typedef enum
 {
    DIP_SCSCAN_CONVERT = 1,
    DIP_SCSCAN_CALL_3BUFFERS = 2,
    DIP_SCSCAN_END = 3,
    DIP_SCSCAN_INHERIT_STRIDE0 = 4,
    DIP_SCSCAN_SET_NORMAL_STRIDE = 5
 } dip_ScScanOpcodes;

 typedef enum
 {
    DIP_SCSCAN_IMAGE  = 0,
    DIP_SCSCAN_BUFFER = 1
 } dip_ScScanFlags;

 typedef dip_Error (*dip_ScScanFunction3Buffers)
                   ( void *, dip_int, void *, dip_int, void *, dip_int,
                     dip_int );

 typedef struct
 {
    union
    {
       dip_ScScanOpcodes opCode;
       dip_ScScanFlags flags;
    } tag;
    union
    {
       dip_int intData;
       dip_float floatData;
       dip_ScScanFunction3Buffers f3b;
    } data;
 } dip_ScScanCommands;


 typedef enum
 {
    DIP_CM_DEFAULT      = 0,
    DIP_CM_NO_ZERO_MASK = 1
 } dipf_CheckMask;


 DIP_ERROR dip_ScalarTypeInitialise ( void );
 DIP_ERROR dip_ScScan( void **, dip_int *, dip_DataType *, dip_int,
                       dip_DataType *, dip_int, dip_int, dip_int *,
                       dip_int **, dip_ScScanCommands * );

 DIP_ERROR dip_CheckMask( dip_Image, dip_Image, dipf_CheckMask );
 DIP_ERROR dip_ScGetDataAndPlane    ( dip_Image, dip_int, void **, dip_int *,
                                      dip_DataType * );


 DIP_ERROR dip_ScalarImageNew ( dip_Image *, dip_DataType, dip_IntegerArray,
                                 dip_Resources );
 DIP_ERROR dip_IsScalar       ( dip_Image, dip_Boolean * );
 DIP_ERROR dip_ConvertDataType ( dip_Image, dip_Image, dip_DataType );

 #define DIP_TPI_INC_FILE "dip_tpscalar.h"
 #include "dip_tpi_inc.h"

 #ifdef __cplusplus
 }
 #endif
 #endif

#else

    DIP_TPI_INC_DECLARE(dip_BlockCopyNegative)(
                                     void *, dip_int, dip_int, dip_int *,
                                     void *, dip_int, dip_int, dip_int *,
                                     dip_int, dip_int *, dip_int * );
    DIP_TPI_INC_DECLARE(dip_BlockCopy)( void *, dip_int, dip_int, dip_int *,
                                     void *, dip_int, dip_int, dip_int *,
                                     dip_int, dip_int *, dip_int * );
    DIP_TPI_INC_DECLARE(dip_BlockSet)(  void *, dip_int, dip_int, dip_int *,
                                     void *, dip_int, dip_int *, dip_int * );

#endif
