/*
 * Filename: dipio_image.h
 *
 * (C) Copyright 2000-2006               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 */

#ifndef DIPIO_IMAGE_H
#define DIPIO_IMAGE_H

#include "dip_information.h"

#ifdef __cplusplus
extern "C" {
#endif

DIPIO_ERROR dipio_Initialise ( void );
DIPIO_ERROR dipio_Exit       ( void );
DIPIO_ERROR dipio_GetLibraryInformation( dip_LibraryInformation * );

/* These are used in reading/writing colour images. */
typedef enum
{
   DIPIO_PHM_GREYVALUE = 0,
   DIPIO_PHM_RGB = 2,       /* RGB */
   DIPIO_PHM_RGB_NONLINEAR, /* R'G'B' */
   DIPIO_PHM_CMY = 4,       /* CMY */
   DIPIO_PHM_CMYK = 5,      /* CMYK */
   DIPIO_PHM_CIELUV,        /* CIE L*u*v* */
   DIPIO_PHM_CIELAB = 8,    /* CIE L*a*b* */
   DIPIO_PHM_CIEXYZ,        /* CIE XYZ */
   DIPIO_PHM_CIEYXY,        /* CIE Yxy */
   DIPIO_PHM_HCV,           /* HCV */
   DIPIO_PHM_HSV,           /* HSV */
   DIPIO_PHM_DEFAULT = DIPIO_PHM_GREYVALUE,
   DIPIO_PHM_GENERIC = DIPIO_PHM_CMYK
} dipio_PhotometricInterpretation;

typedef struct
{
   dip_String              name;
   dip_String              filetype;
   dip_DataType            datatype;
   dip_int                 sigbits;
   dip_IntegerArray        dimensions;
   dipio_PhotometricInterpretation photometric;	
   dip_PhysicalDimensions  physDims;
   dip_int                 numberOfImages; /* for TIFF files only */
   dip_StringArray         history;
   dip_Resources           resources;
} dipio__ImageFileInformation, *dipio_ImageFileInformation;

typedef enum
{
	DIPIO_CMP_DEFAULT = 0,    /* Whatever's cool for the file format */
	DIPIO_CMP_NONE = 1,       /* Quickest compression ever! */
   DIPIO_CMP_GZIP,           /* Uzing libz, for TIFF and ICS */
	DIPIO_CMP_DEFLATE = DIPIO_CMP_GZIP, /* Alias for the benefit of libtiff */
	DIPIO_CMP_LZW,            /* Yes, LZW method, TIFF, ICS and GIF */
   DIPIO_CMP_COMPRESS = DIPIO_CMP_LZW, /* Alias for the benefit of libics */
	DIPIO_CMP_PACKBITS,       /* TIFF-only method */
	DIPIO_CMP_THUNDERSCAN,    /* TIFF-only method */
	DIPIO_CMP_NEXT,           /* TIFF-only method */
	DIPIO_CMP_CCITTRLE,       /* TIFF-only method */
	DIPIO_CMP_CCITTRLEW,      /* TIFF-only method */
	DIPIO_CMP_CCITTFAX3,      /* TIFF-only method */
	DIPIO_CMP_CCITTFAX4,      /* TIFF-only method */
	DIPIO_CMP_JPEG            /* I think this results in JPEG compression? TIFF and JPEG */
} dipio_CompressionMethod;

typedef struct
{
   dipio_CompressionMethod method;
   dip_int level;                    /* For GZIP and JPEG there's a compression level to set... */
} dipio_Compression;

/* toplevel File I/O functions */
DIPIO_ERROR dipio_ImageRead       ( dip_Image, dip_String, dip_int, dip_Boolean, dip_Boolean * );
DIPIO_ERROR dipio_ImageReadColour ( dip_Image, dip_String, dipio_PhotometricInterpretation*, dip_int, dip_Boolean, dip_Boolean * );
DIPIO_ERROR dipio_ImageReadColourSeries ( dip_Image, dip_StringArray, dipio_PhotometricInterpretation*,
                                    dip_int, dip_Boolean, dip_Boolean * );
DIPIO_ERROR dipio_ImageReadROI    ( dip_Image, dip_String, dip_IntegerArray, dip_IntegerArray,
                                    dip_IntegerArray, dip_int, dip_Boolean, dip_Boolean * );
DIPIO_ERROR dipio_ImageFileGetInfo( dipio_ImageFileInformation*, dip_String, dip_int,
                                    dip_Boolean, dip_Boolean*, dip_Resources );
DIPIO_ERROR dipio_ImageWrite      ( dip_Image, dip_String, dip_PhysicalDimensions, dip_int, 
                                    dipio_Compression );
DIPIO_ERROR dipio_ImageWriteColour( dip_Image, dip_String, dipio_PhotometricInterpretation,
                                    dip_PhysicalDimensions, dip_int, dipio_Compression );

/* File I/O support functions */
DIPIO_ERROR dipio_Colour2Gray          ( dip_Image, dip_Image,
                                         dipio_PhotometricInterpretation );
DIPIO_ERROR dipio_FileGetExtension     ( dip_String, dip_String *, dip_Resources );
DIPIO_ERROR dipio_FileAddExtension     ( dip_String, dip_String *, char *,
                                         dip_Resources );
DIPIO_ERROR dipio_FileCompareExtension ( dip_String, char *, dip_Boolean * );
DIPIO_ERROR dipio_ImageFindForReading  ( dip_String, dip_String *, dip_int *,
                                         dip_Boolean, dip_Boolean *, dip_Boolean *,
                                         dip_Resources );
DIPIO_ERROR dipio_PhysDimsToDPI        ( dip_PhysicalDimensions, dip_dfloat *, dip_dfloat * );
      
/* registry class definition */
dip_int dip_RegistryImageReadClass( void );
dip_int dip_RegistryImageWriteClass( void );

#define DIP_REGISTRY_CLASS_IMAGE_READ  dip_RegistryImageReadClass()
#define DIP_REGISTRY_CLASS_IMAGE_WRITE dip_RegistryImageWriteClass()

/* registry structure function definitions */
typedef dip_Error (*dipio_ImageLabelFunction)      ( dip_int, dip_String *, dip_Resources );
typedef dip_Error (*dipio_ImageDescriptionFunction)( dip_int, dip_String *, dip_Resources );
typedef dip_Error (*dipio_ImageRecognitionFunction)( dip_int, dip_String, dip_Boolean * );
typedef dip_Error (*dipio_ImageExtensionFunction)  ( dip_int, dip_StringArray *, dip_Resources );
typedef dip_Error (*dipio_ImageReadFunction)       ( dip_int, dip_Image, dip_String );
typedef dip_Error (*dipio_ImageWriteFunction)      ( dip_int, dip_Image, dip_String,
                                                     dip_PhysicalDimensions, dipio_Compression );
typedef dip_Error (*dipio_ImageReadColourFunction) ( dip_int, dip_Image, dip_String,
                                                     dipio_PhotometricInterpretation* );
typedef dip_Error (*dipio_ImageWriteColourFunction)( dip_int, dip_Image, dip_String, 
                                                     dipio_PhotometricInterpretation,
                                                     dip_PhysicalDimensions, dipio_Compression );
typedef dip_Error (*dipio_ImageReadROIFunction)    ( dip_int, dip_Image, dip_String, 
                                                     dip_IntegerArray, dip_IntegerArray,
                                                     dip_IntegerArray );
typedef dip_Error (*dipio_ImageGetInfoFunction)    ( dip_int, dipio_ImageFileInformation,
                                                     dip_String );
                                                     
/* registry structure definitions */
typedef struct
{
   dip_int id;
   dipio_ImageLabelFunction       label;
   dipio_ImageDescriptionFunction description;
   dipio_ImageRecognitionFunction recognise;
   dipio_ImageExtensionFunction   extension;
   dipio_ImageReadFunction        read;
   dipio_ImageReadColourFunction  readColour;
   dipio_ImageReadROIFunction     readROI;
   dipio_ImageGetInfoFunction     getInfo;
} dipio_RegistryClassImageRead;

typedef struct
{
   dip_int id;
   dipio_ImageLabelFunction       label;
   dipio_ImageDescriptionFunction description;
   dipio_ImageWriteFunction       write;
   dipio_ImageWriteColourFunction writeColour;
} dipio_RegistryClassImageWrite;

typedef dipio_RegistryClassImageRead  dipio_ImageReadRegistry;
typedef dipio_RegistryClassImageWrite dipio_ImageWriteRegistry;

/* access functions to registry structure */
DIPIO_ERROR dipio_ImageReadRegister            ( dipio_ImageReadRegistry );
DIPIO_ERROR dipio_ImageReadRegistryList        ( dip_IntegerArray *, dip_Resources );
DIPIO_ERROR dipio_ImageReadRegistryGet         ( dip_int, dipio_ImageReadRegistry * );
DIPIO_ERROR dipio_ImageReadRegistryLabel       ( dip_int, dip_String *, dip_Resources );
DIPIO_ERROR dipio_ImageReadRegistryDescription ( dip_int, dip_String *, dip_Resources );
DIPIO_ERROR dipio_ImageReadRegistryRecognise   ( dip_int, dip_String, dip_Boolean * );
DIPIO_ERROR dipio_ImageReadRegistryExtension   ( dip_int, dip_StringArray *, dip_Resources );
DIPIO_ERROR dipio_ImageReadRegistryRead        ( dip_int, dip_Image, dip_String );
DIPIO_ERROR dipio_ImageReadRegistryReadColour  ( dip_int, dip_Image, dip_String, 
                                                 dipio_PhotometricInterpretation* );
DIPIO_ERROR dipio_ImageReadRegistryReadROI     ( dip_int, dip_Image, dip_String, 
                                                 dip_IntegerArray, dip_IntegerArray,
                                                 dip_IntegerArray );
DIPIO_ERROR dipio_ImageReadRegistryGetInfo     ( dip_int, dipio_ImageFileInformation,
                                                 dip_String );

DIPIO_ERROR dipio_ImageWriteRegister            ( dipio_ImageWriteRegistry );
DIPIO_ERROR dipio_ImageWriteRegistryList        ( dip_IntegerArray *, dip_Resources );
DIPIO_ERROR dipio_ImageWriteRegistryGet         ( dip_int, dipio_ImageWriteRegistry * );
DIPIO_ERROR dipio_ImageWriteRegistryLabel       ( dip_int, dip_String *, dip_Resources );
DIPIO_ERROR dipio_ImageWriteRegistryDescription ( dip_int, dip_String *, dip_Resources );
DIPIO_ERROR dipio_ImageWriteRegistryWrite       ( dip_int, dip_Image, dip_String,
                                                  dip_PhysicalDimensions, dipio_Compression );
DIPIO_ERROR dipio_ImageWriteRegistryWriteColour ( dip_int, dip_Image, dip_String,
                                                  dipio_PhotometricInterpretation,
                                                  dip_PhysicalDimensions, dipio_Compression );

/* File Information structure support */
DIPIO_ERROR dipio_ImageFileInformationNew ( dipio_ImageFileInformation *,
                                            dip_String, dip_String, dip_DataType,
                                            dip_IntegerArray, dip_Resources );
DIPIO_ERROR dipio_ImageFileInformationFree( dipio_ImageFileInformation * );

#ifdef __cplusplus
}
#endif


#endif /* DIPIO_H */
