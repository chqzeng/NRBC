/*
 * filename: dip_sort.h
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
 * Author: Michael van Ginkel
 *
 */


#ifndef DIP_TPI_INC

	#ifndef DIP_SORT_H
	#define DIP_SORT_H
   #ifdef __cplusplus
   extern "C" {
   #endif

	DIP_ERROR dip_GetRank( void *, dip_DataType, dip_int, dip_int,
		dip_int, dip_float * );

	typedef enum
	{
  	 DIP_SORT_DEFAULT = 0,
  	 DIP_SORT_QUICK_SORT,
  	 DIP_SORT_DISTRIBUTION_SORT,
  	 DIP_SORT_INSERTION_SORT,
  	 DIP_SORT_HEAP_SORT
	} dip_SortType;

   typedef enum
   {
      DIP_ISI_USE_INDICES = 1
   } dipf_ImageSortIndices;

   typedef dip_Boolean (*dip_SortCompareFunction) ( void *, dip_int,
                                                    void *, dip_int );
   typedef void (*dip_SortSwapFunction)
                          ( void *, dip_int, void *, dip_int, dip_Boolean );

	#define DIP_SORT3(n1,n2,n3,tmp) \
           if ( (n1) > (n2) ) { (tmp) = (n2); (n2) = (n1); (n1) = (tmp); } \
           if ( (n2) > (n3) ) { (tmp) = (n3); (n3) = (n2); (n2) = (tmp); } \
           if ( (n1) > (n2) ) { (tmp) = (n2); (n2) = (n1); (n1) = (tmp); }

	#define DIP_SORT3_INDICES(dt,n1,n2,n3,tmp) \
  	 if ( (dt[n1]) > (dt[n2]) ) { (tmp) = (n2); (n2) = (n1); (n1) = (tmp); } \
  	 if ( (dt[n2]) > (dt[n3]) ) { (tmp) = (n3); (n3) = (n2); (n2) = (tmp); } \
  	 if ( (dt[n1]) > (dt[n2]) ) { (tmp) = (n2); (n2) = (n1); (n1) = (tmp); }

	#define DIP_SORT3_ANYTHING(dt,n1,n2,n3,compare,swap) \
           if ( compare(dt,n1,dt,n2)) { swap( dt, n1, dt, n2, DIP_FALSE ); } \
           if ( compare(dt,n2,dt,n3)) { swap( dt, n2, dt, n3, DIP_FALSE ); } \
           if ( compare(dt,n1,dt,n2)) { swap( dt, n1, dt, n2, DIP_FALSE ); }


	DIP_ERROR dip_ImageSort ( dip_Image, dip_Image, dip_SortType );
	DIP_ERROR dip_Sort     ( void *, dip_int, dip_SortType, dip_DataType );
   DIP_ERROR dip_SortAnything( void *, dip_int, dip_SortCompareFunction,
                               dip_SortSwapFunction, void *, dip_SortType );

	DIP_ERROR dip_QuickSort        ( void *, dip_int, dip_DataType );
	DIP_ERROR dip_DistributionSort ( void *, dip_int, dip_DataType );
	DIP_ERROR dip_InsertionSort    ( void *, dip_int, dip_DataType );

   DIP_ERROR dip_QuickSortAnything( void *, dip_int, dip_SortCompareFunction,
                                    dip_SortSwapFunction, void * );

	DIP_ERROR dip_DistributionSort_u8  ( void *, dip_int );
	DIP_ERROR dip_DistributionSort_u16 ( void *, dip_int );
	DIP_ERROR dip_DistributionSort_s8  ( void *, dip_int );
	DIP_ERROR dip_DistributionSort_s16 ( void *, dip_int );

	DIP_ERROR dip_ImageSortIndices ( dip_Image, dip_Image, dip_Image, dip_SortType,
                                    dipf_ImageSortIndices );

	DIP_ERROR dip_SortIndices
     ( void *, void *, dip_int, dip_SortType, dip_DataType, dip_DataType );
	DIP_ERROR dip_QuickSortIndices
     ( void *, void *, dip_int, dip_DataType, dip_DataType );
	DIP_ERROR dip_DistributionSortIndices
     ( void *, void *, dip_int, dip_DataType, dip_DataType );
	DIP_ERROR dip_InsertionSortIndices
     ( void *, void *, dip_int, dip_DataType, dip_DataType );

	DIP_ERROR dip_SortIndices32
     ( void *, dip_sint32 *, dip_int, dip_SortType, dip_DataType );
	DIP_ERROR dip_SortIndices16
     ( void *, dip_sint16 *, dip_int, dip_SortType, dip_DataType );
	DIP_ERROR dip_QuickSortIndices32
     ( void *, dip_sint32 *, dip_int, dip_DataType );
	DIP_ERROR dip_QuickSortIndices16
     ( void *, dip_sint16 *, dip_int, dip_DataType );
	DIP_ERROR dip_DistributionSortIndices32
     ( void *, dip_sint32 *, dip_int, dip_DataType );
	DIP_ERROR dip_DistributionSortIndices16
     ( void *, dip_sint16 *, dip_int, dip_DataType );
	DIP_ERROR dip_InsertionSortIndices32
     ( void *, dip_sint32 *, dip_int, dip_DataType );
	DIP_ERROR dip_InsertionSortIndices16
     ( void *, dip_sint16 *, dip_int, dip_DataType );
#ifdef DIP_64BITS
	DIP_ERROR dip_SortIndices64
     ( void *, dip_sint64 *, dip_int, dip_SortType, dip_DataType );
	DIP_ERROR dip_QuickSortIndices64
     ( void *, dip_sint64 *, dip_int, dip_DataType );
	DIP_ERROR dip_DistributionSortIndices64
     ( void *, dip_sint64 *, dip_int, dip_DataType );
	DIP_ERROR dip_InsertionSortIndices64
     ( void *, dip_sint64 *, dip_int, dip_DataType );
#endif

	DIP_ERROR dip_DistributionSortIndices16_u8
     ( void *, dip_sint16 *, dip_int );
	DIP_ERROR dip_DistributionSortIndices16_u16
     ( void *, dip_sint16 *, dip_int );
	DIP_ERROR dip_DistributionSortIndices16_s8
     ( void *, dip_sint16 *, dip_int );
	DIP_ERROR dip_DistributionSortIndices16_s16
     ( void *, dip_sint16 *, dip_int );
	DIP_ERROR dip_DistributionSortIndices32_u8
     ( void *, dip_sint32 *, dip_int );
	DIP_ERROR dip_DistributionSortIndices32_u16
     ( void *, dip_sint32 *, dip_int );
	DIP_ERROR dip_DistributionSortIndices32_s8
     ( void *, dip_sint32 *, dip_int );
	DIP_ERROR dip_DistributionSortIndices32_s16
     ( void *, dip_sint32 *, dip_int );

#ifdef DIP_64BITS
	DIP_ERROR dip_DistributionSortIndices64_u8
     ( void *, dip_sint64 *, dip_int );
	DIP_ERROR dip_DistributionSortIndices64_u16
     ( void *, dip_sint64 *, dip_int );
	DIP_ERROR dip_DistributionSortIndices64_s8
     ( void *, dip_sint64 *, dip_int );
	DIP_ERROR dip_DistributionSortIndices64_s16
     ( void *, dip_sint64 *, dip_int );
#endif

   DIP_ERROR dip_BinarySearch( void *, dip_int, void *,
                               dip_int *, dip_DataType );
	DIP_ERROR dip_ConvertMaskToIndices ( dip_Image, dip_Image *, dip_sint32 * );

	#define DIP_TPI_INC_FILE "dip_sort.h"
   #define DIP_TPI_INC_FORCE DIP_DTID_SINT
	#include "dip_tpi_inc.h"

   #ifdef __cplusplus
   }
   #endif
	#endif

