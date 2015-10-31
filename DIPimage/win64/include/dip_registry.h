#ifndef DIP_REGISTRY_H
#define DIP_REGISTRY_H
#ifdef __cplusplus
extern "C" {
#endif

#define DIP__REGISTRY_HANDLERS_VALID 1

DIP_EXPORT extern const char dip_errorRegistryIDNotRegistered[];
DIP_EXPORT extern const char dip_errorRegistryIDAlreadyRegistered[];
DIP_EXPORT extern const char dip_errorRegistryClassNotRegistered[];
DIP_EXPORT extern const char dip_errorRegistryClassAlreadyRegistered[];
DIP_EXPORT extern const char dip_errorRegistryIncompleteRegistry[];

#define DIP_E_REGISTRY_ID_NOT_REGISTERED \
dip_errorRegistryIDNotRegistered
#define DIP_E_REGISTRY_ID_ALREADY_REGISTERED \
dip_errorRegistryIDAlreadyRegistered
#define DIP_E_REGISTRY_CLASS_NOT_REGISTERED \
dip_errorRegistryClassNotRegistered
#define DIP_E_REGISTRY_CLASS_ALREADY_REGISTERED \
dip_errorRegistryClassAlreadyRegistered
#define DIP_E_REGISTRY_INCOMPLETE_REGISTRY \
dip_errorRegistryIncompleteRegistry

#define DIP_REGISTRY_CLASS_ID 0

#define DIP_REGISTRY_CLASS_IMAGE          dip_RegistryImageClass()
#define DIP_REGISTRY_CLASS_HISTOGRAM      dip_RegistryHistogramClass()

dip_int dip_RegistryImageClass( void );
dip_int dip_RegistryHistogramClass( void );

typedef struct
{
	dip_int id;
	dip_int classID;
	void *data;
	dip_Error (*free)( void *);
} dip_Registry;

typedef struct
{
	dip_int size;
	dip_Registry *array;
} dip__RegistryArray, *dip_RegistryArray;

typedef dip_Error (*dip_RegistryClassFree) ( dip_int );

DIP_ERROR dip_RegisterClass    ( dip_int, dip_RegistryClassFree );
DIP_ERROR dip_RegistryClassList( dip_IntegerArray *, dip_Resources );
DIP_ERROR dip_UnregisterClass  ( dip_int );

DIP_ERROR dip_Register         ( dip_Registry );
DIP_ERROR dip_Unregister       ( dip_int, dip_int );
DIP_ERROR dip_RegistryGet      ( dip_int, dip_int, void ** );
DIP_ERROR dip_RegistryList     ( dip_IntegerArray *, dip_int, dip_Resources );
DIP_ERROR dip_RegistryValid    ( dip_int, dip_int, dip_Boolean * );
DIP_ERROR dip_RegistryArrayNew ( dip_RegistryArray *, dip_int, dip_Resources );
DIP_ERROR dip_RegistryArrayFree( dip_RegistryArray * );

/* this function should not be exported: its called by dip_Initialise() */
dip_Error dip_RegistryInitialise ( void );
dip_Error dip_RegistryExit       ( void );

/* three macros to easen the creation of standard registry access functions */
#ifdef DIP__REGISTRY_LIST_FUNCTION
#undef DIP__REGISTRY_LIST_FUNCTION
#else
#define DIP__REGISTRY_LIST_FUNCTION( name, class )                          \
dip_Error dip_ ## name ## RegistryList                                      \
(                                                                           \
   dip_IntegerArray *id,                                                    \
   dip_Resources resources                                                  \
)                                                                           \
{                                                                           \
   DIP_FN_DECLARE(DIP_MAKE_STRING(dip_ ## name ## RegistryList));           \
                                                                            \
   DIPXJ( dip_RegistryList( id, DIP_REGISTRY_CLASS_ ## class, resources )); \
                                                                            \
dip_error:                                                                  \
   DIP_FN_EXIT;                                                             \
}
#endif

#ifdef DIP__REGISTRY_GET_FUNCTION
#undef DIP__REGISTRY_GET_FUNCTION
#else
#define DIP__REGISTRY_GET_FUNCTION( name, class )                           \
dip_Error dip_ ## name ## RegistryGet                                       \
(                                                                           \
   dip_int id,                                                              \
   dip_ ## name *out                                                        \
)                                                                           \
{                                                                           \
   DIP_FN_DECLARE(DIP_MAKE_STRING(dip_ ## name ## RegistryGet));            \
   void *data;                                                              \
   DIPXJ( dip_RegistryGet ( id, DIP_REGISTRY_CLASS_ ## class, &data ));     \
   *out = ( dip_ ## name ) data;                                                             \
                                                                            \
dip_error:                                                                  \
   DIP_FN_EXIT;                                                             \
}
#endif

#ifdef DIP__REGISTRY_FREE_FUNCTION
#undef DIP__REGISTRY_FREE_FUNCTION
#else
#define DIP__REGISTRY_FREE_FUNCTION( name )                                 \
dip_Error dip_ ## name ## RegistryFree                                      \
( dip_int classID )                                                           \
{                                                                           \
   DIP_FNR_DECLARE(DIP_MAKE_STRING(dip_ ## name ## RegistryFree));          \
   dip_IntegerArray id;                                                     \
   dip_ ## name thing;                                                      \
   dip_int ii;                                                              \
                                                                            \
   DIP_FNR_INITIALISE;                                                      \
   DIPXJ( dip_ ## name ## RegistryList( &id, rg ));                         \
   for( ii = 0; ii < id->size; ii++ )                                       \
   {                                                                        \
      DIPXJ( dip_ ## name ## RegistryGet( id->array[ ii ], &thing ));       \
      DIPXJ( dip_ ## name ## Free( &thing ));                               \
   }                                                                        \
dip_error:                                                                  \
   DIP_FNR_EXIT;                                                            \
}
#endif

#ifdef __cplusplus
}
#endif
#endif
