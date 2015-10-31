/*
 * Filename: dip_report.h
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
 * Author: 
 *
 */

#ifndef DIP_REPORT_H
#define DIP_REPORT_H
#ifdef __cplusplus
extern "C" {
#endif


#ifdef DIP_REPORT_ON
#define DIP_REPCALL( xx, y )             \
   if ( dip__report.xx )                 \
   {                                     \
      sprintf( dip__report.report, y );  \
   }
#define DIP_REPERR( xx, yy )                             \
   if ( dip__reportWhat.xx )                             \
   {                                                     \
      DIP_IF_ERROR                                       \
      {                                                  \
         sprintf( dip__report, "\n" yy ": Failed" );     \
      }                                                  \
      else                                               \
      {                                                  \
         sprintf( dip__report, "\n" yy ": Succesful" );  \
      }                                                  \
      DIPXC( dip_Report() );                             \
   }
#else
#define DIP_REPCALL( x, y )
#define DIP_REPERR( xx, yy )
#endif

#define DIP_REPORT_SIZE              10000
#define DIP_REPORT_DATA_TYPE_LENGTH     50
#define DIP_REPORT_IMAGE_LENGTH        1000

typedef struct
{
   int  init;
   int  print;
   int  tofile;
   FILE *file;
   int  bufferIndex;
   int  newImage;
   int  forgeImage;
   int  stripImage;
   int  freeImage;
   int  assimilateImage;
   int  replaceImage;
   int  getDataTypeInfo;
   int  initializeResourceTracking;
   int  freeResources;
   int  scScan;
   int  frameWork;
   int  _AttachImage;
   int  _InterfaceHandler;
} dip_WhatToReport;

extern dip_WhatToReport dip__reportWhat;
extern char dip__report[ DIP_REPORT_SIZE ];

DIP_ERROR dip_Report( void );
DIP_ERROR dip_ReportSetFile( char * );
DIP_ERROR dip_ReportToFile( dip_Boolean );
DIP_ERROR dip_ReportImageTypeToString( char *, dip_ImageType );
DIP_ERROR dip_ReportDataTypeToString( char *, dip_DataType );
DIP_ERROR dip_ReportShowImage( char *, dip_Image );
DIP_ERROR dip_ReportValue( char *, void *, dip_int, dip_DataType );
DIP_ERROR dip_ReportAll( void );

#ifdef __cplusplus
}
#endif
#endif

