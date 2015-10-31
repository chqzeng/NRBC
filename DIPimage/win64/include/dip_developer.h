/*
 * Filename: dip_developer.h
 *
 * (C) Copyright 1996-1997               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : lucas@ph.tn.tudelft.nl
 *
 * Definitions and prototypes for public structures and functions that are
 * not intended for general use.
 *
 * AUTHOR
 *    Michael van Ginkel
 *
 * HISTORY
 *    December 1996 - MvG - Created
 *
 */

#ifndef DIP_DEVELOPER_H
#define DIP_DEVELOPER_H
#ifdef __cplusplus
extern "C" {
#endif


typedef struct
{
   dip_Error (*forge)( dip_Image );
   dip_Error (*strip)( dip_Image );
   dip_Error (*copy)( dip_Image, dip_Image );
   dip_Error (*copyProperties)( dip_Image, dip_Image );
   dip_Error (*equal)( dip_Image, dip_Image, dip_Boolean * );
   dip_Error (*clear)( dip_Image );
} dip__SetImageTypeHandlers;


DIP_ERROR dip__ImageGetData          ( dip_Image, void ** );
DIP_ERROR dip__ImageSetData          ( dip_Image, void * );
DIP_ERROR dip__ImageSetDimensions    ( dip_Image, dip_IntegerArray );
DIP_ERROR dip__ImageSetDataType      ( dip_Image, dip_DataType );
DIP_ERROR dip__ImageLocked           ( dip_Image, dip_Boolean * );
DIP_ERROR dip__ImageSetStride        ( dip_Image, dip_IntegerArray );
DIP_ERROR dip__ImageSetDimensionsAndStride
                                     ( dip_Image, dip_IntegerArray, dip_IntegerArray );
DIP_ERROR dip__ImageSetPlane         ( dip_Image, dip_int );
DIP_ERROR dip__ImageSetValid         ( dip_Image );
DIP_ERROR dip__SynchronizeImage      ( dip_Image );
DIP_ERROR dip__ImageSetInterface     ( dip_Image, void * );
DIP_ERROR dip__ImageGetInterface     ( dip_Image, void ** );
DIP_ERROR dip__ImageSetForgeHandler  ( dip_Image, dip_ImageForgeHandler );
DIP_ERROR dip__ImageSetStripHandler  ( dip_Image, dip_ImageStripHandler );
DIP_ERROR dip__ImageSetFreeHandler   ( dip_Image, dip_ImageFreeHandler );
DIP_ERROR dip__ImageValidateStrideOrCreateNew
                                     ( dip_Image, dip_Boolean * );

/* from dip_gltype.c */
DIP_ERROR dip__ImageAddType ( dip_ImageType, dip__SetImageTypeHandlers * );

/* from dip_scconvert.c */
DIP_ERROR dip__ConvertDataType ( dip_Image, dip_Image *, dip_DataType, dip_Resources );

#ifdef __cplusplus
}
#endif
#endif
