/*
 * Filename: neighbourlist.h
 *
 * (C) Copyright 2008                    Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 * author: Cris Luengo
 *
 */

#ifndef DIP_NEIGHBOURLIST_H
#define DIP_NEIGHBOURLIST_H
#ifdef __cplusplus
extern "C" {
#endif


DIP_ERROR dip_NeighbourListMake        ( dip_int, dip_int, dip_CoordinateArray*,
                                         dip_Resources );

DIP_ERROR dip_NeighbourListMakeChamfer ( dip_FloatArray, dip_int, dip_CoordinateArray*,
                                         dip_FloatArray*, dip_Resources );

DIP_ERROR dip_NeighbourListMakeImage   ( dip_Image, dip_CoordinateArray*, dip_FloatArray*,
                                         dip_Resources );

DIP_ERROR dip_NeighbourListToIndices   ( dip_CoordinateArray, dip_IntegerArray,
                                         dip_IntegerArray*, dip_Resources );

DIP_ERROR dip_NeighbourIndicesListMake ( dip_IntegerArray, dip_int, dip_IntegerArray*,
                                         dip_Resources );

#ifdef __cplusplus
}
#endif
#endif
