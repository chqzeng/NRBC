/*
 * Filename: dml_macros.h
 * Interface between MATLAB and DIPlib
 *
 * (C) Copyright 1999-2006               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Cris Luengo, February-May 1999.
 * January 2000: Changed processing of dip_BoundaryArray, dip_FilterShape
 *               and the truncation parameter.
 * April 2001: Not copying image data anymore.
 * 15 November 2002: Fixed binary images to work in MATLAB 6.5 (R13)
 *
 * This file defines the macros that do all the work of converting datatypes
 * between MATLAB and DIPlib, as well as the checking and error generating.
 */

#ifndef DML_MACROS_H
#define DML_MACROS_H

/***** Macros that check the number of arguments *****/

/* Generate an error if number of input arguments differ */
#define DML_CHK_NARGSIN(n) \
   if (nrhs != n) { \
      errorMessage=ERROR_NARGSIN; \
      goto dml_error; \
   }

/* Generate an error if number of output arguments differ. However, if
 * n==1 and there are 0 output arguments, it is OK, because there is
 * always the 'ans' variable to rely on. */
#define DML_CHK_NARGSOUT(n) \
   if (nlhs != n) { \
      if (!((nlhs == 0) && ((n == 1)||(n == 0)))) { \
         errorMessage=ERROR_NARGSOUT; \
         goto dml_error; \
      } \
   }

/***** Macros that check an input argument for certain type *****/

#define DML_IS_NULL(n) (mxIsEmpty (prhs[n]))

#define DML_IS_NULL_IMAGE(n) (dml_mxIsEmptyImage (prhs[n]))

#define DML_CHK_FLOAT(n) \
   if (!dml_mxIsScalar (prhs[n])) { \
      errorMessage = ERROR_NOTSCALAR; \
      errorArgument = n+1; \
      goto dml_error; \
   }

#define DML_CHK_INT(n) \
   if (!dml_mxIsIntScalar (prhs[n])) { \
      errorMessage = ERROR_NOTINTSCALAR; \
      errorArgument = n+1; \
      goto dml_error; \
   }

#define DML_CHK_COMPLEX(n) \
   if (!dml_mxIsComplexScalar (prhs[n])) { \
      errorMessage = ERROR_NOTCOMPLEXSCALAR; \
      errorArgument = n+1; \
      goto dml_error; \
   }

#define DML_CHK_BOOLEAN(n) \
   if (!dml_mxIsIntScalar (prhs[n])) { \
      errorMessage = ERROR_NOTBOOL; \
      errorArgument = n+1; \
      goto dml_error; \
   }

#define DML_CHK_FLOATARRAY(n) \
   if (!dml_mxIsVector (prhs[n])) { \
      errorMessage = ERROR_NOTVECTOR; \
      errorArgument = n+1; \
      goto dml_error; \
   }

#define DML_CHK_FLOATARRAY_E(n) \
   if (!DML_IS_NULL(n) && !dml_mxIsVector (prhs[n])) { \
      errorMessage = ERROR_NOTVECTOR; \
      errorArgument = n+1; \
      goto dml_error; \
   }

#define DML_CHK_INTEGERARRAY(n) \
   if (!dml_mxIsIntVector (prhs[n])) { \
      errorMessage = ERROR_NOTINTVECTOR; \
      errorArgument = n+1; \
      goto dml_error; \
   }

#define DML_CHK_COMPLEXARRAY(n) \
   if (!dml_mxIsComplexVector (prhs[n])) { \
      errorMessage = ERROR_NOTCOMPLEXVECTOR; \
      errorArgument = n+1; \
      goto dml_error; \
   }

#define DML_CHK_BOOLEANARRAY(n) \
   if (!dml_mxIsIntVector (prhs[n])) { \
      errorMessage = ERROR_NOTBOOLVECTOR; \
      errorArgument = n+1; \
      goto dml_error; \
   }

#define DML_CHK_STRING(n) \
   if (!dml_mxIsCharString (prhs[n])) { \
      errorMessage = ERROR_NOTSTRING; \
      errorArgument = n+1; \
      goto dml_error; \
   }

#define DML_CHK_STRINGARRAY(n) \
   if (!mxIsCell (prhs[n]) || (mxGetNumberOfDimensions (prhs[n]) > 2) || \
      ((mxGetM (prhs[n]) > 1) && (mxGetN (prhs[n]) > 1))) { \
      errorMessage = ERROR_NOTSTRINGARRAY; \
      errorArgument = n+1; \
      goto dml_error; \
   }

/***** Macros that check and convert the input arguments to DIPlib data ***/

#define DML_2DIP_FLOAT(n,f) \
   DML_CHK_FLOAT (n); \
   f = (dip_float)*(mxGetPr (prhs[n]))

#define DML_GENDIP_FLOAT(f) \
   f = 0

#define DML_2DIP_INT(n,i) \
   DML_CHK_INT (n); \
   i = (dip_int)*(mxGetPr (prhs[n]))

#define DML_2DIP_UINT(n,i) \
   DML_CHK_INT (n); \
   i = (dip_uint)*(mxGetPr (prhs[n]))

#define DML_2DIP_SINT32(n,i) \
   DML_CHK_INT (n); \
   i = (dip_sint32)*(mxGetPr (prhs[n]))

#define DML_2DIP_UINT32(n,i) \
   DML_CHK_INT (n); \
   i = (dip_uint32)*(mxGetPr (prhs[n]))

#define DML_2DIP_COMPLEX(n,c) \
   DML_CHK_COMPLEX (n); \
   c.re = (dip_dfloat)*(mxGetPr (prhs[n])); \
   if (mxIsComplex (prhs[n])) \
      c.im = (dip_dfloat)*(mxGetPi (prhs[n])); \
   else c.im = 0

#define DML_2DIP_BOOLEAN(n,b) \
   DML_CHK_BOOLEAN (n); \
   b = (*(mxGetPr (prhs[n]))==0)?DIP_FALSE:DIP_TRUE

