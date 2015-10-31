/*
 * Filename: dip_pgst.h
 *
 * author: Bernd Rieger
 * ported code from Peter Bakker
 */

#ifndef PGST_H
#define PGST_H

#include "dip_linear.h"

DIP_ERROR dip_PGST3DLine( dip_ImageArray, dip_Image, dip_ImageArray, dip_ImageArray, dip_ImageArray,  dip_FloatArray);
DIP_ERROR dip_PGST3DSurface( dip_ImageArray, dip_ImageArray, dip_ImageArray, dip_ImageArray,  dip_FloatArray);
#endif /* PGST_H */
