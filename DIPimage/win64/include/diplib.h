/*
 * Filename: diplib.h
 *
 * (C) Copyright 1995-2011               Quantitative Imaging Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : lucas@ph.tn.tudelft.nl
 *
 *
 * This include file includes the most important DIPlib include files that
 * are probably needed at all times and adds some other useful defines.
 *
 *
 * AUTHOR
 *    Michael van Ginkel
 *    Geert van Kempen
 *
 */

#ifndef DIPLIB_H
#define DIPLIB_H
#ifdef __cplusplus
extern "C" {
#endif

/* DIPlib version information */
/*
 * NOTE for when making an official release:
 * 1- update the version number
 * 2- change the DIP_VERSION_TYPE to "Release"
 * The version number has to be updated in the main trunk as well, to
 * keep the development version in sync with the releases.
 * The DIPlib in the trunk is always marked as "Development", only the
 * official releases are marked "Release". (We could define a variable
 * for this in the environment files, but since we need to update the
 * version number when making the release any way, I thought it wouldn't
 * matter much.)
 */
#define DIP_VERSION_NUMBER 2.7
#define DIP_VERSION_DATE __DATE__
#ifdef DEBUG
#define DIP_VERSION_TYPE "Debug"
#else
#define DIP_VERSION_TYPE "Release"
/*#define DIP_VERSION_TYPE "Development"*/
#endif
#define DIP_FIRST_COPYRIGHT_YEAR "1995-"
#define DIP_LAST_COPYRIGHT_YEAR "2014"

#ifndef DIP_ARCH_H
#include "dip_arch.h"
#endif

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

#ifdef DEBUG
/*#define DIP_REPORT_ON*/
/* Try defining DIP_REPORT_ON at the top of the file you are debugging... */
#else
#ifndef NDEBUG
#define NDEBUG
#endif
#endif

#ifdef DIP_REPORT_ON
#define DIP_REPORT( x ) x
#else
#define DIP_REPORT( x )
#endif

#ifndef DIP_TYPES_H
#include "dip_types.h"
#endif

#ifndef DIP_MACROS_H
#include "dip_macros.h"
#endif

#ifndef DIP_ERROR_H
#include "dip_error.h"
#endif

#ifndef DIP_LIMITS_H
#include "dip_limits.h"
#endif

#ifndef DIP_LIBRARY_H
#include "dip_library.h"
#endif

#ifndef DIP_INFRA_H
#include "dip_infra.h"
#endif

#ifndef DIP_TPSCALAR_H
#include "dip_tpscalar.h"
#endif

#ifndef DIP_SUPPORT_H
#include "dip_support.h"
#endif

#ifndef DIP_MATH_H
#include "dip_math.h"
#endif

#ifndef DIP_FRAMEWORK_H
#include "dip_framework.h"
#endif

#ifdef __cplusplus
}
#endif
#endif