#define DML_GENDIP_BOOLEAN(b) \
   b = 0

#define DML_2DIP_FLOATARRAY(n,fa) \
   DML_CHK_FLOATARRAY (n); \
   {  dip_int dml_intern_size = mxGetNumberOfElements (prhs[n]); \
      DMLXJ (dip_FloatArrayNew (&fa, dml_intern_size, 0.0, rg)); \
      if (dml_intern_size == 1) fa->array[0] = (dip_float)mxGetScalar(prhs[n]); \
      else { \
         dip_int dml_intern_i; \
         double* data = mxGetPr (prhs[n]); \
         for (dml_intern_i=0; dml_intern_i<dml_intern_size; dml_intern_i++) \
            fa->array[dml_intern_i] = (dip_float)*(data++); \
   }}

/* this one not used anywhere! */
#define DML_2DIP_FLOATARRAY_E(n,fa) \
   DML_CHK_FLOATARRAY_E (n); \
   {  dip_int dml_intern_size = mxGetNumberOfElements (prhs[n]); \
      DMLXJ (dip_FloatArrayNew (&fa, dml_intern_size, 0.0, rg)); \
      if (dml_intern_size == 1) fa->array[0] = (dip_float)mxGetScalar(prhs[n]); \
      else if (dml_intern_size != 0) { \
         dip_int dml_intern_i; \
         double* data = mxGetPr (prhs[n]); \
         for (dml_intern_i=0; dml_intern_i<dml_intern_size; dml_intern_i++) \
            fa->array[dml_intern_i] = (dip_float)*(data++); \
   }}

#define DML_2DIP_FLOATARRAY_OR_VOID(n,fa) \
   if ( DML_IS_NULL(n) ) { fa = 0; } \
   else { DML_2DIP_FLOATARRAY(n,fa); }

#define DML_GENDIP_FLOATARRAY(fa,im) \
   {  dip_int dml_intern_ndims; \
      DMLXJ (dip_ImageGetDimensionality (im, &dml_intern_ndims)); \
      if (dml_intern_ndims < 1) { \
         errorMessage = ERROR_ZERODIMIMAGE; \
         errorArgument = 1; \
         goto dml_error; \
      } DMLXJ (dip_FloatArrayNew (&fa, dml_intern_ndims, 0.0, rg)); \
   }

#define DML_2DIP_INTEGERARRAY(n,ia) \
   DML_CHK_INTEGERARRAY (n); \
   {  dip_int dml_intern_size = mxGetNumberOfElements (prhs[n]); \
      DMLXJ (dip_IntegerArrayNew (&ia, dml_intern_size, 0, rg)); \
      if (dml_intern_size == 1) ia->array[0] = (dip_int)mxGetScalar(prhs[n]); \
      else { \
         dip_int dml_intern_i; \
         double* data = mxGetPr (prhs[n]); \
         for (dml_intern_i=0; dml_intern_i<dml_intern_size; dml_intern_i++) \
            ia->array[dml_intern_i] = (dip_int)*(data++); \
   }}

#define DML_2DIP_INTEGERARRAY_OR_VOID(n,ia) \
   if ( DML_IS_NULL(n) ) { ia = 0; } \
   else { DML_2DIP_INTEGERARRAY(n,ia); }

#define DML_GENDIP_INTEGERARRAY(ia,im) \
   {  dip_int dml_intern_ndims; \
      DMLXJ (dip_ImageGetDimensionality (im, &dml_intern_ndims)); \
      if (dml_intern_ndims < 1) { \
         errorMessage = ERROR_ZERODIMIMAGE; \
         errorArgument = 1; \
         goto dml_error; \
      } DMLXJ (dip_IntegerArrayNew (&ia, dml_intern_ndims, 0, rg)); \
   }

#define DML_2DIP_COMPLEXARRAY(n,ca) \
   DML_CHK_COMPLEXARRAY (n); \
   {  dip_complex dml_intern_c; double* dml_intern_re, dml_intern_im; \
      dip_int dml_intern_size = mxGetNumberOfElements (prhs[n]); \
      dml_intern_c.re = 0; dml_intern_c.im = 0; \
      dml_intern_re = mxGetPr (prhs[n]); \
      dml_intern_im = mxGetPi (prhs[n]); \
      DMLXJ (dip_ComplexArrayNew (&ca, dml_intern_size, dml_intern_c, rg)); \
      if (dml_intern_size == 1) { \
         ca->array[0].re = (dip_dfloat)*(dml_intern_re); \
         if (dml_intern_im != NULL) \
            ca->array[0].im = (dip_dfloat)*(dml_intern_im); \
         else \
            ca->array[0].im = 0; \
      } else { \
         dip_int dml_intern_i; \
         for (dml_intern_i=0; dml_intern_i<dml_intern_size; dml_intern_i++) \
            ca->array[dml_intern_i].re = (dip_dfloat)*(dml_intern_re++); \
         if (dml_intern_im != NULL) \
            for (dml_intern_i=0; dml_intern_i<dml_intern_size; dml_intern_i++) \
               ca->array[dml_intern_i].im = (dip_dfloat)*(dml_intern_im++); \
         else \
            for (dml_intern_i=0; dml_intern_i<dml_intern_size; dml_intern_i++) \
               ca->array[dml_intern_i].im = 0; \
   }}

#define DML_2DIP_BOOLEANARRAY(n,ba) \
   DML_CHK_BOOLEANARRAY (n); \
   {  dip_int dml_intern_size = mxGetNumberOfElements (prhs[n]); \
      DMLXJ (dip_BooleanArrayNew (&ba, dml_intern_size, 0, rg)); \
      if (dml_intern_size == 1) ba->array[0] = (*(mxGetPr (prhs[n]))==0)?DIP_FALSE:DIP_TRUE; \
      else { \
         dip_int dml_intern_i; \
         double* dml_intern_data = mxGetPr (prhs[n]); \
         for (dml_intern_i=0; dml_intern_i<dml_intern_size; dml_intern_i++) \
            ba->array[dml_intern_i] = (dml_intern_data[dml_intern_i]==0)?DIP_FALSE:DIP_TRUE; \
   }}

