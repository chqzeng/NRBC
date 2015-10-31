/*
 * Filename: dipio_fld.h
 *
 * (C) Copyright 2001                    Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physfld
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 */

#ifndef DIPIO_FLD_H
#define DIPIO_FLD_H

#ifdef __cplusplus
extern "C" {
#endif

DIPIO_EXPORT dip_int dipio_WriteFLDID ( void );
DIPIO_ERROR dipio_ImageWriteFLD ( dip_Image, dip_String );

/* should only be called by dipio_Initialise() */
dip_Error dipio_RegisterWriteFLD ( dip_int * );

#ifdef __cplusplus
}
#endif


#endif /* DIPIO_FLD_H */
