/*
 * Filename: dip_pixelqueue.h
 *
 * (C) Copyright 2004-2008               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : lucas@ph.tn.tudelft.nl
 *
 * Author: Cris Luengo
 */

#ifndef DIP_PIXELQUEUE_H
#define DIP_PIXELQUEUE_H
#ifdef __cplusplus
extern "C" {
#endif

#define DIP_PQ_BLOCKSIZE 1024
#define DIP_PH_BLOCKSIZE 1024
#define DIP_PH_BLOCKINCREMENT 2

/**********************************/

typedef struct
{
   void* pointer;               /* pointer into image */
} dip_PixelQueuePixel;

typedef struct dip__tmp__PixelQueueBlock
{
   dip_int bottom;              /* pointer to bottom of queue (place to push data onto) */
   dip_int top;                 /* pointer to top of queue (place to pop data from) */
   dip_PixelQueuePixel *pixels; /* array with info for each pixel */
   dip_int* coord_data;         /* data block to store coordinates to point into -
                                   coord_data+jj*ndims is a pointer to an array with
                                   ndims elements. */
   struct dip__tmp__PixelQueueBlock *next;  /* next block */
} dip__PixelQueueBlock, *dip_PixelQueueBlock;

typedef struct
{
   /* don't ever change these elements unless you know what you are doing */
   dip_int ndims;               /* dimensionality of coordinate system */
   dip_PixelQueueBlock bottom;
   dip_PixelQueueBlock top;
   dip_int nelements;           /* keeps track of the number of elements on the stack - not used
                                   by algorithms */
   dip_int blocksize;           /* size of blocks, defaults to DIP_PQ_BLOCKSIZE */
   dip_PixelQueueBlock marker_block;
   dip_int marker_indx;         /* marker set to bottom at beginning of iteration, when
                                   top==marker_block && top->top==marker_indx, a new iteration
                                   starts - automatically updated when popping the first element
                                   in an iteration. */
} dip__PixelQueue, *dip_PixelQueue;

DIP_ERROR dip_PixelQueueNew ( dip_PixelQueue*, dip_int, dip_int, dip_Resources );
DIP_ERROR dip_PixelQueueFree ( dip_PixelQueue* );    /* defined through a macro */
DIP_ERROR dip_PixelQueuePush ( dip_PixelQueue, dip_int*, void* );
DIP_ERROR dip_PixelQueuePop ( dip_PixelQueue, dip_int*, void**, dip_Boolean* );
DIP_ERROR dip_PixelQueueIsEmpty ( dip_PixelQueue, dip_Boolean* );

dip_Boolean dip__PixelQueueIsEmpty ( dip_PixelQueue ); /* not available outside DIPlib! */

/**********************************/

typedef struct
{
   void* pointer;               /* pointer into image */
   dip_sfloat value;            /* pixel value - used for sorting */
} dip_PixelHeapPixel;

typedef struct
{
   /* don't ever change these elements unless you know what you are doing */
   dip_PixelHeapPixel *pixels;  /* array with info for each pixel */
   dip_int* coord_data;         /* data block to store coordinates to point into -
                                   coord_data+jj*ndims is a pointer to an array with
                                   ndims elements. */
   dip_int ndims;               /* dimensionality of coordinate system */
   dip_int arraysize;           /* length of the array allocated */
   dip_int nelements;           /* number of elements on the heap */
   dipf_GreyValueSortOrder order; /* sorting order */
} dip__PixelHeap, *dip_PixelHeap;

DIP_ERROR dip_PixelHeapNew ( dip_PixelHeap*, dip_int, dip_int, dipf_GreyValueSortOrder, dip_Resources );
DIP_ERROR dip_PixelHeapFree ( dip_PixelHeap* );    /* defined through a macro */
DIP_ERROR dip_PixelHeapPush ( dip_PixelHeap, dip_int*, void*, dip_sfloat );
DIP_ERROR dip_PixelHeapPop ( dip_PixelHeap, dip_int*, void**, dip_sfloat* );
DIP_ERROR dip_PixelHeapReset ( dip_PixelHeap );
DIP_ERROR dip_PixelHeapIsEmpty ( dip_PixelHeap, dip_Boolean* );

dip_Boolean dip__PixelHeapIsEmpty ( dip_PixelHeap ); /* not available outside DIPlib! */

/**********************************/

typedef struct
{
   void* pointer;               /* pointer into image */
   dip_sfloat value;            /* pixel value - used for sorting */
   dip_int insertorder;         /* order of insertion - used for sorting */
} dip_StablePixelHeapPixel;

typedef struct
{
   /* don't ever change these elements unless you know what you are doing */
   dip_StablePixelHeapPixel *pixels;  /* array with info for each pixel */
   dip_int* coord_data;               /* data block to store coordinates to point into -
                                         coord_data+jj*ndims is a pointer to an array with
                                         ndims elements. */
   dip_int ndims;               /* dimensionality of coordinate system */
   dip_int arraysize;           /* length of the array allocated */
   dip_int nelements;           /* number of elements on the heap */
   dip_int cumulativecount;     /* total number of elements pushed -- used to fill out 'insertorder'. */
   dipf_GreyValueSortOrder order; /* sorting order */
} dip__StablePixelHeap, *dip_StablePixelHeap;

DIP_ERROR dip_StablePixelHeapNew ( dip_StablePixelHeap*, dip_int, dip_int, dipf_GreyValueSortOrder, dip_Resources );
DIP_ERROR dip_StablePixelHeapFree ( dip_StablePixelHeap* );    /* defined through a macro */
DIP_ERROR dip_StablePixelHeapPush ( dip_StablePixelHeap, dip_int*, void*, dip_sfloat );
DIP_ERROR dip_StablePixelHeapPop ( dip_StablePixelHeap, dip_int*, void**, dip_sfloat* );
DIP_ERROR dip_StablePixelHeapReset ( dip_StablePixelHeap );
DIP_ERROR dip_StablePixelHeapIsEmpty ( dip_StablePixelHeap, dip_Boolean* );

dip_Boolean dip__StablePixelHeapIsEmpty ( dip_StablePixelHeap ); /* not available outside DIPlib! */

#ifdef __cplusplus
}
#endif
#endif
