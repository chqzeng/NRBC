/*
 * Filename: dip_math.h
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
 * This file include the system's <math.h> and fixes some of its deficiencies
 *
 * AUTHOR
 *    Michael van Ginkel
 *
 * HISTORY
 *    8 November 1995     - MvG - created
 */

#ifndef DIP_TPI_INC

#ifndef DIP_MATH_H
#define DIP_MATH_H
#ifdef __cplusplus
extern "C" {
#endif

/*
 * MvG - 31-08-1999 - *grumble* Damn it, C leaves the definition of
 * y%x to the implementor when y<0. Luckily: y%x = (y-y*x)%x = (y(1-x))%x.
 * No reason for ambiguity.
 */

#define DIPM_IQ_PERIODIC( yy, xx ) \
   (((yy)>=0) ? ((yy)/(xx)) : (-(((xx)-(yy)-1)/(xx))))

#define DIPM_IR_PERIODIC( yy, xx ) \
   (((yy)>=0) ? ((yy)%(xx)) : (((yy)*(1-(xx)))%(xx)))

#define DIPM_IQ_TO_ZERO( yy, xx ) \
   (((yy)>=0) ? ((yy)/(xx)) : (-((-(yy))/(xx))))

#define DIPM_IR_TO_ZERO( yy, xx ) \
   (((yy)>=0) ? ((yy)%(xx)) : (-((-(yy))%(xx))))

#define DIPM_IQ_PERIODIC_UPPER( yy, xx ) \
   (((yy)>=(1-(xx))) ? (((yy)+(xx)-1)/(xx)) : (-((-(yy))/(xx))))


/* Yes, the SHIFT and CYCLES defines are the same ! */
#define DIP_MOD_FREQUENCY 1
#define DIP_MOD_SHIFT     2
#define DIP_MOD_CYCLES    2
#define DIP_MOD_PERIOD    3

#define DIP_MOD_KILL_NYQUIST 4

#define DIP_MODULATE_COSINE             1
#define DIP_MODULATE_SINE               2
#define DIP_DEMODULATE_GABOR            3
#define DIP_DEMODULATE_GABOR_MAGNITUDE  4

typedef enum
{
   DIP_ARITHOP_ADD,
   DIP_ARITHOP_SUB,
   DIP_ARITHOP_MUL,
   DIP_ARITHOP_DIV,   
   DIP_ARITHOP_MUL_CONJUGATE
} dipf_ArithOperation;

DIP_ERROR dip_Arith      ( dip_Image, dip_Image, dip_Image,
                           dipf_ArithOperation, dip_DataType );
DIP_ERROR dip_Arith_ComplexSeparated
                         ( dip_Image, dip_Image, dip_Image,
                           dip_Image, dip_Image, dip_Image,
                           dipf_ArithOperation, dip_DataType );
/* Define macros to substitute the old way of calling the arithmetic functions. */
#define dip_Add( a, b, c ) dip_Arith( (a), (b), (c), DIP_ARITHOP_ADD, DIP_DT_MINIMUM )
#define dip_Sub( a, b, c ) dip_Arith( (a), (b), (c), DIP_ARITHOP_SUB, DIP_DT_MINIMUM )
#define dip_Mul( a, b, c ) dip_Arith( (a), (b), (c), DIP_ARITHOP_MUL, DIP_DT_MINIMUM )
#define dip_Div( a, b, c ) dip_Arith( (a), (b), (c), DIP_ARITHOP_DIV, DIP_DT_MINIMUM )
#define dip_MulConjugate( a, b, c ) dip_Arith( (a), (b), (c), DIP_ARITHOP_MUL_CONJUGATE, DIP_DT_MINIMUM )

DIP_ERROR dip_AddInteger ( dip_Image, dip_Image, dip_int );
DIP_ERROR dip_AddFloat   ( dip_Image, dip_Image, dip_float );
DIP_ERROR dip_AddComplex ( dip_Image, dip_Image, dip_complex );
DIP_ERROR dip_MulInteger ( dip_Image, dip_Image, dip_int );
DIP_ERROR dip_MulFloat   ( dip_Image, dip_Image, dip_float );
DIP_ERROR dip_MulComplex ( dip_Image, dip_Image, dip_complex );
DIP_ERROR dip_SubInteger ( dip_Image, dip_Image, dip_int );
DIP_ERROR dip_SubFloat   ( dip_Image, dip_Image, dip_float );
DIP_ERROR dip_SubComplex ( dip_Image, dip_Image, dip_complex );
DIP_ERROR dip_DivInteger ( dip_Image, dip_Image, dip_int );
DIP_ERROR dip_DivFloat   ( dip_Image, dip_Image, dip_float );
DIP_ERROR dip_DivComplex ( dip_Image, dip_Image, dip_complex );
DIP_ERROR dip_MulConjugateComplex ( dip_Image, dip_Image, dip_complex );

DIP_ERROR dip_NormaliseSum        ( dip_Image, dip_Image, dip_float );

DIP_ERROR dip_WeightedAdd  ( dip_Image, dip_Image, dip_Image, dip_float );
DIP_ERROR dip_WeightedSub  ( dip_Image, dip_Image, dip_Image, dip_float );
DIP_ERROR dip_WeightedMul  ( dip_Image, dip_Image, dip_Image, dip_float );
DIP_ERROR dip_WeightedDiv  ( dip_Image, dip_Image, dip_Image, dip_float );

DIP_ERROR dip_Atan2         ( dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_Max           ( dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_Min           ( dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_MaxFloat      ( dip_Image, dip_Image, dip_float );
DIP_ERROR dip_MinFloat      ( dip_Image, dip_Image, dip_float );
DIP_ERROR dip_Power         ( dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_PowerFloat    ( dip_Image, dip_Image, dip_float );
DIP_ERROR dip_SignedMinimum ( dip_Image, dip_Image, dip_Image );

DIP_ERROR dip_Or     ( dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_And    ( dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_Xor    ( dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_Invert ( dip_Image, dip_Image );

DIP_ERROR dip_PlaneAnd    ( dip_Image, dip_int, dip_Image, dip_int,
                                  dip_Image, dip_int );
DIP_ERROR dip_PlaneOr     ( dip_Image, dip_int, dip_Image, dip_int,
                                  dip_Image, dip_int );
DIP_ERROR dip_PlaneXor    ( dip_Image, dip_int, dip_Image, dip_int,
                                  dip_Image, dip_int );
DIP_ERROR dip_PlaneInvert ( dip_Image, dip_int, dip_Image, dip_int );

DIP_ERROR dip_Combinations ( dip_float, dip_float, dip_float * );

DIP_ERROR dip_SquareModulus ( dip_Image, dip_Image );
DIP_ERROR dip_Modulus     ( dip_Image, dip_Image );
DIP_ERROR dip_Phase       ( dip_Image, dip_Image );
DIP_ERROR dip_Real        ( dip_Image, dip_Image );
DIP_ERROR dip_Imaginary   ( dip_Image, dip_Image );
DIP_ERROR dip_Abs         ( dip_Image, dip_Image );
DIP_ERROR dip_Ceil        ( dip_Image, dip_Image );
DIP_ERROR dip_Floor       ( dip_Image, dip_Image );
DIP_ERROR dip_Floor       ( dip_Image, dip_Image );
DIP_ERROR dip_Sign        ( dip_Image, dip_Image );
DIP_ERROR dip_Truncate    ( dip_Image, dip_Image );
DIP_ERROR dip_Fraction    ( dip_Image, dip_Image );
DIP_ERROR dip_NearestInt  ( dip_Image, dip_Image );
DIP_ERROR dip_Sin         ( dip_Image, dip_Image );
DIP_ERROR dip_Cos         ( dip_Image, dip_Image );
DIP_ERROR dip_Tan         ( dip_Image, dip_Image );
DIP_ERROR dip_Asin        ( dip_Image, dip_Image );
DIP_ERROR dip_Acos        ( dip_Image, dip_Image );
DIP_ERROR dip_Atan        ( dip_Image, dip_Image );
DIP_ERROR dip_Sinh        ( dip_Image, dip_Image );
DIP_ERROR dip_Cosh        ( dip_Image, dip_Image );
DIP_ERROR dip_Tanh        ( dip_Image, dip_Image );
DIP_ERROR dip_Asinh       ( dip_Image, dip_Image );
DIP_ERROR dip_Acosh       ( dip_Image, dip_Image );
DIP_ERROR dip_Atanh       ( dip_Image, dip_Image );
DIP_ERROR dip_Reciprocal  ( dip_Image, dip_Image );
DIP_ERROR dip_Sqrt        ( dip_Image, dip_Image );
/*DIP_ERROR dip_Cbrt        ( dip_Image, dip_Image );*/
DIP_ERROR dip_Exp         ( dip_Image, dip_Image );
DIP_ERROR dip_Exp2        ( dip_Image, dip_Image );
DIP_ERROR dip_Exp10       ( dip_Image, dip_Image );
DIP_ERROR dip_Ln          ( dip_Image, dip_Image );
DIP_ERROR dip_Log2        ( dip_Image, dip_Image );
DIP_ERROR dip_Log10       ( dip_Image, dip_Image );
DIP_ERROR dip_BesselJ0    ( dip_Image, dip_Image );
DIP_ERROR dip_BesselJ1    ( dip_Image, dip_Image );
DIP_ERROR dip_BesselJN    ( dip_Image, dip_Image, dip_int );
DIP_ERROR dip_BesselY0    ( dip_Image, dip_Image );
DIP_ERROR dip_BesselY1    ( dip_Image, dip_Image );
DIP_ERROR dip_BesselYN    ( dip_Image, dip_Image, dip_int );
DIP_ERROR dip_LnGamma     ( dip_Image, dip_Image );
DIP_ERROR dip_Erf         ( dip_Image, dip_Image );
DIP_ERROR dip_Erfc        ( dip_Image, dip_Image );
DIP_ERROR dip_Sinc        ( dip_Image, dip_Image );
DIP_ERROR dip_Modulo      ( dip_Image, dip_Image, dip_int );
DIP_ERROR dip_ModuloFloatPeriodic( dip_Image, dip_Image, dip_float );

DIP_ERROR dip_Bounds( dip_Image, dip_Image, dip_Image, dip_float, dip_float );

/* declaration of special functions */
DIP_EXPORT dip_float dipm_Truncate   ( dip_float );
DIP_EXPORT dip_float dipm_Floor      ( dip_float );
DIP_EXPORT dip_float dipm_Ceiling    ( dip_float );
DIP_EXPORT dip_float dipm_Fraction   ( dip_float );
DIP_EXPORT dip_float dipm_NearestInt ( dip_float );
DIP_EXPORT dip_float dipm_Round      ( dip_float );
DIP_EXPORT dip_float dipm_Abs        ( dip_float );
DIP_EXPORT dip_float dipm_Sign       ( dip_float );
DIP_EXPORT dip_float dipm_Exp2       ( dip_float );
DIP_EXPORT dip_float dipm_Exp10      ( dip_float );
DIP_EXPORT dip_float dipm_Sinc       ( dip_float );
DIP_EXPORT dip_float dipm_Asinh      ( dip_float );
DIP_EXPORT dip_float dipm_Acosh      ( dip_float );
DIP_EXPORT dip_float dipm_Atanh      ( dip_float );
DIP_EXPORT dip_float dipm_Reciprocal ( dip_float );
DIP_EXPORT dip_float dipm_Sqrt       ( dip_float );
DIP_EXPORT dip_float dipm_Atan2      ( dip_float, dip_float );
DIP_EXPORT dip_float dipm_BesselJ0   ( dip_float );
DIP_EXPORT dip_float dipm_BesselJ1   ( dip_float );
DIP_EXPORT dip_float dipm_BesselJN   ( dip_float, dip_int );
DIP_EXPORT dip_float dipm_BesselY0   ( dip_float );
DIP_EXPORT dip_float dipm_BesselY1   ( dip_float );
DIP_EXPORT dip_float dipm_BesselYN   ( dip_float, dip_int );
DIP_EXPORT dip_float dipm_LnGamma    ( dip_float );
DIP_EXPORT dip_float dipm_Erf        ( dip_float );
DIP_EXPORT dip_float dipm_Erfc       ( dip_float );
DIP_EXPORT dip_float dipm_GammaP     ( dip_float, dip_float );
DIP_EXPORT dip_float dipm_GammaQ     ( dip_float, dip_float );
DIP_EXPORT dip_float dipm_Unity      ( dip_float );
DIP_EXPORT dip_float dipm_Square     ( dip_float );
DIP_EXPORT dip_float dipm_Zero       ( dip_float );
DIP_EXPORT dip_float dipm_PowInt     ( dip_float, dip_int );
DIP_EXPORT dip_float dipm_Psinc      ( dip_float, dip_int );
DIP_EXPORT dip_float dipm_Dpsinc     ( dip_float, dip_int );
DIP_EXPORT dip_float dipm_ModuloFloatPeriodic( dip_float, dip_float );
DIP_EXPORT dip_float dipm_Exp2       ( dip_float );
DIP_EXPORT dip_float dipm_Exp10      ( dip_float );
DIP_EXPORT dip_float dipm_Ln         ( dip_float );
DIP_EXPORT dip_float dipm_Log2       ( dip_float );
DIP_EXPORT dip_float dipm_Log10      ( dip_float );

DIP_EXPORT dip_complex dipm_SquareModulus ( dip_complex );
DIP_EXPORT dip_complex dipm_Modulus   ( dip_complex );
DIP_EXPORT dip_complex dipm_Phase     ( dip_complex );
DIP_EXPORT dip_complex dipm_Real      ( dip_complex );
DIP_EXPORT dip_complex dipm_Imaginary ( dip_complex );
DIP_EXPORT dip_complex dipm_CAdd      ( dip_complex, dip_complex );
DIP_EXPORT dip_complex dipm_CSub      ( dip_complex, dip_complex );
DIP_EXPORT dip_complex dipm_CMul      ( dip_complex, dip_complex );
DIP_EXPORT dip_complex dipm_CDiv      ( dip_complex, dip_complex );
DIP_EXPORT dip_complex dipm_CExp      ( dip_complex );
DIP_EXPORT dip_complex dipm_CLn       ( dip_complex );
DIP_EXPORT dip_complex dipm_CSin      ( dip_complex );
DIP_EXPORT dip_complex dipm_CCos      ( dip_complex );
DIP_EXPORT dip_complex dipm_CTan      ( dip_complex );
DIP_EXPORT dip_complex dipm_CPowInt   ( dip_complex, dip_int );

DIP_ERROR dip_Lut( dip_float, dip_sint32, dip_float *, dip_sint32 *,
                   dip_float *, dip_float *, dip_int );
DIP_ERROR dip_ImageLut( dip_Image, dip_Image, dip_Image, dip_Image );

DIP_EXPORT dip_int dipm_AbsInt                ( dip_int );
DIP_EXPORT dip_int dipm_GreatestCommonDivisor ( dip_int, dip_int );

DIP_EXPORT void dipm_PolarToVector( dip_float, dip_float, dip_float *, dip_float * );
DIP_EXPORT void dipm_VectorToPolar( dip_float, dip_float, dip_float *, dip_float * );
DIP_EXPORT void dipm_SphericalToVector( dip_float, dip_float, dip_float,
                             dip_float *, dip_float *, dip_float * );
DIP_EXPORT void dipm_VectorToSpherical( dip_float, dip_float, dip_float,
                             dip_float *, dip_float *, dip_float * );

/* Divisions that are safe from floating point exceptions, but produce NaN and Inf when needed */
DIP_EXPORT void dipm_Division_Float   ( dip_float, dip_float, dip_float* );
DIP_EXPORT void dipm_Division_Complex ( dip_float, dip_float, dip_float, dip_float,
                                        dip_float*, dip_float* );

DIP_ERROR dip_PolarToVector( dip_Image, dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_VectorToPolar( dip_Image, dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_SphericalToVector( dip_Image, dip_Image, dip_Image,
                                 dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_VectorToSpherical( dip_Image, dip_Image, dip_Image,
                                 dip_Image, dip_Image, dip_Image );

DIP_ERROR dip_AmplitudeModulation       ( dip_Image, dip_Image, dip_float *,
                                          dip_int, dip_int *, dip_int * );
DIP_ERROR dip_CosinAmplitudeModulation  ( dip_Image, dip_Image, dip_float *,
                                          dip_int, dip_int, dip_int *,
                                          dip_int * );
DIP_ERROR dip_CosinAmplitudeDemodulation( dip_Image, dip_Image, dip_Image,
                                          dip_Image, dip_float *, dip_int,
                                          dip_int, dip_int *, dip_int * );
DIP_ERROR dip_GeneratePhase             ( dip_Image, dip_float *, dip_int,
                                          dip_int *, dip_int * );


DIP_ERROR dip_Mean              ( dip_Image, dip_Image, dip_Image,
                                    dip_BooleanArray  );
DIP_ERROR dip_Sum               ( dip_Image, dip_Image, dip_Image,
                                    dip_BooleanArray );
DIP_ERROR dip_Prod              ( dip_Image, dip_Image, dip_Image,
                                    dip_BooleanArray );
DIP_ERROR dip_CumulativeSum     ( dip_Image, dip_Image, dip_Image,
                                    dip_BooleanArray );
DIP_ERROR dip_MeanModulus       ( dip_Image, dip_Image, dip_Image,
                                     dip_BooleanArray );
DIP_ERROR dip_SumModulus        ( dip_Image, dip_Image, dip_Image,
                                     dip_BooleanArray );
DIP_ERROR dip_MeanSquareModulus ( dip_Image, dip_Image, dip_Image,
                                     dip_BooleanArray );
/*DIP_ERROR dip_SumSquareModulus  ( dip_Image, dip_Image, dip_Image,
                                     dip_BooleanArray );*/
DIP_ERROR dip_Variance          ( dip_Image, dip_Image, dip_Image,
                                     dip_BooleanArray );
DIP_ERROR dip_StandardDeviation ( dip_Image, dip_Image, dip_Image,
                                     dip_BooleanArray );
DIP_ERROR dip_Maximum           ( dip_Image, dip_Image, dip_Image,
                                     dip_BooleanArray );
DIP_ERROR dip_Minimum           ( dip_Image, dip_Image, dip_Image,
                                     dip_BooleanArray );
DIP_ERROR dip_Median            ( dip_Image, dip_Image, dip_Image,
                                     dip_BooleanArray );
DIP_ERROR dip_Percentile        ( dip_Image, dip_Image, dip_Image,
                                  dip_float, dip_BooleanArray );
DIP_ERROR dip_PositionMaximum   ( dip_Image, dip_Image, dip_Image, dip_int,
                                    dip_Boolean );
DIP_ERROR dip_PositionMinimum   ( dip_Image, dip_Image, dip_Image, dip_int,
                                    dip_Boolean );
DIP_ERROR dip_PositionMedian    ( dip_Image, dip_Image, dip_Image, dip_int,
                                    dip_Boolean );
DIP_ERROR dip_PositionPercentile( dip_Image, dip_Image, dip_Image, dip_float,
                                    dip_int, dip_Boolean );
DIP_ERROR dip_MaximumPixel      ( dip_Image, dip_Image, dip_IntegerArray,
                                    dip_float *, dip_Boolean );
DIP_ERROR dip_MinimumPixel      ( dip_Image, dip_Image, dip_IntegerArray,
                                    dip_float *, dip_Boolean );

DIP_ERROR dip_MeanError          ( dip_Image, dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_MeanSquareError    ( dip_Image, dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_RootMeanSquareError( dip_Image, dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_MeanAbsoluteError  ( dip_Image, dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_IDivergence        ( dip_Image, dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_ULnV               ( dip_Image, dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_InProduct          ( dip_Image, dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_LnNormError        ( dip_Image, dip_Image, dip_Image, dip_Image,
                                   dip_float );

DIP_ERROR dip_RadialMean( dip_Image, dip_Image, dip_Image,
   dip_BooleanArray, dip_float, dip_Boolean, dip_FloatArray );
DIP_ERROR dip_RadialSum( dip_Image, dip_Image, dip_Image,
   dip_BooleanArray, dip_float, dip_Boolean, dip_FloatArray );
DIP_ERROR dip_RadialMaximum( dip_Image, dip_Image, dip_Image,
   dip_BooleanArray, dip_float, dip_Boolean, dip_FloatArray );
DIP_ERROR dip_RadialMinimum( dip_Image, dip_Image, dip_Image,
   dip_BooleanArray, dip_float, dip_Boolean, dip_FloatArray );


typedef enum
{
   DIP_SELECT_LESSER = 1,
   DIP_SELECT_LESSER_EQUAL,
   DIP_SELECT_NOT_EQUAL,
   DIP_SELECT_EQUAL,
   DIP_SELECT_GREATER_EQUAL,
   DIP_SELECT_GREATER
} dipf_Select;

DIP_ERROR dip_Select ( dip_Image, dip_Image, dip_Image, dip_Image, dip_Image,
                  dipf_Select );
DIP_ERROR dip_Compare ( dip_Image, dip_Image, dip_Image, dipf_Select );

#define dip_Equal( a, b, c )        dip_Compare( (a), (b), (c), DIP_SELECT_EQUAL )
#define dip_Greater( a, b, c )      dip_Compare( (a), (b), (c), DIP_SELECT_GREATER )
#define dip_Lesser( a, b, c )       dip_Compare( (a), (b), (c), DIP_SELECT_LESSER )
#define dip_NotEqual( a, b, c )     dip_Compare( (a), (b), (c), DIP_SELECT_NOT_EQUAL )
#define dip_NotGreater( a, b, c )   dip_Compare( (a), (b), (c), DIP_SELECT_LESSER_EQUAL )
#define dip_NotLesser( a, b, c )    dip_Compare( (a), (b), (c), DIP_SELECT_GREATER_EQUAL )

DIP_ERROR dip_GetMaximumAndMinimum ( dip_Image, dip_Image, dip_float *, dip_float * );
DIP_ERROR dip_Moments ( dip_Image, dip_Image, dip_IntegerArray, dip_FloatArray,
                  dip_complex * );
DIP_ERROR dip_CenterOfMass( dip_Image, dip_Image, dip_FloatArray,
                  dip_FloatArray );

DIP_ERROR dip_SymmetricEigensystem2( dip_Image, dip_Image, dip_Image,
                  dip_Image, dip_Image, dip_Image, dip_Image, dip_Image,
                  dip_Image, dip_Image, dip_Image, dip_Image, dip_Image );
DIP_ERROR dip_SymmetricEigensystem3( dip_Image, dip_Image, dip_Image,
                  dip_Image, dip_Image, dip_Image, dip_Image, dip_Image,
                  dip_Image, dip_Image, dip_Image, dip_Image, dip_Image,
                  dip_Image, dip_Image, dip_Image, dip_Image, dip_Image,
                  dip_Image, dip_Image, dip_Image, dip_Image, dip_Image,
                  dip_Image, dip_Image, dip_Image, dip_Image, dip_Boolean );
DIP_EXPORT void dipm_SymmetricEigensystem2( dip_float, dip_float, dip_float,
                  dip_float *, dip_float *, dip_float *, dip_float * );
DIP_EXPORT void dipm_SymmetricEigensystem3( dip_float, dip_float, dip_float,
                  dip_float, dip_float, dip_float, dip_float *, dip_float *,
                  dip_float *, dip_float *, dip_float *, dip_float *,
                  dip_Boolean );

DIP_ERROR dip_TensorImageInverse ( dip_ImageArray, dip_ImageArray );

DIP_ERROR dip_SingularValueDecomposition ( dip_ImageArray, dip_IntegerArray,
                 dip_ImageArray, dip_ImageArray, dip_ImageArray );

#include <math.h>

#ifdef M_PI
#define DIP_PI M_PI
#else
#define DIP_PI 3.14159265358979323846
#endif
#define DIP_SQRT_PI    1.7724538509055160273
#define DIP_PORT_LN2   0.693147180559945309417232121458176568075500134
#define DIP_PORT_LN10  2.302585092994045684017991454684364207601101489
#define DIP_PORT_LN2_R 1.442695040888963407359924681001892137426645954

#ifdef INFINITY
   #define DIP_INF INFINITY
#else
   /* If compiler is not C99 compliant, find a different way of producing Inf. */
   #ifndef WIN32
      /* This version doesn't work on Windows */
      #define DIP_INF (1.0/0.0)
   #else
      /* This version doesn't work with the SunOS Workshop compiler */
      #define DIP_INF (DIP_MAX_DFLOAT*10)
   #endif
#endif

#ifdef NAN
   #define DIP_NAN NAN
#else
   /* If compiler is not C99 compliant, find a different way of producing NaN. */
   #define DIP_NAN (DIP_INF*0)
#endif

#ifdef fpclassify
   #define DIP_IS_NAN(x) (fpclassify(x)==FP_NAN)
   #define DIP_IS_INF(x) (fpclassify(x)==FP_INFINITE)
#else
   /* Compiler is not C99 compliant. */
   #define DIP_IS_NAN(x) ((x)!=(x))
   #define DIP_IS_INF(x) (((x)>DIP_MAX_DFLOAT) || ((x)<DIP_MIN_DFLOAT))
#endif
#define DIP_IS_FINITE(x) (!DIP_IS_NAN(x) && !DIP_IS_INF(x))
#define DIP_IS_NOTFINITE(x) (DIP_IS_NAN(x) || DIP_IS_INF(x))

#define DIP_DEGREE_TO_RADIAN(a)  ((a * DIP_PI)/180.0)
#define DIP_DEGREE_TO_GRADIAN(a) ((a * 200.0)/180.0)
#define DIP_RADIAN_TO_DEGREE(a)  ((a * 180.0)/DIP_PI)
#define DIP_RADIAN_TO_GRADIAN(a) ((a * 200.0)/DIP_PI)
#define DIP_GRADIAN_TO_RADIAN(a) ((a * DIP_PI)/200.0)
#define DIP_GRADIAN_TO_DEGREE(a) ((a * 180.0)/200.0)

DIP_ERROR dip_FloatArrayAdd ( dip_FloatArray, dip_FloatArray, dip_FloatArray );
DIP_ERROR dip_FloatArraySub ( dip_FloatArray, dip_FloatArray, dip_FloatArray );
DIP_ERROR dip_FloatArrayMul ( dip_FloatArray, dip_FloatArray, dip_FloatArray );
DIP_ERROR dip_FloatArrayDiv ( dip_FloatArray, dip_FloatArray, dip_FloatArray );

DIP_ERROR dip_FloatArrayAddFloat ( dip_FloatArray, dip_float, dip_FloatArray );
DIP_ERROR dip_FloatArraySubFloat ( dip_FloatArray, dip_float, dip_FloatArray );
DIP_ERROR dip_FloatArrayMulFloat ( dip_FloatArray, dip_float, dip_FloatArray );
DIP_ERROR dip_FloatArrayDivFloat ( dip_FloatArray, dip_float, dip_FloatArray );

DIP_ERROR dip_FloatArraySort ( dip_FloatArray );
DIP_ERROR dip_IntegerArraySort ( dip_IntegerArray );
DIP_ERROR dip_FloatArraySortIndices ( dip_FloatArray, dip_IntegerArray );
DIP_ERROR dip_IntegerArraySortIndices ( dip_IntegerArray, dip_IntegerArray );

DIP_ERROR dip_LineFit ( void *, void *, dip_DataType, dip_binary *,
                       dip_int, dip_int, dip_float * );

DIP_ERROR dip_LUInvert ( dip_float *a, dip_int n, dip_float *ainv,
                         dip_float *tmpf, dip_int *tmpi, dip_Boolean *invertible );
DIP_ERROR dip_LUSolve  ( dip_float *a, dip_int n, dip_float *b,
                         dip_float *tmpf, dip_int *tmpi, dip_Boolean *solvable );
DIP_ERROR dip_SVD      ( dip_float *a, dip_int m, dip_int n, dip_float *w,
                         dip_float *v, dip_float *tmpf );

#define DIP_TPI_INC_FILE "dip_math.h"
#define DIP_TPI_INC_ALLOW DIP_DTGID_FLOAT
#include "dip_tpi_inc.h"

#ifdef __cplusplus
}
#endif
#endif

#else /* ifndef DIP_TPI_INC */

/* This defines 2 functions: dip__Spline_sfl() and dip__Spline_dfl(), one uses dip_sfloat
 * pointers as input, the other dip_dfloat (==dip_float).
 * (Not exported.) */
DIP_TPI_INC_DECLARE(dip__Spline) ( DIP_TPI_INC*, DIP_TPI_INC*, DIP_TPI_INC*, dip_int );

#endif /* ifndef DIP_TPI_INC */
