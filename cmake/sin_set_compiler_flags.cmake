# Copyright © 2023-2025 Lénaïc Bagnères

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


### @defgroup sin_cmake_flags Compiler Flags.
### 
### Compiler flags.

# Possible `CMAKE_CXX_COMPILER_ID`: AppleClang, Clang, GNU, Intel, MSVC
# https://stackoverflow.com/a/10055571
if (CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang" OR
    CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
 set(sin_compiler_flags_family "clang")
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  set(sin_compiler_flags_family "gcc")
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
  # TODO
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  set(sin_compiler_flags_family "msvc")
endif()

set(sin_clang_flag_sse2 -msse2)
set(sin_gcc_flag_sse2 -msse2)
set(sin_msvc_flag_sse2 /DSSE2 /arch:SSE2)
set(sin_flag_sse2 "${sin_${sin_compiler_flags_family}_flag_sse2}")

set(sin_clang_flag_sse42 -msse4.2)
set(sin_gcc_flag_sse42 -msse4.2)
set(sin_msvc_flag_sse42 /DSSE42 /arch:SSE4.2)
set(sin_flag_sse42 "${sin_${sin_compiler_flags_family}_flag_sse42}")

set(sin_clang_flag_avx -mavx)
set(sin_gcc_flag_avx -mavx -mno-avx256-split-unaligned-load -mno-avx256-split-unaligned-store)
set(sin_msvc_flag_avx /DAVX /arch:AVX)
set(sin_flag_avx "${sin_${sin_compiler_flags_family}_flag_avx}")

set(sin_clang_flag_avx2 -mavx2 -mfma)
set(sin_gcc_flag_avx2 -mavx2 -mfma -mno-avx256-split-unaligned-load -mno-avx256-split-unaligned-store)
set(sin_msvc_flag_avx2 /DAVX2 /arch:AVX2)
set(sin_flag_avx2 ${sin_${sin_compiler_flags_family}_flag_avx2})

set(sin_clang_flag_avx512_knl -mavx512f -mavx512pf -mavx512er -mavx512cd)
set(sin_gcc_flag_avx512_knl -mavx512f -mavx512pf -mavx512er -mavx512cd)
set(sin_msvc_flag_avx512_knl /DAVX512_KNL /arch:AVX512)
set(sin_flag_avx512_knl ${sin_${sin_compiler_flags_family}_flag_avx512_knl})

set(sin_clang_flag_avx512_skylake -mavx512f -mavx512dq -mavx512cd -mavx512bw -mavx512vl)
set(sin_gcc_flag_avx512_skylake -mavx512f -mavx512dq -mavx512cd -mavx512bw -mavx512vl)
set(sin_msvc_flag_avx512_skylake /DAVX512_SKYLAKE /arch:AVX512)
set(sin_flag_avx512_skylake ${sin_${sin_compiler_flags_family}_flag_avx512_skylake})

### @brief Set the C and the C++ flags.
###
### TODO.
###
### **Example:**
### TODO
###
### @ingroup sin_cmake_flags
macro(sin_set_compiler_flags)
  # C
  set(CMAKE_C_EXTENSIONS OFF)
  # set(CMAKE_C_STANDARD 11)
  # TODO

  # C++
  set(CMAKE_CXX_EXTENSIONS OFF)
  # set(CMAKE_CXX_STANDARD 14)
  # TODO
endmacro()
