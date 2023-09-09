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


### @defgroup sin_cmake_test Tests & Examples.
### 
### Tests and examples targets.

include(CTest)
enable_testing()

include(GoogleTest)

find_program(VALGRIND_EXE "valgrind")
if(${VALGRIND_EXE} STREQUAL "VALGRIND_EXE-NOTFOUND")
  message(STATUS "valgrind not found")
  set(VALGRIND_EXE FALSE)
else()
  message(STATUS "valgrind found, VALGRIND_EXE = ${VALGRIND_EXE}")
endif()


### @brief Adds some C++ and C tests.
###
### The C++ and C tests are added. All `${DIRECTORY}/*.cpp` and
### `${DIRECTORY}/*.c` files are consired as tests.
###
### @param "DIRECTORY <directory>" Directory which contains the C++ and C tests
###                                (`tests` by default).
### @param "TYPE <type>" Type of the test (e.g. `test` or `example`); used only
###                      for display.
### @param "BINARY_PREFIX <prefix>" Binary prefix
###                                 (`${PARENT_DIRECTORY}_${TYPE}` by default).
### @param "LINK_LIBRARIES <lib>..." Link tests with these libraries.
### @param "ADD_VALGRIND" Tests run by `valgrind` are also added.
### @param "USE_GTEST" Tests use GoogleTest. With this option, tests link with
###                    `gtest` and the define `GTEST_SUITE_NAME` is set.
###
### **Example:**
### TODO
###
### @ingroup sin_cmake_test
function(sin_add_tests)
  # Args
  set(options ADD_VALGRIND USE_GTEST)
  set(oneValueArgs DIRECTORY BINARY_PREFIX TYPE)
  set(multiValueArgs LINK_LIBRARIES)
  cmake_parse_arguments(SIN_ADD_TESTS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  # Tests directory
  if(SIN_ADD_TESTS_DIRECTORY)
    set(tests_directory "${SIN_ADD_TESTS_DIRECTORY}")
    else()
      set(tests_directory "tests")
    endif()
  get_filename_component(tests_directory_absolute "${tests_directory}" ABSOLUTE)

  # Type
  if(SIN_ADD_TESTS_TYPE)
    set(type "${SIN_ADD_TESTS_TYPE}")
  else()
    set(type "test")
  endif()

  # Binary prefix
  if(SIN_ADD_TESTS_BINARY_PREFIX)
    set(binary_prefix "${SIN_ADD_TESTS_BINARY_PREFIX}")
  else()
    get_filename_component(tests_parent_directory_absolute "${tests_directory_absolute}" DIRECTORY)
    get_filename_component(tests_parent_directory "${tests_parent_directory_absolute}" NAME)
    set(binary_prefix "${tests_parent_directory}_${type}")
  endif()

  # Get all the tests
  file(GLOB_RECURSE tests "${tests_directory_absolute}/*.cpp" "${tests_directory_absolute}/*.c")

  # For each test
  message(STATUS "Add ${type}s from ${tests_directory}")
  foreach(test ${tests})
    # Compute test_name
    set(test_name "${test}")
    string(REPLACE "${tests_directory_absolute}" "${binary_prefix}" test_name "${test_name}")
    string(REPLACE "/" "_" test_name "${test_name}")
    string(REPLACE ".cpp" "" test_name "${test_name}")
    string(REPLACE ".c" "" test_name "${test_name}")

    # Test
    message(STATUS "- add ${type} ${test_name}")
    add_executable(${test_name} "${test}")
    if(SIN_ADD_TESTS_USE_GTEST)
      target_compile_definitions(${test_name} PRIVATE GTEST_SUITE_NAME=${TestSuiteName})
      target_link_libraries(${test_name} PRIVATE gtest ${SIN_ADD_TESTS_LINK_LIBRARIES})
    else()
      target_link_libraries(${test_name} PRIVATE ${SIN_ADD_TESTS_LINK_LIBRARIES})
    endif()

    # Add test
    if (SIN_ADD_TESTS_USE_GTEST)
      gtest_discover_tests(${test_name})
    else()
      add_test(NAME "${test_name}" COMMAND "${test_name}")
    endif()

    # Valgrind
    if(SIN_ADD_TESTS_ADD_VALGRIND AND VALGRIND_EXE)
      add_test(
        NAME "${test_name}_valgrind"
        COMMAND ${CMAKE_COMMAND} -E env "EXECUTED_BY_VALGRIND=1"
          "${VALGRIND_EXE}" "--error-exitcode=255" "--leak-check=full"
          "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${test_name}")
    endif()
  endforeach()
endfunction()

### @brief Adds some C++ and C examples.
###
### The C++ and C examples are added. All `examples/*.cpp` and `examples/*.c`
### files are consired as examples.
### This function uses `sin_add_tests` function.
###
### @param "BINARY_PREFIX <prefix>" Binary prefix
###                                 (`${PARENT_DIRECTORY}_example` by default).
### @param "LINK_LIBRARIES <lib>..." Link examples with these libraries.
### @param "ADD_VALGRIND" Examples run by `valgrind` are also added.
###
### **Example:**
### TODO
###
### @ingroup sin_cmake_library
function(sin_add_examples)
  # Add examples
  sin_add_tests(
    DIRECTORY "examples"
    TYPE "example"
    ${ARGN})
endfunction()
