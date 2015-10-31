/*
 * Filename: dip_uuid.h
 *
 * (C) Copyright 1995-2000               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : diplib@ph.tn.tudelft.nl
 *
 * AUTHOR:
 *    Geert van Kempen
 */

#ifndef DIP_UUID_H
#define DIP_UUID_H
#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
	dip_uint32 time_low;
	dip_uint16 time_mid;
	dip_uint16 time_hi_and_version;
	dip_uint8  clock_seq_hi_and_reserved;
	dip_uint8  clock_seq_low;
	dip_uint8  node[6];
} dip_Uuid; /* uuid as defined by OpenGroup/DCE */

typedef struct
{
	dip_Uuid uuid; /* universal unique identifier */
	dip_int	rtid; /* runtime identifier */
} dip_Identifier;

DIP_ERROR dip_UuidCompare  ( dip_Uuid, dip_Uuid, dip_Boolean * );
DIP_ERROR dip_UuidIsValid  ( dip_Uuid, dip_Boolean * );
DIP_ERROR dip_UuidToString ( dip_Uuid, dip_String *, dip_Resources );
DIP_ERROR dip_StringToUuid ( dip_String, dip_Uuid * );
DIP_ERROR dip_CharToUuid ( char *, dip_Uuid * );

DIP_ERROR dip_IdentifierCompare ( dip_Identifier, dip_Identifier,
                                  dip_Boolean * );
DIP_ERROR dip_IdentifierIsValid ( dip_Identifier, dip_Boolean * );

#ifdef __cplusplus
}
#endif
#endif
