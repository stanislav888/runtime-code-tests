find_package(Threads REQUIRED)
set(THREADS_PREFER_PTHREAD_FLAG ON)

find_program( VALGRIND valgrind HINTS "/usr/bin" )

if( NOT EXISTS ${VALGRIND} )
    message( NOTICE "Valgrind executable is NOT found in your system. The appropriate tests are skipped." )
endif()

find_package(PkgConfig REQUIRED)
pkg_check_modules(GLIB2 IMPORTED_TARGET glib-2.0>=2.10 )
