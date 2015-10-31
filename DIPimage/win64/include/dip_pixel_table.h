/*
 * Filename: dip_pixel_table.h
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
 * Author: Geert M.P. van Kempen
 */

#ifndef DIP_PIXEL_TABLE_H
#define DIP_PIXEL_TABLE_H
#ifdef __cplusplus
extern "C" {
#endif

typedef struct dip_PixelTableRunTag
{
   dip_IntegerArray coordinate;
   dip_int length;
   struct dip_PixelTableRunTag *next;
} dip_PixelTableRun;

typedef struct
{
   dip_Resources     resources;
   dip_IntegerArray  dimensions;
   dip_IntegerArray  origin;
   dip_int           runs;
   dip_PixelTableRun *firstRun;
   dip_PixelTableRun *lastRun;
} dip__PixelTable, *dip_PixelTable;


/*
 * declaration of the function to allocate the error structure
 */
DIP_ERROR dip_PixelTableNew               ( dip_PixelTable *, dip_IntegerArray,
                                            dip_int, dip_Resources );
DIP_ERROR dip_PixelTableFree              ( dip_PixelTable * );
DIP_ERROR dip_PixelTableAllocateRuns      ( dip_PixelTable, dip_int );
DIP_ERROR dip_PixelTableAllocateRun       ( dip_PixelTable, dip_int );
DIP_ERROR dip_PixelTableFreeRuns          ( dip_PixelTable );
DIP_ERROR dip_PixelTableGetRun            ( dip_PixelTable, dip_int,
                                            dip_IntegerArray, dip_int * );
DIP_ERROR dip_PixelTableSetRun            ( dip_PixelTable, dip_int,
                                            dip_IntegerArray, dip_int );
DIP_ERROR dip_PixelTableAddRun            ( dip_PixelTable, dip_IntegerArray,
                                            dip_int );
DIP_ERROR dip_PixelTableGetRuns           ( dip_PixelTable, dip_int * );
DIP_ERROR dip_PixelTableGetDimensionality ( dip_PixelTable, dip_int * );
DIP_ERROR dip_PixelTableGetDimensions     ( dip_PixelTable, dip_IntegerArray *,
                                            dip_Resources );
DIP_ERROR dip_PixelTableGetSize           ( dip_PixelTable, dip_int * );
DIP_ERROR dip_PixelTableShiftOrigin       ( dip_PixelTable, dip_IntegerArray );
DIP_ERROR dip_PixelTableGetOrigin         ( dip_PixelTable, dip_IntegerArray *,
                                            dip_Resources );
DIP_ERROR dip_PixelTableGetPixelCount     ( dip_PixelTable, dip_int * );
DIP_ERROR dip_PixelTableGetOffsetAndLength( dip_PixelTable, dip_IntegerArray,
                                            dip_IntegerArray *,
                                            dip_IntegerArray *, dip_Resources );
DIP_ERROR dip_PixelTableCreateFilter      ( dip_PixelTable *, dip_FloatArray,
                                            dip_FilterShape, dip_Image,
                                            dip_Resources );

DIP_ERROR dip_BinaryImageToPixelTable     ( dip_Image, dip_PixelTable *,
                                            dip_Resources );
DIP_ERROR dip_PixelTableToBinaryImage     ( dip_PixelTable, dip_Image );

DIP_ERROR dip_GreyValuesInPixelTable      ( dip_PixelTable, dip_Image,
                                            dip_FloatArray *, dip_Resources );
   
#ifdef __cplusplus
}
#endif
#endif
