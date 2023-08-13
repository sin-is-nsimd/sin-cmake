cmake_minimum_required(VERSION 3.25)
project(sin-cmake
  VERSION 23.08.13
  DESCRIPTION "CMake helpers for C++ projects")

include(cmake/sin_add_doxygen.cmake)

sin_add_doxygen(sin_cmake_doxygen INPUTS "cmake" OUTPUT "./sin_cmake_doxygen")
