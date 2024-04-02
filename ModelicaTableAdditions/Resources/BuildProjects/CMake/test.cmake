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
  set(MODELICA_TESTS
    Tables
  )
  foreach(TEST ${MODELICA_TESTS})
    add_executable(Test${TEST}
      "${MODELICA_TABLE_ADDITIONS_TEST_DIR}/${TEST}.cc"
      "${MODELICA_TABLE_ADDITIONS_TEST_DIR}/Common.cc"
    )
    target_compile_features(Test${TEST} PRIVATE cxx_std_17)
    set_target_properties(Test${TEST} PROPERTIES FOLDER "Test" CXX_EXTENSIONS OFF)
    target_link_libraries(Test${TEST} PRIVATE
      ModelicaTableAdditions
      ModelicaIOAdditions
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
