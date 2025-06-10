# Copyright © 2025 Lénaïc Bagnères

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


### @defgroup sin_cmake_coverage Code coverage.
### 
### GCC and Clang coverage.

# Clang
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  # Clang version
  execute_process(
    COMMAND ${CMAKE_C_COMPILER} -dumpversion
    OUTPUT_VARIABLE SIN_C_CLANG_VERSION
  )
  string(REGEX MATCH "^[0-9]+" SIN_C_CLANG_VERSION_MAJOR "${SIN_C_CLANG_VERSION}")
  message(STATUS "Clang major version: ${SIN_C_CLANG_VERSION_MAJOR}")
  # llvm-profdata for C
  find_program(SIN_C_LLVM_PROFDATA_EXECUTABLE llvm-profdata-${SIN_C_CLANG_VERSION_MAJOR})
  if(SIN_C_LLVM_PROFDATA_EXECUTABLE)
    message(STATUS "llvm-profdata for C found: ${SIN_C_LLVM_PROFDATA_EXECUTABLE}")
  else()
    message(STATUS "llvm-profdata for C not found")
  endif()
  # llvm-cov for C
  find_program(SIN_C_LLVM_COV_EXECUTABLE llvm-cov-${SIN_C_CLANG_VERSION_MAJOR})
  if(SIN_C_LLVM_COV_EXECUTABLE)
    message(STATUS "llvm-cov for C found: ${SIN_C_LLVM_COV_EXECUTABLE}")
  else()
    message(STATUS "llvm-cov for C not found")
  endif()
  # Clang++ version
  execute_process(
    COMMAND ${CMAKE_CXX_COMPILER} -dumpversion
    OUTPUT_VARIABLE SIN_CXX_CLANG_VERSION
  )
  string(REGEX MATCH "^[0-9]+" SIN_CXX_CLANG_VERSION_MAJOR "${SIN_CXX_CLANG_VERSION}")
  message(STATUS "Clang++ major version: ${SIN_CXX_CLANG_VERSION_MAJOR}")
  # llvm-profdata for C++
  find_program(SIN_CXX_LLVM_PROFDATA_EXECUTABLE llvm-profdata-${SIN_CXX_CLANG_VERSION_MAJOR})
  if(SIN_CXX_LLVM_PROFDATA_EXECUTABLE)
    message(STATUS "llvm-profdata for C++ found: ${SIN_CXX_LLVM_PROFDATA_EXECUTABLE}")
  else()
    message(STATUS "llvm-profdata for C++ not found")
  endif()
  # llvm-cov for C++
  find_program(SIN_CXX_LLVM_COV_EXECUTABLE llvm-cov-${SIN_CXX_CLANG_VERSION_MAJOR})
  if(SIN_CXX_LLVM_COV_EXECUTABLE)
    message(STATUS "llvm-cov for C++ found: ${SIN_CXX_LLVM_COV_EXECUTABLE}")
  else()
    message(STATUS "llvm-cov for C++ not found")
  endif()
# GCC
elseif(CMAKE_C_COMPILER_ID MATCHES "GNU")
  # lcov for C
  find_program(SIN_C_LCOV_EXECUTABLE lcov)
  if(SIN_C_LCOV_EXECUTABLE)
    message(STATUS "lcov for C found: ${SIN_C_LCOV_EXECUTABLE}")
  else()
    message(STATUS "lcov for C not found")
  endif()
  # lcov for C++
  find_program(SIN_CXX_LCOV_EXECUTABLE lcov)
  if(SIN_CXX_LCOV_EXECUTABLE)
    message(STATUS "lcov for C++ found: ${SIN_CXX_LCOV_EXECUTABLE}")
  else()
    message(STATUS "lcov for C++ not found")
  endif()
endif()

