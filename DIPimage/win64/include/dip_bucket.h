/*
 * Filename: dip_bucket.c
 *
 * (C) Copyright 1995                    Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : lucas@ph.tn.tudelft.nl
 *
 * author: Geert van Kempen
 */

#ifndef DIP_BUCKET_H
#define DIP_BUCKET_H
#ifdef __cplusplus
extern "C" {
#endif

/* Typedefs */
typedef struct {
   dip_binary *pim;
   dip_uint8 dirc;
} dip_Node;

typedef struct dipchunk {
   dip_Boolean used;       /* TRUE if chunk currently used */
   struct dipchunk *bnext;   /* pointer to next chunk of current bucket */
   struct dipchunk *lnext;   /* pointer to next allocated chunk */
} dip_Chunk;

typedef struct {
   dip_int nbuckets;       /* Number of buckets */
   dip_int chunksize;      /* Size of chunk (#nodes) */
   dip_int sizeofchunk;    /* Size of chunk (in bytes, total structure) */
   dip_int andmask;        /* Andmask for modulo operation */
   dip_int rbuck;          /* Number of bucket which is being read */
   dip_int wbuck;          /* Number of bucket in which nodes are being put */
   dip_Chunk *pwritechunk; /* Pointer to chunk being written in */
   dip_Chunk *preadchunk;  /* Pointer to chunk being read */
   dip_Node **plastnode;   /* Array pointers to last nodes+1 of each bucket */
   dip_Chunk **pchunk1;    /* Array pointers to first chunk of each bucket */
   dip_Chunk *firstchunk;  /* First allocated chunk */
   dip_Chunk *lastchunk;   /* Last allocated chunk */
   dip_Chunk *freechunk;   /* Last freed chunk */
   dip_int freecount;      /* Number of free chunks */
	dip_int allocated;      /* Number of chunks allocated extra */
	dip_Resources resources;
} dip_Bucket;

/* Declarations */
DIP_ERROR dip_BucketFree ( dip_Bucket *, dip_int );
DIP_ERROR dip_BucketGetChunk ( dip_Bucket *, dip_Chunk ** );
DIP_ERROR dip_BucketEmpty ( dip_Bucket *, dip_Boolean * );
DIP_ERROR dip_NewBucket ( dip_Bucket *, dip_int, dip_int );

#ifdef __cplusplus
}
#endif
#endif
