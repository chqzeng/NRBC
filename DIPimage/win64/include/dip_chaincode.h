/*
 * Filename: dip_chaincode.h
 *
 * Defines and functions for the chaincode datastructure
 *
 * AUTHOR
 *    Geert van Kempen, Unilever Research Vlaardingen, 1999
 */

#ifndef DIP_CHAIN_CODE
#define DIP_CHAIN_CODE
#ifdef __cplusplus
extern "C" {
#endif

typedef struct _dip_chain
{
	dip_uint8   code;
   dip_Boolean border;  /* pixel is on the border of the image? */
	struct _dip_chain *next;
} dip_Chain;

typedef struct
{
   void *chaincode;
} dip__ChainCode, *dip_ChainCode;

typedef struct
{
	dip_int size;
	dip_ChainCode *array;
} dip__ChainCodeArray, *dip_ChainCodeArray;

typedef struct _dip_vertex
{
	dip_float x;
   dip_float y;
	struct _dip_vertex *next;
} dip_Vertex;

typedef struct
{
   void *polygon;
} dip__Polygon, *dip_Polygon;

typedef struct
{
	dip_float maxDiameter;
	dip_float minDiameter;
	dip_float maxPerpendicular; /* the width of the object perpendicular to minDiameter */
	dip_float maxAngle;
	dip_float minAngle;
} dip_Feret;

typedef struct
{
	dip_float max;
   dip_float mean;
	dip_float min;
	dip_float var;
} dip_CCRadius;

DIP_ERROR dip_ImageChainCode     ( dip_Image, dip_int, dip_IntegerArray,
										     dip_ChainCodeArray *, dip_Resources );

DIP_ERROR dip_ChainCodeNew       ( dip_ChainCode *, dip_Resources );
DIP_ERROR dip_ChainCodeArrayNew  ( dip_ChainCodeArray *, dip_int,
                                   dip_Resources);
DIP_ERROR dip_ChainCodeFree      ( dip_ChainCode * );
DIP_ERROR dip_ChainCodeArrayFree ( dip_ChainCodeArray *);

DIP_ERROR dip_ChainCodeGetSize         ( dip_ChainCode, dip_int * );
DIP_ERROR dip_ChainCodeGetChains       ( dip_ChainCode, dip_Chain ** );
DIP_ERROR dip_ChainCodeGetStart        ( dip_ChainCode, dip_int *, dip_int * );
DIP_ERROR dip_ChainCodeGetLabel        ( dip_ChainCode, dip_int * );
DIP_ERROR dip_ChainCodeGetConnectivity ( dip_ChainCode, dip_int * );

DIP_ERROR dip_ChainCodeGetLength       ( dip_ChainCode, dip_float * );
DIP_ERROR dip_ChainCodeGetFeret        ( dip_ChainCode, dip_float, dip_Feret * );
DIP_ERROR dip_ChainCodeGetRadius       ( dip_ChainCode, dip_CCRadius * );
DIP_ERROR dip_ChainCodeGetLongestRun   ( dip_ChainCode, dip_int * );

DIP_ERROR dip_ChainCodeConvexHull ( dip_ChainCode, dip_Polygon *, dip_Resources );

DIP_ERROR dip_PolygonNew          ( dip_Polygon *, dip_int, dip_Resources );
DIP_ERROR dip_PolygonFree         ( dip_Polygon * );
DIP_ERROR dip_PolygonAddVertex    ( dip_Polygon, dip_float, dip_float );
DIP_ERROR dip_PolygonGetSize      ( dip_Polygon, dip_int * );
DIP_ERROR dip_PolygonGetVertices  ( dip_Polygon, dip_Vertex ** );
DIP_ERROR dip_PolygonGetLastVertex( dip_Polygon, dip_Vertex ** );

DIP_ERROR dip_ConvexHullGetArea      ( dip_Polygon, dip_float * );
DIP_ERROR dip_ConvexHullGetPerimeter ( dip_Polygon, dip_float * );
DIP_ERROR dip_ConvexHullGetFeret     ( dip_Polygon, dip_Feret * );

dip_float dipm_Distance               ( dip_Vertex *, dip_Vertex * );
dip_float dipm_Angle                  ( dip_Vertex *, dip_Vertex * );
dip_float dipm_ParallelogramSignedArea( dip_Vertex *, dip_Vertex *, dip_Vertex * );
dip_float dipm_TriangleArea           ( dip_Vertex *, dip_Vertex *, dip_Vertex * );
dip_float dipm_TriangleHeight         ( dip_Vertex *, dip_Vertex *, dip_Vertex * );

#ifdef __cplusplus
}
#endif
#endif
