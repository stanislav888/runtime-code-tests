cmake_minimum_required(VERSION 3.25)
set(CMAKE_VERBOSE_MAKEFILE TRUE)
set(CMAKE_BUILD_TYPE Debug) # Sanitisers work wrong in Release.
Project(RuntimeCodeTests VERSION 1.0.0 
    DESCRIPTION "CMake-based playground to check different C/C++ code errors against different runtime sanitisers and Valgrind tools" 
    LANGUAGES C CXX )
include( CTest )
enable_testing()
include( cmake/find-3rd-party.cmake )
include( ${CMAKE_SOURCE_DIR}/cmake/add-target.cmake )
add_subdirectory( source buggy-progs )
