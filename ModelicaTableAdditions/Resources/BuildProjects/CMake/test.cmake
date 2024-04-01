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

FetchContent_MakeAvailable(googletest)

set(MODELICA_TEST_SOURCE_DIR "${PROJECT_SOURCE_DIR}/../../../../.CI/Test")
get_filename_component(ABSOLUTE_MODELICA_TEST_SOURCE_DIR "${MODELICA_TEST_SOURCE_DIR}" ABSOLUTE)
if(EXISTS "${ABSOLUTE_MODELICA_TEST_SOURCE_DIR}")
  set(MODELICA_TESTS
    Tables
  )
  foreach(TEST ${MODELICA_TESTS})
    add_executable(Test${TEST}
      "${ABSOLUTE_MODELICA_TEST_SOURCE_DIR}/${TEST}.cc"
      "${ABSOLUTE_MODELICA_TEST_SOURCE_DIR}/Common.cc"
    )
    target_compile_features(Test${TEST} PRIVATE cxx_std_17)
    target_link_libraries(Test${TEST} PRIVATE
      ModelicaTableAdditions
      ModelicaIOAdditions
      gtest
    )
    if(UNIX)
      target_link_libraries(Test${TEST} PRIVATE m)
    endif()
    add_test(
      NAME Test${TEST}
      COMMAND Test${TEST}
      WORKING_DIRECTORY "${ABSOLUTE_MODELICA_TEST_SOURCE_DIR}"
    )
  endforeach()
else()
  message(WARNING
    " Testsuite not found in \"${ABSOLUTE_MODELICA_TEST_SOURCE_DIR}\"."
    " Set BUILD_TESTING to OFF to silence this warning."
  )
endif()
