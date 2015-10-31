/*
 * Filename: dip_detection.h
 *
 * (C) Copyright 1995-2010               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 */

#ifndef DIP_DETECTION_H
#define DIP_DETECTION_H
#ifdef __cplusplus
extern "C" {
#endif

DIP_ERROR dip_Canny( dip_Image, dip_Image, dip_float, dip_float, dip_float );

#ifdef __cplusplus
}
#endif
#endif