#define DML_2DIP_BOOLEANARRAY_OR_VOID(n,ba) \
   if ( DML_IS_NULL(n) ) { ba = 0; } \
   else { DML_2DIP_BOOLEANARRAY(n,ba); }

#define DML_2DIP_BOUNDARYARRAY(n,bc) \
   DMLXJ (dml_2dip_boundaryarray (prhs[n], &bc, rg))

#define DML_2DIP_ENDUSER_FRIENDLY_BOUNDARYARRAY(n,bc,dm) \
   DMLXJ (dml_2dip_uf_boundaryarray (prhs[n], &bc, dm, rg))

#define DML_2MEX_BOUNDARYARRAY(bc,n) \
   DMLXJ (dml_2mex_boundaryarray (bc, &plhs[n]))

#define DML_2DIP_STRING(n,str) \
   DML_CHK_STRING (n); \
   {  dip_int dml_intern_length = mxGetNumberOfElements (prhs[n]) + 1; \
      DMLXJ (dip_StringNew (&str, dml_intern_length, NULL, rg)); \
      mxGetString (prhs[n], str->string, dml_intern_length); \
   }

#define DML_2DIP_STRINGARRAY(n,str) \
   DML_CHK_STRINGARRAY (n); \
   {  dip_int dml_intern_i, dml_intern_length; \
      dip_int dml_intern_size = mxGetNumberOfElements (prhs[n]); \
      DMLXJ ( dip_StringArrayNew( &str, dml_intern_size, 0, 0, rg)); \
      for (dml_intern_i=0; dml_intern_i<dml_intern_size; dml_intern_i++){ \
         mxArray *dml_intern_s = mxGetCell (prhs[n], dml_intern_i); \
         if (!dml_mxIsCharString (dml_intern_s)) { \
            errorMessage = ERROR_NOTSTRINGARRAY; \
            errorArgument = n+1; \
            goto dml_error; \
         } \
         dml_intern_length = mxGetNumberOfElements(dml_intern_s) + 1; \
         DMLXJ( dip_StringNew( &str->array[dml_intern_i], dml_intern_length, 0, rg )); \
         mxGetString (dml_intern_s, str->array[dml_intern_i]->string, dml_intern_length); \
   }}

/***** Macros that convert the DIPlib data to output arguments *****/

#define DML_2MEX_FLOAT(n,f) \
   plhs[n] = mxCreateDoubleMatrix (1, 1, mxREAL); \
   *(mxGetPr (plhs[n])) = (double)f

#define DML_2MEX_INT(n,i) \
   plhs[n] = mxCreateDoubleMatrix (1, 1, mxREAL); \
   *(mxGetPr (plhs[n])) = (double)i

#define DML_2MEX_BOOLEAN(n,b) \
   plhs[n] = mxCreateDoubleMatrix (1, 1, mxREAL); \
   *(mxGetPr (plhs[n])) = (double)b

#define DML_2MEX_COMPLEX(n,c) \
   plhs[n] = mxCreateDoubleMatrix (1, 1, mxCOMPLEX); \
   *(mxGetPr (plhs[n])) = (double)(c.re); \
   *(mxGetPi (plhs[n])) = (double)(c.im)

#define DML_2MEX_FLOATARRAY(n,fa) \
   plhs[n] = mxCreateDoubleMatrix (fa->size, 1, mxREAL); \
   {  dip_int dml_intern_i; double* dml_intern_data = mxGetPr (plhs[n]); \
      for (dml_intern_i=0; dml_intern_i<fa->size; dml_intern_i++) \
         dml_intern_data[dml_intern_i] = (double)fa->array[dml_intern_i]; \
   }

#define DML_2MEX_INTARRAY(n,ia) \
   plhs[n] = mxCreateDoubleMatrix (ia->size, 1, mxREAL); \
   {  dip_int dml_intern_i; double* dml_intern_data = mxGetPr (plhs[n]); \
      for (dml_intern_i=0; dml_intern_i<ia->size; dml_intern_i++) \
         dml_intern_data[dml_intern_i] = (double)ia->array[dml_intern_i]; \
   }

#define DML_2MEX_COMPLEXARRAY(n,ca) \
   plhs[n] = mxCreateDoubleMatrix (ca->size, 1, mxCOMPLEX); \
   {  dip_int dml_intern_i; double* dml_intern_datar; double* dml_intern_datai; \
      dml_intern_datar = mxGetPr (plhs[n]); \
      dml_intern_datai = mxGetPi (plhs[n]); \
      for (dml_intern_i=0; dml_intern_i<ca->size; dml_intern_i++) {\
         dml_intern_datar[dml_intern_i] = (double)ca->array[dml_intern_i].re; \
         dml_intern_datai[dml_intern_i] = (double)ca->array[dml_intern_i].im; \
   }}

/***** Working with the images *****/

#define DML_2DIP_IMAGE(n,im) \
   DMLXJ (dml_mex2dip (prhs[n], &im, rg))

#define DML_2DIP_MASKIMAGE(n,im) \
   if (DML_IS_NULL_IMAGE(n)) {im = NULL;} \
   else {DMLXJ (dml_mex2dip (prhs[n], &im, rg));}

#define DML_2DIP_IMAGE_OR_VOID(n,im) \
   if (DML_IS_NULL_IMAGE(n)) {im = NULL;} \
   else {DMLXJ (dml_mex2dip (prhs[n], &im, rg));}

#define DML_2DIP_IMAGE_COMPSEP(n,imr,imi) \
   DMLXJ (dml_mex2dip_compsep (prhs[n], &imr, &imi, rg))

#define DML_2DIP_IMAGEARRAY(n,ima) \
   DMLXJ (dml_mex2dipArray (prhs[n], &ima, rg))

