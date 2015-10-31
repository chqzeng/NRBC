/*
 * Filename: dml_dipmex.h
 * Interface between MATLAB and DIPlib
 *
 * (C) Copyright 1999-2002               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Cris Luengo, February-May 1999.
 * June 1999: Changed the random variable handling.
 * February 2000: Added some function declarations.
 * April 2001: Not copying image data anymore.
 * 15 November 2002: Fixed binary images to work in MATLAB 6.5 (R13)
 *
 * This file includes most needed headers.
 */

#ifndef DML_DIPMEX_H
#define DML_DIPMEX_H

#include <ctype.h>
#undef __STDC_UTF_16__ /* Not sure why, but this generates a compile error now (Darwin, Apple LLVM version 5.1, MATLAB R2009b) */
#include <mex.h>
#include "diplib.h"
#include "dip_string.h"
#include "dip_developer.h"
#include "dip_noise.h"
#include "dip_distribution.h"
#include "dip_histogram.h"

#ifndef DML_HAS_MWSIZE
typedef int mwSize;
#endif

#include "dml_error.h"
#include "dml_macros.h"

DML_EXPORT dip_Boolean dml_mxIsScalar        (const mxArray*);
DML_EXPORT dip_Boolean dml_mxIsIntScalar     (const mxArray*);
DML_EXPORT dip_Boolean dml_mxIsComplexScalar (const mxArray*);
DML_EXPORT dip_Boolean dml_mxIsVector        (const mxArray*);
DML_EXPORT dip_Boolean dml_mxIsIntVector     (const mxArray*);
DML_EXPORT dip_Boolean dml_mxIsComplexVector (const mxArray*);
DML_EXPORT dip_Boolean dml_mxIsCharString    (const mxArray*);
DML_EXPORT dip_Boolean dml_mxIsDefault       (const mxArray*);
DML_EXPORT dip_Boolean dml_mxIsEmptyImage    (const mxArray*);

DML_EXPORT dip_Error dml_Initialise (void);
DML_EXPORT dip_Error dml_Exit (void);
DML_EXPORT const char* dml_PrintErrorStruct (dip_Error, char*, dip_uint);

DML_EXPORT dip_Error dml_mex2dip (const mxArray*, dip_Image*, dip_Resources);
DML_EXPORT dip_Error dml_mex2dip_compsep (const mxArray*, dip_Image*, dip_Image*, dip_Resources);
DML_EXPORT dip_Error dml_mex2dipArray (const mxArray*, dip_ImageArray*, dip_Resources);
DML_EXPORT dip_Error dml_dip2mla(const dip_Image, mxArray**);
DML_EXPORT dip_Error dml_dip2mex (const dip_Image, mxArray**);
DML_EXPORT dip_Error dml_dip2mex_compsep (const dip_Image, const dip_Image, mxArray**);
DML_EXPORT dip_Error dml_dip2mexArray (const dip_ImageArray, mxArray**);
DML_EXPORT dip_Error dml_newdip (dip_Image*, dip_Resources);
DML_EXPORT dip_Error dml_2mex_histogram (const dip_Histogram, mxArray**);
DML_EXPORT dip_Error dml_newhistogram (dip_Histogram*, dip_Resources);
DML_EXPORT dip_Error dml_2mex_distribution (const dip_Distribution, mxArray**);
DML_EXPORT dip_Error dml_newdistribution (dip_Distribution*, dip_Resources);

DML_EXPORT mxArray* dml_RetrieveMeasureTags (void);
DML_EXPORT mxArray* dml_RetrieveImageReadTags (void);
DML_EXPORT mxArray* dml_RetrieveImageWriteTags (void);
DML_EXPORT dip_Error dml_2dip_featureID (const mxArray*, dip_int*);
DML_EXPORT dip_Error dml_2dip_featureID_array (const mxArray*, dip_IntegerArray*, dip_Resources);
DML_EXPORT dip_Error dml_2mex_featureID (dip_int, char*);
DML_EXPORT dip_Error dml_2dip_ImageReadFunction (const mxArray*, dip_int*);
DML_EXPORT dip_Error dml_2dip_ImageWriteFunction (const mxArray*, dip_int*);

DML_EXPORT dip_Error dml_2dip_boundaryarray (const mxArray*, dip_BoundaryArray*, dip_Resources);
DML_EXPORT dip_Error dml_2dip_uf_boundaryarray (const mxArray*, dip_BoundaryArray*, dip_int, dip_Resources);
DML_EXPORT dip_Error dml_2mex_boundaryarray (const dip_BoundaryArray, mxArray**);

DML_EXPORT dip_Error dml_2dip_PhysicalDimensions (const mxArray*, dip_PhysicalDimensions*, dip_Resources);
DML_EXPORT dip_Error dml_2mex_PhysicalDimensions (const dip_PhysicalDimensions, mxArray**);

DML_EXPORT extern dip_Random dml_random_var;
DML_EXPORT extern dip_Boolean newLogicalStyle;
DML_EXPORT extern dip_Boolean dml__initialised;

#define DML_FEATURE_NAME_LENGTH 50

#endif /* ifndef DML_DIPMEX_H */

