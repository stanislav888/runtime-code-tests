set( CMAKE_CXX_COMPILE_FEATURES cxx_std_23 )
add_compile_options( "-fno-omit-frame-pointer" ) # Common for all tests
add_compile_options( "-fno-sanitize-recover=all" )
include_directories( "include" )

# Handling *.cpp & *.c sources without additional compilation flags and libraries from directory sourcce/regular-buggy-sources
handle_regular_sources( "${CMAKE_CURRENT_SOURCE_DIR}" )

# Complicated program example #1: using imported library
if( ${GLIB2_FOUND} )
    add_buggy_targets( "complicated/glib-leak.c" PkgConfig::GLIB2 )
endif()

# Complicated program example #2: using custom build library
add_library( sample SHARED "complicated/sample-lib.c" )
add_buggy_targets( "complicated/test-lib-overflow.c" sample )

add_library( sample2 SHARED "complicated/sample-lib2.c" )
add_buggy_targets( "complicated/test-lib-overflow2.c" sample2 )

# function( add_regular_buggy_targets SOURCE )
# function( add_buggy_targets SOURCE TARGETS_DEPENDENCIES )
# TARGETS_DEPENDENCIES must be a target in terms of CMake

# Please add your customised sources below.