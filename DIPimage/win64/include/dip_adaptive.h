/*
 * Filename: dip_adaptive.h
 *
 * author: Bernd Rieger
 * ported code from Peter Bakker
 */

#ifndef PBADAP_H
#define PBADAP_H


#include "dip_manipulation.h"
#include "dip_linear.h"
#include "dip_iir.h"
#include "dip_interpolation.h"


/***************************************************************
 *
 * enums & defines
 *
 ***************************************************************/

#define PBAW_MAXDIM    4
#define PB_MAXDIM 4

enum btypes { PBAW_GB_ZERO = 0, PBAW_GB_MIRROR, PBAW_GB_CLIP,
              PBAW_GB_MAX };

enum itypes { PBAW_IP_ZOH = 0, PBAW_IP_FOH = 1, PBAW_IP_BSPLINE = 2 };

enum ttypes { PBAW_TR_ORIENTATION = 1, PBAW_TR_CURVATURE = 2,
              PBAW_TR_SCALE = 4, PBAW_TR_SKEW = 8 };

enum ftypes { PBAF_NONE, PBAF_UNIFORM, PBAF_GAUSS, PBAF_PERC, PBAF_LUGAUSS };

/* handy combinations */
#define PBAW_TR_NONE            0
#define PBAW_TR_ELLIPS          PBAW_TR_ORIENTATION
#define PBAW_TR_ELLIPSX         (PBAW_TR_ORIENTATION|PBAW_TR_SCALE)
#define PBAW_TR_BANANA          (PBAW_TR_ORIENTATION|PBAW_TR_CURVATURE)
#define PBAW_TR_BANANAX         (PBAW_TR_ORIENTATION|PBAW_TR_CURVATURE|PBAW_TR_SCALE)
#define PBAW_TR_KUWAHARA        PBAW_TR_EDGEPRESERVE

#define PBAF_MAXSTEP   11



/***************************************************************
 *
 * Data Types
 *
 ***************************************************************/
struct _dip_AdaptiveWindow;

typedef struct
{
   dip_int  type;
   dip_int  dim;
   dip_int *size;
   dip_float truncation;
   dip_sfloat perc; /* added for pecentile filtering*/
   dip_Error (*func) (struct _dip_AdaptiveWindow *);
   void *data;

} dip_AdaptiveFilter;


typedef struct
{
   /* types */
   dip_int      transformtype;
   dip_int      boundarytype;
   dip_int      interpolationtype;
   dip_AdaptiveFilter *filter;

   /* the dip_Images */
   dip_Image    in;
   dip_Image    mask;
   dip_Image    out;
   dip_ImageArray    param;
   dip_int      nparam;



} dip_AdaptiveStruct;/*ScilInput*/


typedef struct _dip_AdaptiveWindow
{
   /* types */
   dip_int      transformtype;
   dip_int      boundarytype;
   dip_int      interpolationtype;
   dip_AdaptiveFilter *filter;

   /* spatial order */
   dip_int  indim;
   dip_int *insize;
   dip_int  wdim;
   dip_int *wsize;

   /* window info */
   dip_int *wcenter;
   dip_int  wnpix;
   dip_float *wscale;   /* LUGAUSS only: how coordinate is shrinked */

   /* current parameter values */
   void        *pos;
   dip_int      nparam;
   dip_dfloat  *param;

   /* Image pointers + Stride information*/
   dip_sfloat   *pin;
   dip_sfloat   *pmask;
   dip_sfloat  **pparam;
   dip_sfloat   *pout;
   dip_IntegerArray  instride;
   dip_IntegerArray  maskstride;
   dip_IntegerArray *paramstride;
   dip_IntegerArray  outstride;

   /* window pointers */
   dip_dfloat  *pwin;
   dip_dfloat  *pftr;   /* to hold lookup gaussian kernel */
   dip_dfloat **ptrans;

   /* function pointers */
   void (*transformfunc)(struct _dip_AdaptiveWindow *);
   void (*boundaryfunc) (struct _dip_AdaptiveWindow *);
   void (*geometryfunc) (struct _dip_AdaptiveWindow *);
   /*void  (*filterfunc)  (struct _dip_AdaptiveWindow *);*/
   dip_Error  (*filterfunc)  (struct _dip_AdaptiveWindow *);

} dip_AdaptiveWindow;



