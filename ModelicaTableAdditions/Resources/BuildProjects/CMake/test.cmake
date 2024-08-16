project(${CMAKE_PROJECT_NAME} CXX)

# Set up GoogleTest
include(FetchContent)

FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG v1.15.2
)

# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

# Disable building GMock
set(BUILD_GMOCK OFF CACHE BOOL "" FORCE)

# Do not install GTest
set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(googletest)

FetchContent_Declare(
  zlib
  GIT_REPOSITORY https://github.com/madler/zlib.git
  GIT_TAG v1.3.1
)

# Do not build zlib examples
set(ZLIB_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)

# Do not install zlib
set(SKIP_INSTALL_ALL TRUE CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(zlib)

# Patch zlib1.rc file to avoid syntax error
if(CYGWIN)
  file(READ "${zlib_SOURCE_DIR}/win32/zlib1.rc" ZLIB_RC_CONTENT)
  string(REPLACE "	MOVEABLE IMPURE LOADONCALL DISCARDABLE" "" ZLIB_RC_CONTENT "${ZLIB_RC_CONTENT}")
  file(WRITE "${zlib_SOURCE_DIR}/win32/zlib1.rc" "${ZLIB_RC_CONTENT}")
endif()

set(ZLIB_INCLUDE_DIR ${zlib_SOURCE_DIR} ${zlib_BINARY_DIR})

set_target_properties(gtest gtest_main zlib zlibstatic PROPERTIES FOLDER "Test/Third-party")

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
  target_compile_definitions(ModelicaTableAdditionsTestCommon PRIVATE -DHAVE_ZLIB=1)
  target_include_directories(ModelicaTableAdditionsTestCommon PRIVATE ${ZLIB_INCLUDE_DIR})

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
