/*
 * Filename: dipio.h
 *
 * (C) Copyright 1999-2011               Quantitative Imaging Group
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

#ifndef DIPIO_H
#define DIPIO_H
#ifdef __cplusplus
extern "C" {
#endif

#ifndef DIPLIB_H
#include "diplib.h"
/* this includes <stdlib.h> and <stdio.h> by default. */
#endif

#ifndef DIP_STRING_H
#include "dip_string.h"
#endif

#ifndef DIPIO_IMAGE_H
#include "dipio_image.h"
#endif

#ifndef DIPIO_MEASUREMENT_H
#include "dipio_measurement.h"
#endif

/* dipIO version information */
#define DIPIO_VERSION_NUMBER DIP_VERSION_NUMBER
#define DIPIO_VERSION_DATE __DATE__
#ifdef DEBUG
#define DIPIO_VERSION_TYPE "Debug"
#else
#define DIPIO_VERSION_TYPE DIP_VERSION_TYPE
#endif
#define DIPIO_FIRST_COPYRIGHT_YEAR "1999-"

#ifdef __cplusplus
}
#endif
#endif /* DIPIO_H */
