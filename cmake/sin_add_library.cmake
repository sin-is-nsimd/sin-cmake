# Copyright © 2023 Lénaïc Bagnères

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


### @defgroup sin_cmake_library Library.
### 
### Library target.

### @brief Adds a C++ or a C library.
###
### The C++ or the C library is added. The header files are `include/*.hpp` and
### `include/*.h`. The source files are `src/*.cpp` and `src/*.c`.
###
### @param library_target CMake target.
### @param "DIRECTORY <directory>" Directory which contains `include/*.h[pp]`
###                                and `src/*.c[pp]` (empty by default).
### @param "EXTRA_HEADERS <path>..." Extra header files.
### @param "EXTRA_SOURCES <path>..." Extra source files.
###
### **Example:**
### TODO
###
### @ingroup sin_cmake_library
function(sin_add_library library_target)
  # Args
  set(oneValueArgs DIRECTORY)
  set(multiValueArgs EXTRA_HEADERS EXTRA_SOURCES)
  cmake_parse_arguments(SIN_ADD_LIBRARY "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  # Library directory
  if(SIN_ADD_LIBRARY_DIRECTORY)
    set(library_directory "${SIN_ADD_LIBRARY_DIRECTORY}/")
  endif()

  # Sources
  file(GLOB_RECURSE ${library_target}_headers "${library_directory}include/*.hpp" "${library_directory}include/*.h")
  file(GLOB_RECURSE ${library_target}_sources "${library_directory}src/*.cpp" "${library_directory}src/*.c")

  # Extra headers and sources
  list(APPEND ${library_target}_headers "${SIN_ADD_LIBRARY_EXTRA_HEADERS}")
  list(APPEND ${library_target}_sources "${SIN_ADD_LIBRARY_EXTRA_SOURCES}")

  # Library
  message(STATUS "Add library ${library_target}")
  add_library(${library_target} SHARED ${${library_target}_headers} ${${library_target}_sources})
  set_property(TARGET ${library_target} PROPERTY POSITION_INDEPENDENT_CODE ON)
  target_include_directories(${library_target} BEFORE PUBLIC "${library_directory}include")
endfunction()
