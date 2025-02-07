project(${CMAKE_PROJECT_NAME} CXX)

include(FetchContent)

FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG v1.16.0
  GIT_SHALLOW TRUE
)

FetchContent_Declare(
  zlib
  GIT_REPOSITORY https://github.com/madler/zlib.git
  GIT_TAG v1.3.1
  GIT_SHALLOW TRUE
)

FetchContent_Declare(
  hdf5
  GIT_REPOSITORY https://github.com/HDFGroup/hdf5.git
  GIT_TAG hdf5_1.14.4.3
  GIT_SHALLOW TRUE
)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
set(BUILD_GMOCK OFF CACHE BOOL "" FORCE)
set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)

set(ZLIB_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(INSTALL_BIN_DIR ${CMAKE_INSTALL_LIBDIR} CACHE PATH "" FORCE)
set(INSTALL_LIB_DIR ${CMAKE_INSTALL_LIBDIR} CACHE PATH "" FORCE)
set(SKIP_INSTALL_ALL OFF CACHE BOOL "" FORCE)
set(SKIP_INSTALL_FILES ON CACHE BOOL "" FORCE)
set(SKIP_INSTALL_HEADERS ON CACHE BOOL "" FORCE)
set(ZLIB_FOUND ON)
set(ZLIB_USE_EXTERNAL ON)

set(HDF5_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(HDF5_BUILD_HL_LIB OFF CACHE BOOL "" FORCE)
set(HDF5_BUILD_PARALLEL_TOOLS OFF CACHE BOOL "" FORCE)
set(HDF5_BUILD_TOOLS OFF CACHE BOOL "" FORCE)
set(HDF5_BUILD_UTILS OFF CACHE BOOL "" FORCE)
set(HDF5_DISABLE_COMPILER_WARNINGS ON CACHE BOOL "" FORCE)
set(HDF5_ENABLE_ALL_WARNINGS OFF CACHE BOOL "" FORCE)
set(HDF5_ENABLE_DEPRECATED_SYMBOLS OFF CACHE BOOL "" FORCE)
set(HDF5_ENABLE_NONSTANDARD_FEATURES OFF CACHE BOOL "" FORCE)
set(HDF5_ENABLE_SZIP_SUPPORT OFF CACHE BOOL "" FORCE)
set(HDF5_ENABLE_WARNINGS_AS_ERRORS OFF CACHE BOOL "" FORCE)
set(HDF5_ENABLE_Z_LIB_SUPPORT ON CACHE BOOL "" FORCE)
set(HDF5_EXPORTED_TARGETS)
set(HDF5_EXTERNALLY_CONFIGURED ON CACHE BOOL "" FORCE)
set(HDF5_INSTALL_NO_DEVELOPMENT ON CACHE BOOL "" FORCE)
set(HDF5_INSTALL_LIB_DIR ${CMAKE_INSTALL_LIBDIR} CACHE PATH "" FORCE)
set(HDF5_LIB_DEPENDENCIES zlib)
set(HDF5_TEST_CPP OFF CACHE BOOL "" FORCE)
set(HDF5_TEST_EXAMPLES OFF CACHE BOOL "" FORCE)
set(HDF5_TEST_SERIAL OFF CACHE BOOL "" FORCE)
set(HDF5_TEST_SWMR OFF CACHE BOOL "" FORCE)
set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(googletest zlib)

set(ZLIB_INCLUDE_DIR ${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})
set(ZLIB_INCLUDE_DIRS ${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})

FetchContent_MakeAvailable(hdf5)

set(HDF5_INCLUDE_DIR "${hdf5_SOURCE_DIR}/src" "${hdf5_SOURCE_DIR}/src/H5FDsubfiling" "${hdf5_BINARY_DIR}/src")

# Patch zlib1.rc file to avoid syntax error
if(CYGWIN)
  file(READ "${zlib_SOURCE_DIR}/win32/zlib1.rc" ZLIB_RC_CONTENT)
  string(REPLACE "	MOVEABLE IMPURE LOADONCALL DISCARDABLE" "" ZLIB_RC_CONTENT "${ZLIB_RC_CONTENT}")
  file(WRITE "${zlib_SOURCE_DIR}/win32/zlib1.rc" "${ZLIB_RC_CONTENT}")
endif()

set_target_properties(gtest gtest_main hdf5-static zlib zlibstatic PROPERTIES FOLDER "Test/Third-party")

set(MODELICA_TABLE_ADDITIONS_TEST_DIR "${MODELICA_TABLE_ADDITIONS_RESOURCES_DIR}/Test")
if(EXISTS "${MODELICA_TABLE_ADDITIONS_TEST_DIR}")
  set(MSL_URL https://raw.githubusercontent.com/modelica/ModelicaStandardLibrary/master)
  if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/ModelicaTableAdditionsTestCommon")
    file(DOWNLOAD
      "${MSL_URL}/.CI/Test/Common.c"
      "${CMAKE_CURRENT_BINARY_DIR}/ModelicaTableAdditionsTestCommon/Common.c")
    file(DOWNLOAD
      "${MSL_URL}/Modelica/Resources/C-Sources/ModelicaMatIO.c"
      "${CMAKE_CURRENT_BINARY_DIR}/ModelicaTableAdditionsTestCommon/ModelicaMatIO.c")
    file(DOWNLOAD
      "${MSL_URL}/Modelica/Resources/C-Sources/ModelicaMatIO.h"
      "${CMAKE_CURRENT_BINARY_DIR}/ModelicaTableAdditionsTestCommon/ModelicaMatIO.h")
    file(DOWNLOAD
      "${MSL_URL}/Modelica/Resources/C-Sources/read_data_impl.h"
      "${CMAKE_CURRENT_BINARY_DIR}/ModelicaTableAdditionsTestCommon/read_data_impl.h")
    file(DOWNLOAD
      "${MSL_URL}/Modelica/Resources/C-Sources/safe-math.h"
      "${CMAKE_CURRENT_BINARY_DIR}/ModelicaTableAdditionsTestCommon/safe-math.h")
    file(DOWNLOAD
      "${MSL_URL}/Modelica/Resources/C-Sources/snprintf.c"
      "${CMAKE_CURRENT_BINARY_DIR}/ModelicaTableAdditionsTestCommon/snprintf.c")
  endif()
  set(TEST_COMMON_SOURCES
    "${CMAKE_CURRENT_BINARY_DIR}/ModelicaTableAdditionsTestCommon/Common.c"
    "${CMAKE_CURRENT_BINARY_DIR}/ModelicaTableAdditionsTestCommon/ModelicaMatIO.c"
    "${CMAKE_CURRENT_BINARY_DIR}/ModelicaTableAdditionsTestCommon/ModelicaMatIO.h"
    "${CMAKE_CURRENT_BINARY_DIR}/ModelicaTableAdditionsTestCommon/read_data_impl.h"
    "${CMAKE_CURRENT_BINARY_DIR}/ModelicaTableAdditionsTestCommon/safe-math.h"
    "${CMAKE_CURRENT_BINARY_DIR}/ModelicaTableAdditionsTestCommon/snprintf.c"
    "${MODELICA_UTILITIES_INCLUDE_DIR}/ModelicaUtilities.h"
  )
  add_library(ModelicaTableAdditionsTestCommon STATIC ${TEST_COMMON_SOURCES})
  set_target_properties(ModelicaTableAdditionsTestCommon PROPERTIES FOLDER "Test/Third-party")
  if(MSVC)
    target_compile_options(ModelicaTableAdditionsTestCommon PRIVATE /wd4267)
  endif()
  target_compile_definitions(ModelicaTableAdditionsTestCommon PRIVATE -DHAVE_ZLIB=1 -DHAVE_HDF5=1)
  target_include_directories(ModelicaTableAdditionsTestCommon PRIVATE ${ZLIB_INCLUDE_DIR} ${HDF5_INCLUDE_DIR})

  set(MODELICA_TESTS
    Tables
    TablesFromCsvFile
    TablesFromEpwFile
    TablesFromJsonFile
    TablesFromMatFile
    TablesFromMosFile
  )
  foreach(TEST ${MODELICA_TESTS})
    add_executable(Test${TEST}
      "${MODELICA_TABLE_ADDITIONS_TEST_DIR}/${TEST}.cc"
      "${MODELICA_TABLE_ADDITIONS_TEST_DIR}/Constants.h"
    )
    target_compile_features(Test${TEST} PRIVATE cxx_std_17)
    set_target_properties(Test${TEST} PROPERTIES FOLDER "Test" CXX_EXTENSIONS OFF)
    target_link_libraries(Test${TEST} PRIVATE
      ModelicaTableAdditions
      ModelicaIOAdditions
      ModelicaTableAdditionsTestCommon
      parson
      gtest
      hdf5-static
      zlibstatic
    )
    if(UNIX)
      target_link_libraries(Test${TEST} PRIVATE m)
    endif()
    add_test(
      NAME Test${TEST}
      COMMAND Test${TEST}
      WORKING_DIRECTORY "${MODELICA_TABLE_ADDITIONS_TEST_DIR}"
    )
  endforeach()
  configure_file(
    ${CMAKE_SOURCE_DIR}/BuildProjects/CMake/Modelica_Table_Additions.gta.runsettings.in
    ${CMAKE_BINARY_DIR}/Modelica_Table_Additions.gta.runsettings
    @ONLY
  )
else()
  message(WARNING
    " Testsuite not found in \"${MODELICA_TABLE_ADDITIONS_TEST_DIR}\"."
    " Set BUILD_TESTING to OFF to silence this warning."
  )
endif()
