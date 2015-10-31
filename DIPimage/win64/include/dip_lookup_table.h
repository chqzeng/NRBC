/*
 * Filename: dip_lookup_table.h
 *
 * Defines and functions for the lookup_table datastructure
 *
 * AUTHOR
 *    Geert van Kempen, Unilever Research Vlaardingen, 1999
 */

#ifndef DIP_LOOKUP_TABLE_H
#define DIP_LOOKUP_TABLE_H
#ifdef __cplusplus
extern "C" {
#endif

/* Definition of DIPlib lookup table */

typedef struct
{
   void *lookupTable;
} dip__LookupTable, *dip_LookupTable;

DIP_ERROR dip_LookupTableNew         ( dip_LookupTable *, dip_DataType,
                                       dip_int, dip_int, dip_Resources );
DIP_ERROR dip_LookupTableGetMaximum  ( dip_LookupTable, dip_int * );
DIP_ERROR dip_LookupTableGetMinimum  ( dip_LookupTable, dip_int * );
DIP_ERROR dip_LookupTableGetSize     ( dip_LookupTable, dip_int * );
DIP_ERROR dip_LookupTableGetDataType ( dip_LookupTable, dip_DataType * );
DIP_ERROR dip_LookupTableGetData     ( dip_LookupTable, void **, dip_Boolean );
DIP_ERROR dip_LookupTableGetFloat    ( dip_LookupTable, dip_int, dip_float * );
DIP_ERROR dip_LookupTableSetFloat    ( dip_LookupTable, dip_int, dip_float );
DIP_ERROR dip_LookupTableAddFloat    ( dip_LookupTable, dip_int, dip_float );
DIP_ERROR dip_ImageLookup            ( dip_Image, dip_Image, dip_LookupTable,
													dip_float, dip_Boolean );

#ifdef __cplusplus
}
#endif
#endif
