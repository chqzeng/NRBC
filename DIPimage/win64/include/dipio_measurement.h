/*
 * Filename: dipio_measurement.h
 *
 * (C) Copyright 2000                    Pattern Recognition Group
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

#ifndef DIPIO_MEASUREMENT_H
#define DIPIO_MEASUREMENT_H

#include "dip_measurement.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
   char *separator;
   dip_Boolean info;
   dip_Boolean labels;
   dip_Boolean results;
   dip_Boolean labelAlign;
} dipio_WriteTextFormat;

DIPIO_ERROR dipio_MeasurementRead  ( dip_Measurement, dip_String, dip_int, dip_Boolean,
                               dip_Boolean * );
DIPIO_ERROR dipio_MeasurementWrite ( dip_Measurement, dip_String, dip_int, dip_Boolean );
DIPIO_ERROR dipio_MeasurementWriteText ( dip_Measurement, FILE *, dipio_WriteTextFormat );

/* registry class definition */
dip_int dip_RegistryMeasurementReadClass( void );
dip_int dip_RegistryMeasurementWriteClass( void );

#define DIP_REGISTRY_CLASS_MEASUREMENT_READ  dip_RegistryMeasurementReadClass()
#define DIP_REGISTRY_CLASS_MEASUREMENT_WRITE dip_RegistryMeasurementWriteClass()

/* registry structure function definitions */
typedef dip_Error (*dipio_MeasurementLabelFunction)      ( dip_int, dip_String *,
                                                     dip_Resources );
typedef dip_Error (*dipio_MeasurementDescriptionFunction)( dip_int, dip_String *,
                                                     dip_Resources );
typedef dip_Error (*dipio_MeasurementRecognitionFunction)( dip_int, dip_String,
                                                     dip_Boolean * );
typedef dip_Error (*dipio_MeasurementExtensionFunction)  ( dip_int, dip_StringArray *,
                                                     dip_Resources );
typedef dip_Error (*dipio_MeasurementReadFunction)       ( dip_int, dip_Measurement,
                                                     dip_String );
typedef dip_Error (*dipio_MeasurementWriteFunction)      ( dip_int, dip_Measurement,
                                                     dip_String, dip_Boolean );
/* registry structure definitions */
typedef struct
{
	dip_int id;
	dipio_MeasurementLabelFunction       label;
	dipio_MeasurementDescriptionFunction description;
	dipio_MeasurementRecognitionFunction recognise;
	dipio_MeasurementExtensionFunction   extension;
	dipio_MeasurementReadFunction        read;
} dipio_RegistryClassMeasurementRead;

typedef struct
{
	dip_int id;
	dipio_MeasurementLabelFunction       label;
	dipio_MeasurementDescriptionFunction description;
	dipio_MeasurementWriteFunction       write;
} dipio_RegistryClassMeasurementWrite;

typedef dipio_RegistryClassMeasurementRead  dipio_MeasurementReadRegistry;
typedef dipio_RegistryClassMeasurementWrite dipio_MeasurementWriteRegistry;

/* access functions to registry structure */
DIPIO_ERROR dipio_MeasurementReadRegister      ( dipio_MeasurementReadRegistry );
DIPIO_ERROR dipio_MeasurementReadRegistryList  ( dip_IntegerArray *, dip_Resources );
DIPIO_ERROR dipio_MeasurementReadRegistryGet   ( dip_int,
                                                 dipio_MeasurementReadRegistry * );
DIPIO_ERROR dipio_MeasurementReadRegistryLabel ( dip_int, dip_String *,
                                                 dip_Resources );
DIPIO_ERROR dipio_MeasurementReadRegistryDescription ( dip_int, dip_String *,
                                                 dip_Resources );
DIPIO_ERROR dipio_MeasurementReadRegistryRecognise   ( dip_int, dip_String,
                                                 dip_Boolean * );
DIPIO_ERROR dipio_MeasurementReadRegistryExtension   ( dip_int, dip_StringArray *,
                                                 dip_Resources );
DIPIO_ERROR dipio_MeasurementReadRegistryRead  ( dip_int, dip_Measurement, dip_String );

DIPIO_ERROR dipio_MeasurementWriteRegister      ( dipio_MeasurementWriteRegistry );
DIPIO_ERROR dipio_MeasurementWriteRegistryList  ( dip_IntegerArray *,
                                                  dip_Resources );
DIPIO_ERROR dipio_MeasurementWriteRegistryGet   ( dip_int,
                                                  dipio_MeasurementWriteRegistry * );
DIPIO_ERROR dipio_MeasurementWriteRegistryLabel ( dip_int, dip_String *,
                                                  dip_Resources );
DIPIO_ERROR dipio_MeasurementWriteRegistryWrite ( dip_int, dip_Measurement,
                                                  dip_String, dip_Boolean );
DIPIO_ERROR dipio_MeasurementWriteRegistryDescription ( dip_int, dip_String *,
                                                  dip_Resources );

#ifdef __cplusplus
}
#endif


#endif /* DIPIO_H */
