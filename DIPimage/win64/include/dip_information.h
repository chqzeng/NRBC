/*
 * Filename: dip_information.h
 *
 * (C) Copyright 1995-2006               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : lucas@ph.tn.tudelft.nl
 *
 */

#ifndef DIP_INFORMATION_H
#define DIP_INFORMATION_H
#ifdef __cplusplus
extern "C" {
#endif

#define DIP_INFO_LENGTH  128

typedef struct
{
   char name         [ DIP_INFO_LENGTH ];
   char description  [ DIP_INFO_LENGTH ];
   char version      [ DIP_INFO_LENGTH ];
   char date         [ DIP_INFO_LENGTH ];
   char type         [ DIP_INFO_LENGTH ];
   char supervisor   [ DIP_INFO_LENGTH ];
   char authors      [ DIP_INFO_LENGTH ];
   char contact      [ DIP_INFO_LENGTH ];
   char URL          [ DIP_INFO_LENGTH ];
   char copyright    [ DIP_INFO_LENGTH ];
   char architecture [ DIP_INFO_LENGTH ];
} dip_LibraryInformation;

DIP_ERROR dip_GetLibraryInformation ( dip_LibraryInformation * );

#ifdef __cplusplus
}
#endif
#endif
