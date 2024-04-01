if(NOT HAVE_LOCALE_H)
  add_definitions(-DNO_LOCALE)
endif()
if(NOT HAVE_PTHREAD_H AND NOT WIN32)
  add_definitions(-DNO_MUTEX)
endif()
if(HAVE_STDARG_H)
  add_definitions(-DHAVE_STDARG_H)
endif()
if(HAVE_UNISTD_H)
  add_definitions(-DHAVE_UNISTD_H)
endif()
if(HAVE_XLOCALE_H)
  add_definitions(-DHAVE_XLOCALE_H)
endif()
if(NOT HAVE_DIRENT_H AND NOT WIN32)
  add_definitions(-DNO_FILE_SYSTEM)
endif()
if(HAVE_MEMCPY)
  add_definitions(-DHAVE_MEMCPY)
endif()
if(HAVE_STRTOD_L)
  add_definitions(-DHAVE_STRTOD_L)
endif()

if(UNIX)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-attributes -fno-delete-null-pointer-checks")
elseif(MSVC)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS /W3)
endif()

include_directories("${MODELICA_RESOURCES_DIR}/C-Sources/parson")

set(TABLES_SOURCES
  "${MODELICA_RESOURCES_DIR}/C-Sources/ModelicaTableAdditions.c"
  "${MODELICA_RESOURCES_DIR}/C-Sources/ModelicaTableAdditions.h"
  "${MODELICA_RESOURCES_DIR}/C-Sources/ModelicaTableAdditionsUsertab.c"
  "${MODELICA_RESOURCES_DIR}/C-Sources/ModelicaMatIO.h"
  "${MODELICA_RESOURCES_DIR}/C-Sources/gconstructor.h"
  "${MODELICA_RESOURCES_DIR}/C-Sources/stdint_msvc.h"
  "${MODELICA_RESOURCES_DIR}/C-Sources/stdint_wrap.h"
  "${MODELICA_RESOURCES_DIR}/C-Sources/uthash.h"
  "${MODELICA_UTILITIES_INCLUDE_DIR}/ModelicaUtilities.h"
)

set(IO_SOURCES
  "${MODELICA_RESOURCES_DIR}/C-Sources/ModelicaIOAdditions.c"
  "${MODELICA_RESOURCES_DIR}/C-Sources/ModelicaIOAdditions.h"
  "${MODELICA_RESOURCES_DIR}/C-Sources/ModelicaMatIO.h"
  "${MODELICA_RESOURCES_DIR}/C-Sources/parson/parson.h"
  "${MODELICA_UTILITIES_INCLUDE_DIR}/ModelicaUtilities.h"
)

set(PARSON_SOURCES
  "${MODELICA_RESOURCES_DIR}/C-Sources/parson/parson.c"
  "${MODELICA_RESOURCES_DIR}/C-Sources/parson/parson.h"
)

add_library(ModelicaTableAdditions STATIC ${TABLES_SOURCES})
add_library(ModelicaIOAdditions STATIC ${IO_SOURCES})
add_library(parson STATIC ${PARSON_SOURCES})

if(MODELICA_DEBUG_TIME_EVENTS)
  target_compile_definitions(ModelicaTableAdditions PRIVATE -DDEBUG_TIME_EVENTS=1)
endif()
if(MODELICA_SHARE_TABLE_DATA)
  target_compile_definitions(ModelicaTableAdditions PRIVATE -DTABLE_SHARE=1)
endif()
if(NOT MODELICA_COPY_TABLE_DATA)
  target_compile_definitions(ModelicaTableAdditions PRIVATE -DNO_TABLE_COPY=1)
endif()
if(MODELICA_DUMMY_FUNCTION_USERTAB OR BUILD_TESTING)
  target_compile_definitions(ModelicaTableAdditions PRIVATE -DDUMMY_FUNCTION_USERTAB=1)
endif()
if(BUILD_TESTING)
  target_compile_definitions(ModelicaIOAdditions PRIVATE -DNO_FILE_SYSTEM=1)
endif()

install(
  TARGETS ModelicaTableAdditions ModelicaIOAdditions parson
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
