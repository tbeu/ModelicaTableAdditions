/* ModelicaUtilities.h - External utility functions header

   Copyright (C) 2010-2025, Modelica Association and contributors
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause
*/

/* Utility functions which can be called by external Modelica functions.

   These functions are defined in section 12.9.6 of the Modelica Specification 3.6.

   A generic C-implementation of these functions cannot be given,
   because it is tool dependent how strings are output in a
   console or window of the respective simulation tool.
*/

#ifndef MODELICA_UTILITIES_H
#define MODELICA_UTILITIES_H

#include <stddef.h>
#include <stdarg.h>

#if defined(__cplusplus)
extern "C" {
#endif

/*
  Some of the functions never return to the caller. In order to compile
  external Modelica C-code in most compilers, noreturn attributes need to
  be present to avoid warnings or errors.

  The following macro handles the noreturn attribute according to the
  C23/C11/C++11 standard with fallback to the MSVC/Borland extension.
*/
#undef MODELICA_NORETURN
#if (defined(__STDC_VERSION__) && __STDC_VERSION__ >= 202311L) || \
    (defined(__cplusplus) && __cplusplus >= 201103L && \
    (!defined(__GNUC__) || __GNUC__ >= 5 || (__GNUC__ == 4 && defined(__GNUC_MINOR__) && __GNUC_MINOR__ >= 8)))
#define MODELICA_NORETURN [[noreturn]]
#elif defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L
#define MODELICA_NORETURN _Noreturn
#elif (defined(_MSC_VER) && _MSC_VER >= 1200) || defined(__BORLANDC__)
#define MODELICA_NORETURN __declspec(noreturn)
#else
#define MODELICA_NORETURN
#endif

/*
  The following macros handle format attributes for type-checks against a
  format string.
*/

#if defined(__clang__)
/* Encapsulated for Clang since GCC fails to process __has_attribute */
#if __has_attribute(format)
#define MODELICA_FORMATATTR_PRINTF __attribute__((format(printf, 1, 2)))
#define MODELICA_FORMATATTR_VPRINTF __attribute__((format(printf, 1, 0)))
#else
#define MODELICA_FORMATATTR_PRINTF
#define MODELICA_FORMATATTR_VPRINTF
#endif
#elif defined(__GNUC__) && __GNUC__ >= 3
#define MODELICA_FORMATATTR_PRINTF __attribute__((format(printf, 1, 2)))
#define MODELICA_FORMATATTR_VPRINTF __attribute__((format(printf, 1, 0)))
#else
#define MODELICA_FORMATATTR_PRINTF
#define MODELICA_FORMATATTR_VPRINTF
#endif

void ModelicaMessage(const char *string);
/*
Output the message string (no format control).
*/

void ModelicaFormatMessage(const char *format, ...) MODELICA_FORMATATTR_PRINTF;
/*
Output the message under the same format control as the C-function printf.
*/

void ModelicaVFormatMessage(const char *format, va_list args) MODELICA_FORMATATTR_VPRINTF;
/*
Output the message under the same format control as the C-function vprintf.
*/

MODELICA_NORETURN void ModelicaError(const char *string);
/*
Output the error message string (no format control). This function
never returns to the calling function, but handles the error
similarly to an assert in the Modelica code.
*/

void ModelicaWarning(const char *string);
/*
Output the warning message string (no format control).
*/

void ModelicaFormatWarning(const char *format, ...) MODELICA_FORMATATTR_PRINTF;
/*
Output the warning message under the same format control as the C-function printf.
*/

void ModelicaVFormatWarning(const char *format, va_list args) MODELICA_FORMATATTR_VPRINTF;
/*
Output the warning message under the same format control as the C-function vprintf.
*/

MODELICA_NORETURN void ModelicaFormatError(const char *format, ...) MODELICA_FORMATATTR_PRINTF;
/*
Output the error message under the same format control as the C-function
printf. This function never returns to the calling function,
but handles the error similarly to an assert in the Modelica code.
*/

MODELICA_NORETURN void ModelicaVFormatError(const char *format, va_list args) MODELICA_FORMATATTR_VPRINTF;
/*
Output the error message under the same format control as the C-function
vprintf. This function never returns to the calling function,
but handles the error similarly to an assert in the Modelica code.
*/

char* ModelicaAllocateString(size_t len);
/*
Allocate memory for a Modelica string which is used as return
argument of an external Modelica function. Note, that the storage
for string arrays (= pointer to string array) is still provided by the
calling program, as for any other array. If an error occurs, this
function does not return, but calls "ModelicaError".
*/

char* ModelicaAllocateStringWithErrorReturn(size_t len);
/*
Same as ModelicaAllocateString, except that in case of error, the
function returns 0. This allows the external function to close files
and free other open resources in case of error. After cleaning up
resources use ModelicaError or ModelicaFormatError to signal
the error.
*/

char* ModelicaDuplicateString(const char* str);
/*
Duplicate (= allocate memory and deep copy) a Modelica string which
is used as return argument of an external Modelica function. Note,
that the storage for string arrays (= pointer to string array) is still
provided by the calling program, as for any other array. If an error
occurs, this function does not return, but calls "ModelicaError".
*/

char* ModelicaDuplicateStringWithErrorReturn(const char* str);
/*
Same as ModelicaDuplicateString, except that in case of error, the
function returns 0. This allows the external function to close files
and free other open resources in case of error. After cleaning up
resources use, ModelicaError or ModelicaFormatError to signal
the error.
*/

#undef MODELICA_NORETURN
#undef MODELICA_FORMATATTR_PRINTF
#undef MODELICA_FORMATATTR_VPRINTF

#if defined(__cplusplus)
}
#endif

#endif