#else

	#ifndef DIP_TPI_INC_IS_COMPLEX

		DIP_TPI_INC_DECLARE(dip_Sort) ( void *, dip_int, dip_SortType );

		DIP_TPI_INC_DECLARE(dip_QuickSort) ( void *, dip_int );
		DIP_TPI_INC_DECLARE(dip_InsertionSort) ( void *, dip_int );

		DIP_TPI_INC_DECLARE(dip_SortIndices32)
   	  	( void *, dip_sint32 *, dip_int, dip_SortType );
		DIP_TPI_INC_DECLARE(dip_SortIndices16)
     		( void *, dip_sint16 *, dip_int, dip_SortType );

		DIP_TPI_INC_DECLARE(dip_QuickSortIndices16)
     		( void *, dip_sint16 *, dip_int );
		DIP_TPI_INC_DECLARE(dip_InsertionSortIndices16)
     		( void *, dip_sint16 *, dip_int );
		DIP_TPI_INC_DECLARE(dip_InsertionSortIndices32)
     		( void *, dip_sint32 *, dip_int );
		DIP_TPI_INC_DECLARE(dip_QuickSortIndices32)
     		( void *, dip_sint32 *, dip_int );
#ifdef DIP_64BITS
		DIP_TPI_INC_DECLARE(dip_SortIndices64)
   	  	( void *, dip_sint64 *, dip_int, dip_SortType );
		DIP_TPI_INC_DECLARE(dip_QuickSortIndices64)
     		( void *, dip_sint64 *, dip_int );
		DIP_TPI_INC_DECLARE(dip_InsertionSortIndices64)
     		( void *, dip_sint64 *, dip_int );
#endif
      DIP_TPI_INC_DECLARE(dip_BinarySearch)
         ( void *, dip_int, void *, dip_int * );

	#endif

#endif
