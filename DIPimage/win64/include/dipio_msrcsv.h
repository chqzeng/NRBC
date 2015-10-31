/*
 * Filename: dipio_csv.h
 *
 * (C) Copyright 2000                    Pattern Recognition Group
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

#ifndef DIPIO_MSR_CSV_H
#define DIPIO_MSR_CSV_H

#ifdef __cplusplus
extern "C" {
#endif


DIPIO_EXPORT dip_int dipio_MsrWriteCSVID ( void );

DIPIO_ERROR dipio_MeasurementWriteCSV (dip_Measurement, dip_String, char *, dip_Boolean);

/* should only be called by dipio_Initialise() */
dip_Error dipio_RegisterMsrWriteCSV ( dip_int * );

#ifdef __cplusplus
}
#endif


#endif /* DIPIO_CSV_H */