#define DML_2DIP_IMAGEARRAY_OR_VOID(n,ima) \
   if (DML_IS_NULL_IMAGE(n)) {ima = NULL;} \
   else {DMLXJ (dml_mex2dipArray (prhs[n], &ima, rg));}

#define DML_GENDIP_IMAGE(im) \
   DMLXJ (dml_newdip (&im, rg))

#define DML_GENDIP_IMAGEARRAY(out,dims) \
   { dip_int dml_intern_ii; \
      DMLXJ (dip_ImageArrayNew (&out, dims, rg)); \
      for (dml_intern_ii = 0; dml_intern_ii < dims; dml_intern_ii++) { \
         DMLXJ (dml_newdip (&(out->array[dml_intern_ii]), rg)); \
   } }

#define DML_2MEX_IMAGE(n,im) \
   DMLXJ (dml_dip2mex (im, &plhs[n]))

#define DML_2MEX_IMAGE_AS_ARRAY(n,im) \
   DMLXJ (dml_dip2mla (im, &plhs[n]))

#define DML_2MEX_IMAGEARRAY(n,ima) \
   DMLXJ (dml_dip2mexArray (ima, &plhs[n]))

#define DML_2MEX_IMAGE_COMPSEP(n,imr,imi) \
   DMLXJ (dml_dip2mex_compsep (imr, imi, &plhs[n]))

/***** Working with the distribution *****/

#define DML_GENDIP_DISTRIBUTION(hi) \
   DMLXJ (dml_newdistribution (&hi, rg))

#define DML_2MEX_DISTRIBUTION(n,hi) \
   DMLXJ (dml_2mex_distribution (hi, &plhs[n]))

/***** Working with some other structures *****/

#define DML_2DIP_PHYSICALDIMENSIONS(n,pd) \
   if (DML_IS_NULL(n)) { pd = NULL; } \
   else { DMLXJ (dml_2dip_PhysicalDimensions (prhs[n], &pd, rg)); }

#define DML_2MEX_PHYSICALDIMENSIONS(n,pd) \
   DMLXJ (dml_2mex_PhysicalDimensions (pd, &plhs[n]))

/***** enumerated parameters are strings in MATLAB *****/

#define DML_2DIPF_CLIP(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "both")) s = DIP_CLIP_BOTH; \
      else if (!strcasecmp (dml_intern_string, "low")) s = DIP_CLIP_LOW; \
      else if (!strcasecmp (dml_intern_string, "high")) s = DIP_CLIP_HIGH; \
      else if (!strcasecmp (dml_intern_string, "thresh/range")) s = DIP_CLIP_THRESHOLD_AND_RANGE; \
      else if (!strcasecmp (dml_intern_string, "low/high")) s = DIP_CLIP_LOW_AND_HIGH_BOUNDS; \
      else { errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIP_DATATYPE(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "uint8")) s = DIP_DT_UINT8; \
      else if (!strcasecmp (dml_intern_string, "uint16")) s = DIP_DT_UINT16; \
      else if (!strcasecmp (dml_intern_string, "uint32")) s = DIP_DT_UINT32; \
      else if (!strcasecmp (dml_intern_string, "sint8")) s = DIP_DT_SINT8; \
      else if (!strcasecmp (dml_intern_string, "sint16")) s = DIP_DT_SINT16; \
      else if (!strcasecmp (dml_intern_string, "sint32")) s = DIP_DT_SINT32; \
      else if (!strcasecmp (dml_intern_string, "sfloat")) s = DIP_DT_SFLOAT; \
      else if (!strcasecmp (dml_intern_string, "dfloat")) s = DIP_DT_DFLOAT; \
      else if (!strcasecmp (dml_intern_string, "scomplex")) s = DIP_DT_SCOMPLEX; \
      else if (!strcasecmp (dml_intern_string, "dcomplex")) s = DIP_DT_DCOMPLEX; \
      else if (!strcasecmp (dml_intern_string, "bin")) s = DIP_DT_BINARY; \
      else if (!strcasecmp (dml_intern_string, "minimum")) s = DIP_DT_MINIMUM; \
      else if (!strcasecmp (dml_intern_string, "flex")) s = DIP_DT_FLEX; \
      else if (!strcasecmp (dml_intern_string, "flexbin")) s = DIP_DT_FLEXBIN; \
      else if (!strcasecmp (dml_intern_string, "dipimage")) s = DIP_DT_DIPIMAGE; \
      else { errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIP_DERIVATIVEFLAVOUR(n,s)  \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "iirgauss")) s = DIP_DF_IIRGAUSS; \
      else if (!strcasecmp (dml_intern_string, "gaussiir")) s = DIP_DF_IIRGAUSS; \
      else if (!strcasecmp (dml_intern_string, "firgauss")) s = DIP_DF_FIRGAUSS; \
      else if (!strcasecmp (dml_intern_string, "gaussfir")) s = DIP_DF_FIRGAUSS; \
      else if (!strcasecmp (dml_intern_string, "ftgauss")) s = DIP_DF_FTGAUSS; \
      else if (!strcasecmp (dml_intern_string, "gaussft")) s = DIP_DF_FTGAUSS; \
      else if (!strcasecmp (dml_intern_string, "finitediff")) s = DIP_DF_FINITEDIFF; \
      else { errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIP_SORTTYPE(n,s)  \
   if (DML_IS_NULL(n)) s = DIP_SORT_DEFAULT; \
   else { DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "default")) s = DIP_SORT_DEFAULT; \
      else if (!strcasecmp (dml_intern_string, "quicksort")) s = DIP_SORT_QUICK_SORT; \
      else if (!strcasecmp (dml_intern_string, "distributionsort")) s = DIP_SORT_DISTRIBUTION_SORT; \
      else if (!strcasecmp (dml_intern_string, "insertionsort")) s = DIP_SORT_INSERTION_SORT; \
      else if (!strcasecmp (dml_intern_string, "heapsort")) s = DIP_SORT_HEAP_SORT; \
      else { errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}}

