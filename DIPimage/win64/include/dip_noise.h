/*
 * Filename: dip_noise.h
 *
 * (C) Copyright 1995-2009
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 * author: Geert van Kempen, Cris Luengo
 *
 * Definition of the DIPlib noise generation functions
 *
 */

#ifndef DIP_NOISE_H
#define DIP_NOISE_H
#ifdef __cplusplus
extern "C" {
#endif

/* Mersenne Twister pseudo-random number generator:
 *
 * Makoto Matsumoto and Takuji Nishimura, "Mersenne twister: a 623-dimensionally
 * equidistributed uniform pseudo-random number generator", ACM Transactions on
 * Modeling and Computer Simulation 8(1):3-30, 1998
 * doi:10.1145/272991.272995
 *
 * Code modified from  mtwist-0.8  package by Geoff Kuenning.
 * http://www.cs.hmc.edu/~geoff/mtwist.html
 * http://www.lasr.cs.ucla.edu/geoff/mtwist.html
 */

#define DIP_MT_STATE_SIZE 624 /* Magic number -- don't ever change! */

typedef struct {
   dip_int     stateptr;      /* Next state entry to be used */
   dip_Boolean initialised;   /* Set to DIP_TRUE if seeded */
   dip_Boolean highprecision; /* Set to DIP_TRUE if you want to have 64-bit precision
                                 random values, instead of 32-bit precision. */
   dip_uint32  statevec[DIP_MT_STATE_SIZE];
} dip_Random;

DIP_ERROR dip_RandomVariable         ( dip_Random *, dip_float * );
DIP_ERROR dip_RandomSeed             ( dip_Random *, dip_uint32 );
DIP_ERROR dip_RandomSeedVector       ( dip_Random *, dip_uint32[DIP_MT_STATE_SIZE] );
DIP_ERROR dip_RandomSeedWithClock    ( dip_Random * );

DIP_ERROR dip_UniformRandomVariable  ( dip_Random *, dip_float, dip_float,
												 	dip_float * );
DIP_ERROR dip_GaussianRandomVariable ( dip_Random *, dip_float, dip_float,
													dip_float *, dip_float * );
DIP_ERROR dip_PoissonRandomVariable  ( dip_Random *, dip_float, dip_float *);
DIP_ERROR dip_BinaryRandomVariable   ( dip_Random *, dip_Boolean, dip_float,
													dip_float, dip_Boolean * );
DIP_ERROR dip_UniformNoise  ( dip_Image, dip_Image, dip_float, dip_float,
										dip_Random * );
DIP_ERROR dip_GaussianNoise ( dip_Image, dip_Image, dip_float, dip_Random * );
DIP_ERROR dip_PoissonNoise  ( dip_Image, dip_Image, dip_float, dip_Random * );
DIP_ERROR dip_BinaryNoise   ( dip_Image, dip_Image, dip_float, dip_float,
										dip_Random * );


#ifdef __cplusplus
}
#endif
/* endif of DIP_NOISE_H */
#endif