### @brief Adds code coverage (HTML report using `lcov`) for a CMake target.
###
### Code coverage is generated for a CMake target (e.g. a test).
### Generated HTML files will be in
### `${CMAKE_CURRENT_BINARY_DIR}/${coverage_target}` directory.
###
### @param coverage_target CMake target name to generate the code coverage.
### @param "TARGET <target>" Actual CMake target to analyse.
###                          `--coverage` and other flags will be added to the
###                          compile and link flags.
### @param "LANG <lang>" Language of the target.
###                      Possible values are "C" or "CXX".
###
### **Example:**
### TODO
###
### @ingroup sin_cmake_coverage
function(sin_add_coverage coverage_target)
  # Args
  set(oneValueArgs TARGET LANG)
  cmake_parse_arguments(SIN_ADD_COVERAGE "" "${oneValueArgs}" "" ${ARGN})

  # Lang
  if(NOT DEFINED SIN_ADD_COVERAGE_LANG OR (NOT SIN_ADD_COVERAGE_LANG STREQUAL "C" AND NOT SIN_ADD_COVERAGE_LANG STREQUAL "CXX"))
    message(WARNING "sin_add_coverage(${coverage_target}): LANG argument is required, possible values are \"C\" or \"CXX\".")
    return()
  endif()
  set(${coverage_target}_lang "${SIN_ADD_COVERAGE_LANG}" PARENT_SCOPE)

  # Clang
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    # llvm-cov
    if (NOT SIN_${SIN_ADD_COVERAGE_LANG}_LLVM_COV_EXECUTABLE)
      message(WARNING "Code coverage with Clang requires llvm-cov executable.")
      return()
    endif()
    # Flags
      target_compile_options(${SIN_ADD_COVERAGE_TARGET} PRIVATE
        -fprofile-instr-generate -fcoverage-mapping
        -fno-inline)
      target_link_options(${SIN_ADD_COVERAGE_TARGET} PRIVATE
        -fprofile-instr-generate -fcoverage-mapping)
  # GCC
  elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    # lcov
    if (NOT SIN_${SIN_ADD_COVERAGE_LANG}_LCOV_EXECUTABLE)
      message(WARNING "Code coverage with GCC requires lcov executable.")
      return()
    endif()
    # Flags
    target_compile_options(${SIN_ADD_COVERAGE_TARGET} PRIVATE
      --coverage
      -fno-inline -fno-inline-small-functions -fno-default-inline)
    target_link_libraries(${SIN_ADD_COVERAGE_TARGET} PRIVATE
      --coverage)
  # Not supported
  else()
    message(WARNING "Code coverage is only supported with GCC or Clang.")
    return()
  endif()

  # Capture, extract and generate HTML
  message(STATUS "Add ${coverage_target} to generate code coverage HTML report")
  # Clang
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    add_custom_target(${coverage_target}
      COMMAND
        "${SIN_${SIN_ADD_COVERAGE_LANG}_LLVM_PROFDATA_EXECUTABLE}"
          merge
          -sparse "${CMAKE_CURRENT_BINARY_DIR}/${coverage_target}-*.profraw"
          -o "${coverage_target}.profdata"
      COMMAND
        "${SIN_${SIN_ADD_COVERAGE_LANG}_LLVM_COV_EXECUTABLE}"
          show $<TARGET_FILE:${SIN_ADD_COVERAGE_TARGET}>
          --instr-profile="${coverage_target}.profdata"
          --format=html
          --output-dir="${CMAKE_CURRENT_BINARY_DIR}/${coverage_target}"
          --project-title='Code Coverage for ${SIN_ADD_COVERAGE_TARGET}'
          --show-instantiations
      COMMENT "Generating LLVM code coverage report for ${SIN_ADD_COVERAGE_TARGET}"
      WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
      DEPENDS ${SIN_ADD_COVERAGE_TARGET}
    )
  # GCC
  elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    add_custom_target(${coverage_target}
      COMMAND
        "${SIN_${SIN_ADD_COVERAGE_LANG}_LCOV_EXECUTABLE}"
          --capture
          --directory `dirname $<TARGET_OBJECTS:${test_name}>`
          --output-file "${coverage_target}_full.info"
          --rc branch_coverage=1
          --ignore-errors inconsistent
          --ignore-errors mismatch
      COMMAND
        "${SIN_${SIN_ADD_COVERAGE_LANG}_LCOV_EXECUTABLE}"
          --extract
            "${coverage_target}_full.info"
            "${CMAKE_CURRENT_SOURCE_DIR}"
          -o "${coverage_target}_filtered.info"
      COMMAND
        genhtml
          "${coverage_target}_filtered.info"
          --output-directory "${CMAKE_CURRENT_BINARY_DIR}/${coverage_target}"
          --branch-coverage
      COMMENT "Generate code coverage for ${SIN_ADD_COVERAGE_TARGET}"
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      DEPENDS ${SIN_ADD_COVERAGE_TARGET}
    )
  endif()
endfunction()
