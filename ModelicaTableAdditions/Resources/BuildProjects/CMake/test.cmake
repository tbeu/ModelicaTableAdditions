project(${CMAKE_PROJECT_NAME}Tests CXX)

# Set up GoogleTest
include(FetchContent)

FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG v1.14.0
)

# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

# Disable building GMock
set(BUILD_GMOCK OFF CACHE BOOL "" FORCE)

# Do not install GTest 
set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(googletest)

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
  set_target_properties(ModelicaTableAdditionsTestCommon PROPERTIES FOLDER "Test")
  if(MSVC)
    target_compile_options(ModelicaTableAdditionsTestCommon PRIVATE /wd4267)
  endif()

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
else()
  message(WARNING
    " Testsuite not found in \"${MODELICA_TABLE_ADDITIONS_TEST_DIR}\"."
    " Set BUILD_TESTING to OFF to silence this warning."
  )
endif()