#define DML_2DIP_FILTERSHAPE(n,s) \
   if (DML_IS_NULL(n)) s = DIP_FLT_SHAPE_DEFAULT; \
   else { DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "rectangular")) s = DIP_FLT_SHAPE_RECTANGULAR; \
      else if (!strcasecmp (dml_intern_string, "elliptic")) s = DIP_FLT_SHAPE_ELLIPTIC; \
      else if (!strcasecmp (dml_intern_string, "diamond")) s = DIP_FLT_SHAPE_DIAMOND; \
      else if (!strcasecmp (dml_intern_string, "parabolic")) s = DIP_FLT_SHAPE_PARABOLIC; \
      else if (!strcasecmp (dml_intern_string, "user_defined")) s = DIP_FLT_SHAPE_STRUCTURING_ELEMENT; \
      else if (!strcasecmp (dml_intern_string, "interpolated_line")) s = DIP_FLT_SHAPE_INTERPOLATED_LINE; \
      else if (!strcasecmp (dml_intern_string, "discrete_line")) s = DIP_FLT_SHAPE_DISCRETE_LINE; \
      else if (!strcasecmp (dml_intern_string, "periodic_line")) s = DIP_FLT_SHAPE_PERIODIC_LINE; \
      else if (!strcasecmp (dml_intern_string, "default")) s = DIP_FLT_SHAPE_DEFAULT; \
      else { errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}}

#define DML_2DIPF_FOURIERTRANSFORM(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "forward")) s = DIP_TR_FORWARD; \
      else if (!strcasecmp (dml_intern_string, "inverse")) s = DIP_TR_INVERSE; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIPF_IMAGERESTORATION(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "verbose")) s = DIP_RESTORATION_VERBOSE; \
      else if (!strcasecmp (dml_intern_string, "symmetric_psf")) s = DIP_RESTORATION_SYMMETRIC_PSF; \
      else if (!strcasecmp (dml_intern_string, "otf")) s = DIP_RESTORATION_OTF; \
      else if (!strcasecmp (dml_intern_string, "sieve")) s = DIP_RESTORATION_SIEVE; \
      else if (!strcasecmp (dml_intern_string, "normalize")) s = DIP_RESTORATION_NORMALIZE; \
      else if (!strcasecmp (dml_intern_string, "use_inputs")) s = DIP_RESTORATION_USE_INPUTS; \
      else { errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIPF_INTERPOLATION(n,s) \
   if (DML_IS_NULL(n)) s = DIP_INTERPOLATION_DEFAULT; \
   else { DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "default")) s = DIP_INTERPOLATION_DEFAULT; \
      else if (!strcasecmp (dml_intern_string, "bspline")) s = DIP_INTERPOLATION_BSPLINE; \
      else if (!strcasecmp (dml_intern_string, "4-cubic")) s = DIP_INTERPOLATION_FOURTH_ORDER_CUBIC; \
      else if (!strcasecmp (dml_intern_string, "3-cubic")) s = DIP_INTERPOLATION_THIRD_ORDER_CUBIC; \
      else if (!strcasecmp (dml_intern_string, "bilinear")) s = DIP_INTERPOLATION_LINEAR; \
      else if (!strcasecmp (dml_intern_string, "linear")) s = DIP_INTERPOLATION_LINEAR; \
      else if (!strcasecmp (dml_intern_string, "zoh")) s = DIP_INTERPOLATION_ZERO_ORDER_HOLD; \
      else if (!strcasecmp (dml_intern_string, "nn")) s = DIP_INTERPOLATION_NEAREST_NEIGHBOUR; \
      else if (!strcasecmp (dml_intern_string, "lanczos2")) s = DIP_INTERPOLATION_LANCZOS_2; \
      else if (!strcasecmp (dml_intern_string, "lanczos3")) s = DIP_INTERPOLATION_LANCZOS_3; \
      else if (!strcasecmp (dml_intern_string, "lanczos4")) s = DIP_INTERPOLATION_LANCZOS_4; \
      else if (!strcasecmp (dml_intern_string, "lanczos6")) s = DIP_INTERPOLATION_LANCZOS_6; \
      else if (!strcasecmp (dml_intern_string, "lanczos8")) s = DIP_INTERPOLATION_LANCZOS_8; \
      else { errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}}

#define DML_2DIPF_SUBPIXELEXTREMUMMETHOD(n,s) \
   if (DML_IS_NULL(n)) s = DIP_SEM_DEFAULT; \
   else { DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "default")) s = DIP_SEM_DEFAULT; \
      else if (!strcasecmp (dml_intern_string, "linear")) s = DIP_SEM_LINEAR; \
      else if (!strcasecmp (dml_intern_string, "parabolic")) s = DIP_SEM_PARABOLIC_SEPARABLE; \
      else if (!strcasecmp (dml_intern_string, "gaussian")) s = DIP_SEM_GAUSSIAN_SEPARABLE; \
      else if (!strcasecmp (dml_intern_string, "bspline")) s = DIP_SEM_BSPLINE; \
      else if (!strcasecmp (dml_intern_string, "parabolic_nonseparable")) s = DIP_SEM_PARABOLIC; \
      else if (!strcasecmp (dml_intern_string, "gaussian_nonseparable")) s = DIP_SEM_GAUSSIAN; \
      else { errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}}

