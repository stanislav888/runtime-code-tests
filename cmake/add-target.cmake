function( handle_regular_sources SOURCE_DIR )
    file( GLOB SOURCES_LIST_CPP LIST_DIRECTORIES false RELATIVE "${SOURCE_DIR}" "${SOURCE_DIR}/regular/*.cpp" )
    file( GLOB SOURCES_LIST_C LIST_DIRECTORIES false RELATIVE "${SOURCE_DIR}" "${SOURCE_DIR}/regular/*.c" )
    list( APPEND SOURCES_LIST ${SOURCES_LIST_C} ${SOURCES_LIST_CPP} )

    foreach(FILE IN LISTS SOURCES_LIST )
        add_regular_buggy_targets( ${FILE} )
    endforeach()
    
endfunction()

function( add_regular_buggy_targets SOURCE )
    add_buggy_targets( ${SOURCE} FALSE )
endfunction()

function( add_buggy_targets SOURCE TARGETS_DEPENDENCIES )
    # Testcases for every source file(=exe)
    cmake_path( GET SOURCE FILENAME TARGET_PREF )
    cmake_path( REMOVE_EXTENSION TARGET_PREF OUTPUT_VARIABLE TARGET_PREF )
    add_buggy_exe( ${TARGET_PREF}_addr-san "-fsanitize=address" asan )
    add_buggy_exe( ${TARGET_PREF}_thrd-san "-fsanitize=thread" tsan )
    add_buggy_exe( ${TARGET_PREF}_undef-san "-fsanitize=undefined,float-divide-by-zero,float-cast-overflow" ubsan)
    add_buggy_exe( ${TARGET_PREF}_leak-san "-fsanitize=leak" lsan )

    # It doesn't compile properly at the moment even on Clang
    # add_buggy_exe( ${TARGET_PREF}_mem-san "-fsanitize=memory;-fsanitize-memory-track-origins" msan )

    set( REGLR_TARGET ${TARGET_PREF} )
    add_buggy_exe( ${REGLR_TARGET} "" "" ) # Plain executable call with the return code checking

    if( EXISTS ${VALGRIND} )
        add_valgrind_test_runner( ${REGLR_TARGET} memcheck  "--leak-check=full;--show-leak-kinds=all;--read-var-info=yes;--leak-check-heuristics=full" )
        add_valgrind_test_runner( ${REGLR_TARGET} helgrind  "")
        add_valgrind_test_runner( ${REGLR_TARGET} drd  "")
    endif() # VALGRIND
endfunction()

function( add_buggy_exe TARGET_NAME TARGET_COMPILE_OPTS TARGET_LINK_LIBS )
    add_executable( ${TARGET_NAME} ${SOURCE} )
    target_link_libraries( ${TARGET_NAME} PRIVATE ${TARGET_LINK_LIBS} )
    target_compile_options( ${TARGET_NAME} PRIVATE ${TARGET_COMPILE_OPTS} )

    if( TARGETS_DEPENDENCIES )
        add_dependencies( ${TARGET_NAME} ${TARGETS_DEPENDENCIES} )
        target_link_libraries( ${TARGET_NAME} PRIVATE ${TARGETS_DEPENDENCIES} )
    endif()

    add_test( NAME ${TARGET_NAME} COMMAND $<TARGET_FILE:${TARGET_NAME}> )

endfunction()

function(add_valgrind_test_runner EXE TOOL OPTS )
    cmake_path( SET EXE_PATH "${CMAKE_CURRENT_BINARY_DIR}/${EXE}" )
    add_test(NAME ${EXE}_valgrind-${TOOL} COMMAND ${VALGRIND}  ${OPTS} --error-exitcode=8 --tool=${TOOL} ${EXE_PATH} )
endfunction()