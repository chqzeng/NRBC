/*
 *
 * (C) Copyright 1995-1999               Pattern Recognition Group
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

#ifndef DIP_TESTING_H
#define DIP_TESTING_H
#ifdef __cplusplus
extern "C" {
#endif

DIP_ERROR dip_TestInfra( dip_Image );
DIP_ERROR dip_TestGauss( dip_Image, dip_Image, dip_float, dip_float, dip_int );
DIP_ERROR dip_TestError( void );

#ifdef __cplusplus
}
#endif
#endif