#define DML_2DIPF_SUBPIXELEXTREMUMPOLARITY(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "maximum")) s = DIP_SEP_MAXIMUM; \
      else if (!strcasecmp (dml_intern_string, "minimum")) s = DIP_SEP_MINIMUM; \
      else { errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIP_MPHEDGETYPE(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "texture")) s = DIP_MPH_TEXTURE; \
      else if (!strcasecmp (dml_intern_string, "object")) s = DIP_MPH_OBJECT; \
      else if (!strcasecmp (dml_intern_string, "both")) s = DIP_MPH_BOTH; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIP_MPHTOPHATPOLARITY(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "black")) s = DIP_MPH_BLACK; \
      else if (!strcasecmp (dml_intern_string, "white")) s = DIP_MPH_WHITE; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIPF_MPHSMOOTHING(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "open/close")) s = DIP_MPH_OPEN_CLOSE; \
      else if (!strcasecmp (dml_intern_string, "close/open")) s = DIP_MPH_CLOSE_OPEN; \
      else if (!strcasecmp (dml_intern_string, "average")) s = DIP_MPH_AVERAGE; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIPF_LEESIGN(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "unsigned")) s = DIP_LEE_UNSIGNED; \
      else if (!strcasecmp (dml_intern_string, "signed")) s = DIP_LEE_SIGNED; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIP_GRADIENTDIRECTIONATANFLAVOUR(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "half_circle")) s = DIP_HALF_CIRCLE; \
      else if (!strcasecmp (dml_intern_string, "full_circle")) s = DIP_FULL_CIRCLE; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIPF_TESTOBJECT(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "ellipsoid")) s = DIP_TEST_OBJECT_ELLIPSOID; \
      else if (!strcasecmp (dml_intern_string, "box")) s = DIP_TEST_OBJECT_BOX; \
      else if (!strcasecmp (dml_intern_string, "ellipsoidshell")) s = DIP_TEST_OBJECT_ELLIPSOID_SHELL; \
      else if (!strcasecmp (dml_intern_string, "boxshell")) s = DIP_TEST_OBJECT_BOX_SHELL; \
      else if (!strcasecmp (dml_intern_string, "user_supplied")) s = DIP_TEST_OBJECT_USER_SUPPLIED; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIPF_TESTPSF(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "gaussian")) s = DIP_TEST_PSF_GAUSSIAN; \
      else if (!strcasecmp (dml_intern_string, "incoherent_otf")) s = DIP_TEST_PSF_INCOHERENT_OTF; \
      else if (!strcasecmp (dml_intern_string, "user_supplied")) s = DIP_TEST_PSF_USER_SUPPLIED; \
      else if (!strcasecmp (dml_intern_string, "none")) s = DIP_TEST_PSF_NONE; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIPF_INCOHERENTOTF(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "stokseth")) s = DIP_MICROSCOPY_OTF_STOKSETH; \
      else if (!strcasecmp (dml_intern_string, "hopkins")) s = DIP_MICROSCOPY_OTF_HOPKINS; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIPF_EXPFITDATA(n,s) \
   if (DML_IS_NULL(n)) s = DIP_ATTENUATION_EXP_FIT_DATA_DEFAULT; \
   else { DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "default")) s = DIP_ATTENUATION_EXP_FIT_DATA_DEFAULT; \
      else if (!strcasecmp (dml_intern_string, "mean")) s = DIP_ATTENUATION_EXP_FIT_DATA_MEAN; \
      else if (!strcasecmp (dml_intern_string, "percentile")) s = DIP_ATTENUATION_EXP_FIT_DATA_PERCENTILE; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}}

#define DML_2DIPF_EXPFITSTART(n,s) \
   if (DML_IS_NULL(n)) s = DIP_ATTENUATION_EXP_FIT_START_DEFAULT; \
   else { DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "default")) s = DIP_ATTENUATION_EXP_FIT_START_DEFAULT; \
      else if (!strcasecmp (dml_intern_string, "firstpixel")) s = DIP_ATTENUATION_EXP_FIT_START_FIRST_PIXEL; \
      else if (!strcasecmp (dml_intern_string, "globalmax")) s = DIP_ATTENUATION_EXP_FIT_START_GLOBAL_MAXIMUM; \
      else if (!strcasecmp (dml_intern_string, "firstmax")) s = DIP_ATTENUATION_EXP_FIT_START_FIRST_MAXIMUM; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}}

#define DML_2DIPF_ATTENUATIONCORRECTION(n,s) \
   if (DML_IS_NULL(n)) s = DIP_ATTENUATION_DEFAULT; \
   else { DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "lt2")) s = DIP_ATTENUATION_RAC_LT2; \
      else if (!strcasecmp (dml_intern_string, "lt1")) s = DIP_ATTENUATION_RAC_LT1; \
      else if (!strcasecmp (dml_intern_string, "det")) s = DIP_ATTENUATION_RAC_DET; \
      else if (!strcasecmp (dml_intern_string, "default")) s = DIP_ATTENUATION_DEFAULT; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}}

#define DML_2DIP_ENDPIXELCONDITION(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "looseendsaway")) s = DIP_ENDPIXEL_CONDITION_LOOSE_ENDS_AWAY; \
      else if (!strcasecmp (dml_intern_string, "natural")) s = DIP_ENDPIXEL_CONDITION_NATURAL; \
      else if (!strcasecmp (dml_intern_string, "1neighbor")) s = DIP_ENDPIXEL_CONDITION_KEEP_WITH_ONE_NEIGHBOR; \
      else if (!strcasecmp (dml_intern_string, "2neighbors")) s = DIP_ENDPIXEL_CONDITION_KEEP_WITH_TWO_NEIGHBORS; \
      else if (!strcasecmp (dml_intern_string, "3neighbors")) s = DIP_ENDPIXEL_CONDITION_KEEP_WITH_THREE_NEIGHBORS; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}


