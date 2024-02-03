# Determines the Modelica platform name of the current platform
function(get_modelica_platform_name var)
  set(IS_64BIT_BUILD false)
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
      set(IS_64BIT_BUILD true)
  endif()
  if(APPLE)
    list(LENGTH CMAKE_OSX_ARCHITECTURES NUMBER_OF_OSX_ARCHITECTURES)
    if (NUMBER_OF_OSX_ARCHITECTURES EQUAL 0)
      if (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
        set(PLATFORM_PATH_SUFFIX "darwin64")
      elseif (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "arm64")
        set(PLATFORM_PATH_SUFFIX "aarch64-darwin")
      else()
        message(FATAL_ERROR "Unknown macOS architecture CMAKE_HOST_SYSTEM_PROCESSOR=${CMAKE_HOST_SYSTEM_PROCESSOR}.")
      endif()
    elseif(NUMBER_OF_OSX_ARCHITECTURES EQUAL 1)
      if (CMAKE_OSX_ARCHITECTURES STREQUAL "x86_64")
        set(PLATFORM_PATH_SUFFIX "darwin64")
      elseif (CMAKE_OSX_ARCHITECTURES STREQUAL "arm64")
        set(PLATFORM_PATH_SUFFIX "aarch64-darwin")
      else()
        message(FATAL_ERROR "Unknown macOS architecture CMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}.")
      endif()
    else()
      message(FATAL_ERROR "Universal builds not supported CMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}.")
    endif()
  elseif(UNIX)
    if(IS_64BIT_BUILD)
      set(PLATFORM_PATH_SUFFIX "linux64")
    else()
      set(PLATFORM_PATH_SUFFIX "linux32")
    endif()
  elseif(MSVC OR MINGW)
    if(IS_64BIT_BUILD)
      set(PLATFORM_PATH_SUFFIX "win64")
    else()
      set(PLATFORM_PATH_SUFFIX "win32")
    endif()
  else()
    message(FATAL_ERROR "Unsupported compiler environment")
  endif()

  message(STATUS "Building for Modelica platform ${PLATFORM_PATH_SUFFIX}")

  set(${var} ${PLATFORM_PATH_SUFFIX} PARENT_SCOPE)
endfunction()

# Determines the Modelica platform name of the current platform, including VS version
function(get_modelica_platform_name_with_compiler_version var)

  get_modelica_platform_name(PLATFORM_PATH_SUFFIX)

  if(WIN32)
    if(MSVC_VERSION EQUAL 1400)
      set(PLATFORM_PATH_SUFFIX "${PLATFORM_PATH_SUFFIX}/vs2005")
    elseif(MSVC_VERSION EQUAL 1500)
      set(PLATFORM_PATH_SUFFIX "${PLATFORM_PATH_SUFFIX}/vs2008")
    elseif(MSVC_VERSION EQUAL 1600)
      set(PLATFORM_PATH_SUFFIX "${PLATFORM_PATH_SUFFIX}/vs2010")
    elseif(MSVC_VERSION EQUAL 1700)
      set(PLATFORM_PATH_SUFFIX "${PLATFORM_PATH_SUFFIX}/vs2012")
    elseif(MSVC_VERSION EQUAL 1800)
      set(PLATFORM_PATH_SUFFIX "${PLATFORM_PATH_SUFFIX}/vs2013")
    elseif(MSVC_VERSION EQUAL 1900)
      set(PLATFORM_PATH_SUFFIX "${PLATFORM_PATH_SUFFIX}/vs2015")
    elseif(MSVC_VERSION GREATER_EQUAL 1910 AND MSVC_VERSION LESS 1920)
      set(PLATFORM_PATH_SUFFIX "${PLATFORM_PATH_SUFFIX}/vs2017")
    elseif(MSVC_VERSION GREATER_EQUAL 1920 AND MSVC_VERSION LESS 1930)
      set(PLATFORM_PATH_SUFFIX "${PLATFORM_PATH_SUFFIX}/vs2019")
    elseif(MSVC_VERSION GREATER_EQUAL 1930 AND MSVC_VERSION LESS 1940)
      set(PLATFORM_PATH_SUFFIX "${PLATFORM_PATH_SUFFIX}/vs2022")
    endif()
  endif()

  set(${var} ${PLATFORM_PATH_SUFFIX} PARENT_SCOPE)
endfunction()
