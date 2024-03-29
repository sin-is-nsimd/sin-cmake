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


### @defgroup sin_cmake_doxygen Doxygen.
### 
### Doxygen documentation.

find_package(Doxygen)
if(DOXYGEN_FOUND)
  message(STATUS "Doxygen found: ${DOXYGEN}")
else()
  message(STATUS "Doxygen not found")
endif()

### @brief Adds Doxygen documentation.
###
### Doxygen documentation is added for the specified inputs.
###
### @param doxygen_target CMake target.
### @param "OUTPUT <ouput>" Ouput directory.
### @param "INPUTS <input>..." Input directories.
### @param "CUSTOM_LANGUAGE <language>" Language filter (optional).
###                                     Possible value: cmake
###
### **Example:**
### @include CMakeLists.txt
###
### @ingroup sin_cmake_doxygen
function(sin_add_doxygen doxygen_target)
  if(DOXYGEN_FOUND)
    # Args
    set(oneValueArgs OUTPUT CUSTOM_LANGUAGE)
    set(multiValueArgs INPUTS)
    cmake_parse_arguments(SIN_ADD_DOXYGEN "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Main page directory
    add_custom_target(${doxygen_target}_main_page_dir
      COMMAND ${CMAKE_COMMAND} -E make_directory ${SIN_ADD_DOXYGEN_OUTPUT})

    # Main page from the Readme.md
    add_custom_target(${doxygen_target}_main_page
      COMMAND
        python3 ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../bin/sin_doxygen_generate_main_page.py
        ${CMAKE_CURRENT_SOURCE_DIR}/Readme.md
        ${doxygen_target}_main_page.hpp
        ${PROJECT_NAME}
        ${PROJECT_VERSION}
      WORKING_DIRECTORY
        ${CMAKE_CURRENT_BINARY_DIR}
      DEPENDS
        ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../bin/sin_doxygen_generate_main_page.py
        ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt
        ${CMAKE_CURRENT_SOURCE_DIR}/Readme.md
        ${doxygen_target}_main_page_dir
    )

    # Options
    set(DOXYGEN_EXAMPLE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
    set(DOXYGEN_SORT_MEMBER_DOCS "NO")
    set(DOXYGEN_EXTRACT_PRIVATE "YES")

    # Language / Filter for CMake
    if ("${SIN_ADD_DOXYGEN_CUSTOM_LANGUAGE}" STREQUAL "cmake")
      set(DOXYGEN_FILE_PATTERNS "*.cmake")
      set(DOXYGEN_EXTENSION_MAPPING "cmake=C")
      set(DOXYGEN_FILTER_PATTERNS "*.cmake=${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../bin/sin_doxygen_filter_cmake.py")
    endif()

    # Generate html
    set(DOXYGEN_OUTPUT_DIRECTORY ${SIN_ADD_DOXYGEN_OUTPUT})
    message(STATUS "Add ${doxygen_target}")
    doxygen_add_docs(${doxygen_target}
      "${SIN_ADD_DOXYGEN_INPUTS}"
      "${CMAKE_CURRENT_BINARY_DIR}/${doxygen_target}_main_page.hpp"
      COMMENT "Generate doxygen of ${doxygen_target}")

    # Dependency with the main page
    add_dependencies(${doxygen_target} ${doxygen_target}_main_page)
  endif()
endfunction()
