/*
 * Filename: dip_paint.h
 *
 * (C) Copyright 1995-1997               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 * author: Michael van Ginkel, Geert van Kempen
 *
 */

#ifndef DIP_PAINT_H
#define DIP_PAINT_H
#ifdef __cplusplus
extern "C" {
#endif

/*
DIP_ERROR dip_DrawLine        ( dip_Image, dip_Image, dip_IntegerArray,
                                dip_IntegerArray, dip_float );
*/
DIP_ERROR dip_DrawLineFloat   ( dip_Image, dip_Image, dip_IntegerArray,
                                dip_IntegerArray, dip_float );
DIP_ERROR dip_DrawLineComplex ( dip_Image, dip_Image, dip_IntegerArray,
                                dip_IntegerArray, dip_complex );
DIP_ERROR dip_DrawLinesFloat  ( dip_Image, dip_Image, dip_Image,
                                dip_FloatArray );
DIP_ERROR dip_DrawLinesComplex( dip_Image, dip_Image, dip_Image,
                                dip_ComplexArray );
DIP_ERROR dip_PaintEllipsoid  ( dip_Image, dip_FloatArray, dip_FloatArray,
											dip_float );
DIP_ERROR dip_PaintDiamond  ( dip_Image, dip_FloatArray, dip_FloatArray,
											dip_float );
DIP_ERROR dip_PaintBox        ( dip_Image, dip_FloatArray, dip_FloatArray,
											dip_float );

#ifdef __cplusplus
}
#endif
#endif