#define DML_2DIPF_CONTRASTSTRETCH(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "linear")) s = DIP_CST_LINEAR; \
      else if (!strcasecmp (dml_intern_string, "slinear")) s = DIP_CST_SIGNED_LINEAR; \
      else if (!strcasecmp (dml_intern_string, "logarithmic")) s = DIP_CST_LOGARITHMIC; \
      else if (!strcasecmp (dml_intern_string, "slogarithmic")) s = DIP_CST_SIGNED_LOGARITHMIC; \
      else if (!strcasecmp (dml_intern_string, "erf")) s = DIP_CST_ERF; \
      else if (!strcasecmp (dml_intern_string, "decade")) s = DIP_CST_DECADE; \
      else if (!strcasecmp (dml_intern_string, "sigmoid")) s = DIP_CST_SIGMOID; \
      else if (!strcasecmp (dml_intern_string, "clip")) s = DIP_CST_CLIP; \
      else if (!strcasecmp (dml_intern_string, "01")) s = DIP_CST_01; \
      else if (!strcasecmp (dml_intern_string, "pi")) s = DIP_CST_PI; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIPF_IMAGEREPRESENTATION(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "spatial")) s = DIP_IMAGE_REPRESENTATION_SPATIAL; \
      else if (!strcasecmp (dml_intern_string, "spectral")) s = DIP_IMAGE_REPRESENTATION_SPECTRAL; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIPF_FINITEDIFFERENCE(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "m101")) s = DIP_FINITE_DIFFERENCE_M101; \
      else if (!strcasecmp (dml_intern_string, "0m11")) s = DIP_FINITE_DIFFERENCE_0M11; \
      else if (!strcasecmp (dml_intern_string, "m110")) s = DIP_FINITE_DIFFERENCE_M110; \
      else if (!strcasecmp (dml_intern_string, "1m21")) s = DIP_FINITE_DIFFERENCE_1M21; \
      else if (!strcasecmp (dml_intern_string, "121")) s = DIP_FINITE_DIFFERENCE_121; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIPF_DISTANCETRANSFORM(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "fast")) s = DIP_DISTANCE_EDT_FAST; \
      else if (!strcasecmp (dml_intern_string, "ties")) s = DIP_DISTANCE_EDT_TIES; \
      else if (!strcasecmp (dml_intern_string, "true")) s = DIP_DISTANCE_EDT_TRUE; \
      else if (!strcasecmp (dml_intern_string, "bruteforce")) s = DIP_DISTANCE_EDT_BRUTE_FORCE; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIPF_REGULARIZATIONPARAMETER(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "manual")) s = DIP_RESTORATION_REG_PAR_MANUAL; \
      else if (!strcasecmp (dml_intern_string, "gcv")) s = DIP_RESTORATION_REG_PAR_GCV; \
      else if (!strcasecmp (dml_intern_string, "cls")) s = DIP_RESTORATION_REG_PAR_CLS; \
      else if (!strcasecmp (dml_intern_string, "snr")) s = DIP_RESTORATION_REG_PAR_SNR; \
      else if (!strcasecmp (dml_intern_string, "edf")) s = DIP_RESTORATION_REG_PAR_EDF; \
      else if (!strcasecmp (dml_intern_string, "ml")) s = DIP_RESTORATION_REG_PAR_ML; \
      else if (!strcasecmp (dml_intern_string, "edf_cv")) s = DIP_RESTORATION_REG_PAR_EDF_CV; \
      else if (!strcasecmp (dml_intern_string, "cls_cv")) s = DIP_RESTORATION_REG_PAR_CLS_CV; \
      else if (!strcasecmp (dml_intern_string, "snr_cv")) s = DIP_RESTORATION_REG_PAR_SNR_CV; \
      else if (!strcasecmp (dml_intern_string, "variance_cv")) s = DIP_RESTORATION_VARIANCE_CV; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#define DML_2DIPF_FINDSHIFTMETHOD(n,s) \
   if (DML_IS_NULL(n)) s = DIP_FSM_DEFAULT; \
   else { DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "default")) s = DIP_FSM_DEFAULT; \
      else if (!strcasecmp (dml_intern_string, "integer")) s = DIP_FSM_INTEGER_ONLY; \
      else if (!strcasecmp (dml_intern_string, "cpf")) s = DIP_FSM_CPF; \
      else if (!strcasecmp (dml_intern_string, "ffts")) s = DIP_FSM_FFTS; \
      else if (!strcasecmp (dml_intern_string, "mts")) s = DIP_FSM_MTS; \
      else if (!strcasecmp (dml_intern_string, "grs")) s = DIP_FSM_GRS; \
      else if (!strcasecmp (dml_intern_string, "iter")) s = DIP_FSM_ITER; \
      else if (!strcasecmp (dml_intern_string, "proj")) s = DIP_FSM_PROJ; \
      else if (!strcasecmp (dml_intern_string, "ncc")) s = DIP_FSM_NCC; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}}

#define DML_2DIPF_CORRELATION_ESTIMATOR(n,s) \
   if (DML_IS_NULL(n)) s = DIP_CORRELATION_ESTIMATOR_DEFAULT; \
   else { DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "random")) s = DIP_CORRELATION_ESTIMATOR_RANDOM; \
      else if (!strcasecmp (dml_intern_string, "grid")) s = DIP_CORRELATION_ESTIMATOR_GRID; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}}

#define DML_2DIPF_CORRELATION_NORMALISATION(n,s) \
   if (DML_IS_NULL(n)) s = DIP_CORRELATION_NORMALISATION_NONE; \
   else { DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "none")) s = DIP_CORRELATION_NORMALISATION_NONE; \
      else if(!strcasecmp (dml_intern_string, "volume_fraction")) s = DIP_CORRELATION_NORMALISATION_VOLUME_FRACTION; \
      else if (!strcasecmp (dml_intern_string, "volume_fraction^2")) s = DIP_CORRELATION_NORMALISATION_VOLUME_FRACTION_SQUARE; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}}

#define DML_2DIP_BACKGROUNDVALUE(n,s) \
   if (DML_IS_NULL(n)) s = DIP_BGV_DEFAULT; \
   else { DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "default")) s = DIP_BGV_DEFAULT; \
      else if (!strcasecmp (dml_intern_string, "zero")) s = DIP_BGV_ZERO; \
      else if (!strcasecmp (dml_intern_string, "max")) s = DIP_BGV_MAX_VALUE; \
      else if (!strcasecmp (dml_intern_string, "min")) s = DIP_BGV_MIN_VALUE; \
      else if (!strcasecmp (dml_intern_string, "manual")) s = DIP_BGV_MANUAL; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}}