void dip__AdaptiveTransform_zero  ( dip_AdaptiveWindow * );
void dip__AdaptiveTransform_mirror  ( dip_AdaptiveWindow * );
void dip__AdaptiveTransform_2Dfoh   ( dip_AdaptiveWindow * );
void dip__AdaptiveTransform_2Dbspline( dip_AdaptiveWindow * );
void dip__AdaptiveTransform_3Dfoh   ( dip_AdaptiveWindow * );
void dip__AdaptiveTransform_3Dzoh   ( dip_AdaptiveWindow * );
void dip__AdaptiveTransform_2Dnone  ( dip_AdaptiveWindow * );
void dip__AdaptiveTransform_2Dxvec  ( dip_AdaptiveWindow * );
void dip__AdaptiveTransform_2Dellipsx( dip_AdaptiveWindow * );
void dip__AdaptiveTransform_2Dbanana ( dip_AdaptiveWindow *);
void dip__AdaptiveTransform_2Dbananax( dip_AdaptiveWindow *);
void dip__AdaptiveTransform_2Dskew  ( dip_AdaptiveWindow * );
void dip__AdaptiveTransform_3Dnone  ( dip_AdaptiveWindow * );
void dip__AdaptiveTransform_3Dzvec  ( dip_AdaptiveWindow * );
void dip__AdaptiveTransform_3Dxyvec ( dip_AdaptiveWindow * );

void dip__m4x4_Null     ( dip_dfloat *);
void dip__m4x4_Identity ( dip_dfloat *);
void dip__v3_SphereCoord( dip_dfloat *, dip_dfloat , dip_dfloat, dip_dfloat);
void dip__v3_CrossProd  ( dip_dfloat *, dip_dfloat *, dip_dfloat *);
void dip__m4x4_TransformFromBasis ( dip_dfloat *, dip_dfloat *,
   dip_dfloat *, dip_dfloat *);
DIP_ERROR dip__m4x4_Invert3  (dip_dfloat *, dip_dfloat *);

DIP_ERROR dip_AdaptiveFiltering ( dip_AdaptiveStruct *);
DIP_ERROR dip_AdaptiveWindowNew ( dip_AdaptiveWindow *, dip_int, dip_int,
   dip_int *, dip_int, dip_Resources);
DIP_ERROR dip__AdaptiveFilteringLoop( dip_AdaptiveWindow *);
DIP_ERROR dip__PrepareAdaptiveFiltering ( dip_AdaptiveWindow *,
   dip_AdaptiveStruct *, dip_Resources);
DIP_ERROR dip_AdaptiveFilterSelectFuncs ( dip_AdaptiveWindow *);

DIP_ERROR dip_InitialiseAdaptiveGauss( dip_AdaptiveFilter *, dip_int,
   dip_dfloat *, dip_IntegerArray, dip_float, dip_IntegerArray, dip_Resources );
DIP_ERROR dip__AdaptiveGauss( dip_dfloat **, dip_int, dip_int *, dip_dfloat *,
   dip_IntegerArray, dip_float, dip_IntegerArray, dip_Resources );
void dip__InitAdaptiveFilter( dip_AdaptiveStruct *);
DIP_ERROR dip__PrintWindow( dip_AdaptiveWindow);
DIP_ERROR dip__PrintFilter( dip_AdaptiveFilter);
DIP_ERROR dip__PrintStruct( dip_AdaptiveStruct);

DIP_ERROR dip__Inproduct( dip_AdaptiveWindow *);
DIP_ERROR dip__Percentile ( dip_AdaptiveWindow *);

DIP_ERROR dip_AdaptiveGauss( dip_Image, dip_Image, dip_ImageArray,
    dip_FloatArray, dip_IntegerArray, dip_int, dip_IntegerArray);
DIP_ERROR dip_AdaptiveBanana( dip_Image, dip_Image, dip_ImageArray,
    dip_ImageArray, dip_FloatArray, dip_IntegerArray, dip_int, dip_IntegerArray);
DIP_ERROR dip_StructureAdaptiveGauss( dip_Image, dip_Image, dip_ImageArray,
    dip_IntegerArray, dip_int, dip_IntegerArray, dipf_Interpolation);
DIP_ERROR dip_AdaptivePercentile( dip_Image, dip_Image, dip_ImageArray,
    dip_IntegerArray, dip_float);
DIP_ERROR dip_AdaptivePercentileBanana( dip_Image, dip_Image,
   dip_ImageArray, dip_ImageArray, dip_IntegerArray, dip_float);
#endif /* PBADAP_H */
