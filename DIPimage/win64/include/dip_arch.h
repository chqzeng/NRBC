#ifndef DIP_ARCH_H
#define DIP_ARCH_H

#define DIP_ARCH Cygwin

/* The unsigned integer types (uint) */
typedef unsigned char dip_uint8;
typedef unsigned short dip_uint16;
typedef unsigned int dip_uint32;

/* The signed integer types (sint) */
typedef signed char dip_sint8;
typedef signed short dip_sint16;
typedef signed int dip_sint32;

/* This is a 64-bit machine */
#define DIP_64BITS
typedef unsigned long long dip_uint64;
typedef signed long long dip_sint64;

/* The generic integer types */
typedef dip_sint64 dip_int;
typedef dip_sint64 dip_sint;
typedef dip_uint64 dip_uint;


#define _POSIX_SOURCE 1

#define DIP_PORT_HAS_NO_EXP2
#define DIP_PORT_HAS_NO_EXP10
#define DIP_PORT_HAS_NO_LOG2

#ifdef DIP_DLL_CREATE
#define DIP_EXPORT __declspec(dllexport)
#else
#define DIP_EXPORT __declspec(dllimport)
#endif

#ifdef DIPIO_DLL_CREATE
#define DIPIO_EXPORT __declspec(dllexport)
#else
#define DIPIO_EXPORT __declspec(dllimport)
#endif

#ifdef DML_DLL_CREATE
#define DML_EXPORT __declspec(dllexport)
#else
#define DML_EXPORT __declspec(dllimport)
#endif

#define DIP_ERROR DIP_EXPORT dip_Error
#define DIPIO_ERROR DIPIO_EXPORT dip_Error

#define DIPIO_DIRECTORY_SEPARATOR '\\'
#define DIPIO_EXTENSION_SEPARATOR '.'

#endif