#define DML_2DIPIO_PHOTOMETRICINTERPRETATION(n,s) \
   if (DML_IS_NULL(n)) s = DIPIO_PHM_DEFAULT; \
   else { DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "grayvalue")) s = DIPIO_PHM_GREYVALUE; \
      else if (!strcasecmp (dml_intern_string, "gray")) s = DIPIO_PHM_GREYVALUE; \
      else if (!strcasecmp (dml_intern_string, "grey")) s = DIPIO_PHM_GREYVALUE; \
      else if (!strcasecmp (dml_intern_string, "RGB")) s = DIPIO_PHM_RGB; \
      else if (!strcasecmp (dml_intern_string, "L*a*b*")) s = DIPIO_PHM_CIELAB; \
      else if (!strcasecmp (dml_intern_string, "CIElab")) s = DIPIO_PHM_CIELAB; \
      else if (!strcasecmp (dml_intern_string, "Lab")) s = DIPIO_PHM_CIELAB; \
      else if (!strcasecmp (dml_intern_string, "L*u*v*")) s = DIPIO_PHM_CIELUV; \
      else if (!strcasecmp (dml_intern_string, "CIEluv")) s = DIPIO_PHM_CIELUV; \
      else if (!strcasecmp (dml_intern_string, "Luv")) s = DIPIO_PHM_CIELUV; \
      else if (!strcasecmp (dml_intern_string, "CMYK")) s = DIPIO_PHM_CMYK; \
      else if (!strcasecmp (dml_intern_string, "CMY")) s = DIPIO_PHM_CMY; \
      else if (!strcasecmp (dml_intern_string, "XYZ")) s = DIPIO_PHM_CIEXYZ; \
      else if (!strcasecmp (dml_intern_string, "Yxy")) s = DIPIO_PHM_CIEYXY; \
      else if (!strcasecmp (dml_intern_string, "HCV")) s = DIPIO_PHM_HCV; \
      else if (!strcasecmp (dml_intern_string, "HSV")) s = DIPIO_PHM_HSV; \
      else if (!strcasecmp (dml_intern_string, "R'G'B'")) s = DIPIO_PHM_RGB_NONLINEAR; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}}

#define DML_2MEX_PHOTOMETRICINTERPRETATION(n,s) \
   if (s == DIPIO_PHM_GREYVALUE) plhs[n] = mxCreateString("gray"); \
   else if (s == DIPIO_PHM_RGB) plhs[n] = mxCreateString("RGB"); \
   else if (s == DIPIO_PHM_CIELAB) plhs[n] = mxCreateString("L*a*b*"); \
   else if (s == DIPIO_PHM_CIELUV) plhs[n] = mxCreateString("L*u*v*"); \
   else if (s == DIPIO_PHM_CMYK) plhs[n] = mxCreateString("CMYK"); \
   else if (s == DIPIO_PHM_CMY) plhs[n] = mxCreateString("CMY"); \
   else if (s == DIPIO_PHM_CIEXYZ) plhs[n] = mxCreateString("XYZ"); \
   else if (s == DIPIO_PHM_CIEYXY) plhs[n] = mxCreateString("Yxy"); \
   else if (s == DIPIO_PHM_HCV) plhs[n] = mxCreateString("HCV"); \
   else if (s == DIPIO_PHM_HSV) plhs[n] = mxCreateString("HSV"); \
   else if (s == DIPIO_PHM_RGB_NONLINEAR) plhs[n] = mxCreateString("R'G'B'"); \
   else { \
      plhs[n] = mxCreateString(""); \
   }

#define DML_2DIPIO_COMPRESSIONMETHOD(n,s) \
   if (DML_IS_NULL(n)) s = DIPIO_CMP_DEFAULT; \
   else { DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "none")) s = DIPIO_CMP_NONE; \
      else if (!strcasecmp (dml_intern_string, "ZIP")) s = DIPIO_CMP_LZW; \
      else if (!strcasecmp (dml_intern_string, "GZIP")) s = DIPIO_CMP_LZW; \
      else if (!strcasecmp (dml_intern_string, "LZW")) s = DIPIO_CMP_LZW; \
      else if (!strcasecmp (dml_intern_string, "Compress")) s = DIPIO_CMP_COMPRESS; \
      else if (!strcasecmp (dml_intern_string, "PackBits")) s = DIPIO_CMP_PACKBITS; \
      else if (!strcasecmp (dml_intern_string, "Thunderscan")) s = DIPIO_CMP_THUNDERSCAN; \
      else if (!strcasecmp (dml_intern_string, "NEXT")) s = DIPIO_CMP_NEXT; \
      else if (!strcasecmp (dml_intern_string, "CCITTRLE")) s = DIPIO_CMP_CCITTRLE; \
      else if (!strcasecmp (dml_intern_string, "CCITTRLEW")) s = DIPIO_CMP_CCITTRLEW; \
      else if (!strcasecmp (dml_intern_string, "CCITTFAX3")) s = DIPIO_CMP_CCITTFAX3; \
      else if (!strcasecmp (dml_intern_string, "CCITTFAX4")) s = DIPIO_CMP_CCITTFAX4; \
      else if (!strcasecmp (dml_intern_string, "deflate")) s = DIPIO_CMP_DEFLATE; \
      else if (!strcasecmp (dml_intern_string, "JPEG")) s = DIPIO_CMP_JPEG; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}}

#define DML_2DIPF_GREYVALUESORTORDER(n,s) \
   DML_CHK_STRING(n); \
   {  char dml_intern_string[DML_FEATURE_NAME_LENGTH]; \
      mxGetString (prhs[n], dml_intern_string, DML_FEATURE_NAME_LENGTH); \
      if (!strcasecmp (dml_intern_string, "low_first")) s = DIP_GVSO_LOW_FIRST; \
      else if (!strcasecmp (dml_intern_string, "high_first")) s = DIP_GVSO_HIGH_FIRST; \
      else { \
         errorMessage = ERROR_NOTVALIDSTRING; errorArgument = n+1; \
         goto dml_error; \
   }}

#endif /* ifndef DML_MACROS_H */
