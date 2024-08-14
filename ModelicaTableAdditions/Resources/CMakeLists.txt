cmake_minimum_required(VERSION 3.21)

if(POLICY CMP0091)
  cmake_policy(SET CMP0091 NEW)
  if(WIN32)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
  endif()
endif()

project(Modelica_Table_Additions C)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

include(BuildProjects/CMake/Modelica_platform.cmake)

set(MODELICA_TABLE_ADDITIONS_RESOURCES_DIR "${CMAKE_SOURCE_DIR}")
set(CMAKE_INSTALL_PREFIX "${MODELICA_TABLE_ADDITIONS_RESOURCES_DIR}" CACHE PATH "Library installation prefix path (don't change)" FORCE)

get_modelica_platform_name_with_compiler_version(MODELICA_PLATFORM_NAME)
set(CMAKE_INSTALL_LIBDIR "${CMAKE_INSTALL_PREFIX}/Library/${MODELICA_PLATFORM_NAME}" CACHE PATH "Library installation path (don't change)" FORCE)

include(BuildProjects/CMake/compiler_options.cmake)
include(BuildProjects/CMake/options.cmake)

if(BUILD_TESTING)
  enable_testing()
  if(PROJECT_IS_TOP_LEVEL)
    include(CTest)
  endif()
  include(BuildProjects/CMake/Modelica_utilities.cmake)
  include(BuildProjects/CMake/test.cmake)
endif()

include(BuildProjects/CMake/src.cmake)
