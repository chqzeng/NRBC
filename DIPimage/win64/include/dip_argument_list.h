/*
 * Filename: dip_argument_list.h
 *
 * (C) Copyright 1995-1997               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : lucas@ph.tn.tudelft.nl
 *
 * Contains definitions for the DIPlib argument lists
 *
 * author: Michael van Ginkel
 *
 * history:
 *    23 November 1995     - MvG - created
 */

#ifndef DIP_ARGUMENT_LIST_H
#define DIP_ARGUMENT_LIST_H

#define DIP_AL_INTERNAL   0x80000000
#define DIP_AL_END        DIP_AL_INTERNAL + 1

typedef struct
{
   dip_int label;
   void   *ptr;
} dip_Al;

#endif
