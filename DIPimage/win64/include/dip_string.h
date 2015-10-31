#ifndef DIP_STRING_H
#define DIP_STRING_H
#ifdef __cplusplus
extern "C" {
#endif

#ifdef DIP_PORT_HAS_STRCASECMP
#include <string.h>
#include <strings.h>
#else
#include <string.h>
#define strcasecmp stricmp
#endif

typedef struct
{
   dip_int size;
   char *string;
} dip__String, *dip_String;

#ifndef SWIG

typedef struct
{
   dip_int size;
   dip_String *array;
} dip__StringArray, *dip_StringArray;

DIP_ERROR dip_StringNew        ( dip_String *, dip_int, char *, dip_Resources );
DIP_ERROR dip_StringFree       ( dip_String * );
DIP_ERROR dip_StringCopy       ( dip_String *, dip_String, dip_Resources );
DIP_ERROR dip_StringCompare    ( dip_String, dip_String, dip_Boolean * );
DIP_ERROR dip_StringCompareCaseInsensitive
                               ( dip_String, dip_String, dip_Boolean * );
DIP_ERROR dip_StringCat        ( dip_String *, dip_String, dip_String, char *,
                                 dip_Resources );
DIP_ERROR dip_StringCrop       ( dip_String, dip_int );
DIP_ERROR dip_StringAppend     ( dip_String, dip_String, char * );
DIP_ERROR dip_StringReplace    ( dip_String, dip_String, char * );

DIP_ERROR dip_StringArrayNew   ( dip_StringArray *, dip_int, dip_int, char *,
                                 dip_Resources );
DIP_ERROR dip_StringArrayFree  ( dip_StringArray * );
DIP_ERROR dip_StringArrayCopy  ( dip_StringArray *, dip_StringArray,
                                 dip_Resources );
DIP_ERROR dip_StringArrayCat   ( dip_StringArray *, dip_StringArray,
                                 dip_StringArray, char *, dip_Resources );
DIP_ERROR dip_UnderscoreSpaces ( dip_String );

#endif /* SWIG */

#ifdef __cplusplus
}
#endif
#endif
