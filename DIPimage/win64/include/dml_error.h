/*
 * Filename: dml_error.h
 * Interface between MATLAB and DIPlib
 *
 * (C) Copyright 1999-2001               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Cris Luengo, February-March 1999.
 * April 2001: Not copying image data anymore.
 *
 * Error handling.
 */

/*********** The basic DIPlib interface function looks like this: ************\

void mexFunction (int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[]) {

   type1 arg1;
   type2 arg2;
   ...

   DML_ERROR_INIT;

   DML_CHK_NARGSIN (n_in);
   DML_CHK_NARGSOUT (n_out);

   DML_2DIP_type1 (0, arg1);
   DML_2DIP_type2 (1, arg2);
   ...

   DMLXJ ( dip_function (arg1, arg2, ...) );

   DML_2MEX_type1 (n, arg1);
   ...

dml_error:
   DML_ERROR_EXIT;
}

\*****************************************************************************/

#ifndef DML_ERROR_H
#define DML_ERROR_H

#define DML_ERROR_INIT \
   dip_Error error = 0, *errorNext=&error; \
   dip_Resources rg = 0; \
   char* errorMessage = 0; \
   dip_int errorArgument = 0; \
   DMLXJ (dip_ResourcesNew (&rg, 0))

#define DML_ERROR_EXIT \
   if ((*errorNext = dip_ResourcesFree (&rg))!=0)\
      errorNext = &((*errorNext)->next); \
   if (error) { \
      mexErrMsgTxt (dml_PrintErrorStruct (error, NULL, 0)); \
      dip_ErrorFree (error); \
   } else if (errorMessage) { \
      if (errorArgument) { \
         char msg[1000]; \
         sprintf (msg, errorMessage, errorArgument); \
         mexErrMsgTxt (msg); \
      } else mexErrMsgTxt (errorMessage); \
   } else return

/*
 * The following are variations of DML_ERROR_INIT and DML_ERROR_EXIT
 * for use by people mainly coding straight mex files, but calling
 * the occasional DIPlib function.
 */

#define DML_ERROR_DECLARE \
   dip_Error error = 0, *errorNext=&error; \
   dip_Resources rg = 0; \
   char* errorMessage = 0; \
   dip_int errorArgument = 0;

#define DML_ERROR_START \
   error = 0; \
   *errorNext=&error; \
   errorMessage = 0; \
   errorArgument = 0; \
   DMLXJ (dip_ResourcesNew (&rg, 0))

#define DML_ERROR_FINISH \
   if ((*errorNext = dip_ResourcesFree (&rg))!=0)\
      errorNext = &((*errorNext)->next); \
   if (error) { \
      mexErrMsgTxt (dml_PrintErrorStruct (error, NULL, 0)); \
      dip_ErrorFree (error); \
   } else if (errorMessage) { \
      if (errorArgument) { \
         char msg[1000]; \
         sprintf (msg, errorMessage, errorArgument); \
         mexErrMsgTxt (msg); \
      } else mexErrMsgTxt (errorMessage); \
   }

#define DMLXJ(function) \
   if ((*errorNext = function)!=0) { \
      errorNext = &((*errorNext)->next); \
      goto dml_error; \
   }

#define DMLSJ(message) \
   errorMessage = message; \
   goto dml_error

/* Define error messages */
#define ERROR_NARGSIN "Wrong number of input arguments."
#define ERROR_NARGSOUT "Wrong number of output arguments."

#define ERROR_NOTVECTOR "Argument %d should be a real vector."
#define ERROR_NOTINTVECTOR "Argument %d should be a integer vector."
#define ERROR_NOTCOMPLEXVECTOR "Argument %d should be a complex vector."
#define ERROR_NOTBOOLVECTOR "Argument %d should be a boolean vector."
#define ERROR_NOTSCALAR "Argument %d should be a real scalar."
#define ERROR_NOTINTSCALAR "Argument %d should be an integer scalar."
#define ERROR_NOTCOMPLEXSCALAR "Argument %d should be a complex scalar."
#define ERROR_NOTBOOL "Argument %d should be a boolean."
#define ERROR_NOTSTRING "Argument %d should be a string."
#define ERROR_NOTSTRINGARRAY "Argument %d should be a cell array with strings."
#define ERROR_NOTVALIDSTRING "Argument %d is invalid string."
#define ERROR_NOTIMAGE "Argument %d should be a dip_image."
#define ERROR_ZERODIMIMAGE "Argument %d should have more than zero dimensions."

#endif /* ifndef DML_ERROR_H */

