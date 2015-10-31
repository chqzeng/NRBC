/*
 * Filename: dip_globals.h
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
 */

#ifndef DIP_GLOBALS_H
#define DIP_GLOBALS_H
#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
   void *ptr;
   dip_Error ( *FreeHandle )( void ** );
} dip_Globals;

/* GLB stands for _GL_o_B_al */

typedef enum
{
   DIP_GLB_FREE        = 1,
   DIP_GLB_GET         = 2,
   DIP_GLB_SET_HANDLER = 3
} dip_GlobalsMode;


/* ENT stands for _ENT_ry */

#define DIP_GLB_ENT_IMAGE_TYPE_HANDLERS      0
#define DIP_GLB_ENT_UNIQUE_NUMBER            1
#define DIP_GLB_ENT_DEFAULT_COERCION         2
#define DIP_GLB_ENT_REGISTRY_HANDLERS        3
#define DIP_GLB_ENT_BOUNDARY_CONDITION       4
#define DIP_GLB_ENT_GAUSS_TRUNCATION         5
#define DIP_GLB_ENT_FILTER_SHAPE             6
#define DIP_GLB_ENT_NUMBER_OF_THREADS        7

#define DIP_GLB_MAX_GLOBALS                  100


DIP_ERROR dip_GlobalsControl ( void ***, dip_GlobalsMode, dip_int,
                               dip_Error (*)( void ** ));

/* access function to global variables */
DIP_ERROR dip_GlobalBoundaryConditionGet  ( dip_BoundaryArray *, dip_int,
                                            dip_Resources );
DIP_ERROR dip_GlobalBoundaryConditionSet  ( dip_BoundaryArray );
DIP_ERROR dip_GlobalGaussianTruncationGet ( dip_float * );
DIP_ERROR dip_GlobalGaussianTruncationSet ( dip_float );
DIP_ERROR dip_GlobalFilterShapeGet        ( dip_FilterShape * );
DIP_ERROR dip_GlobalFilterShapeSet        ( dip_FilterShape );
DIP_ERROR dip_GlobalNumberOfThreadsGet    ( dip_int * );
DIP_ERROR dip_GlobalNumberOfThreadsSet    ( dip_int );

#ifdef __cplusplus
}
#endif
#endif
