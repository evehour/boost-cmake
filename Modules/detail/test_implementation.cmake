#=============================================================================
# Copyright (C) 2012-2013 Daniel Pfeifer <daniel@pfeifer-mail.de>
#
# Distributed under the Boost Software License, Version 1.0.
# See accompanying file LICENSE_1_0.txt or copy at
#   http://www.boost.org/LICENSE_1_0.txt
#=============================================================================

set(__boost_test_run "${CMAKE_CURRENT_LIST_DIR}/test_run.cmake")

macro(__boost_add_test_compile fail)
  get_filename_component(name ${FILE} NAME_WE)

  get_filename_component(SOURCE ${FILE} ABSOLUTE)
  set(OBJECT ${name}.o)

  string(TOUPPER "${CMAKE_BUILD_TYPE}" build_type)
  set(FLAGS ${CMAKE_CXX_FLAGS_${build_type}})

  get_directory_property(include_directories INCLUDE_DIRECTORIES)
  foreach(dir ${include_directories})
    list(APPEND FLAGS "-I${dir}")
  endforeach()

  string(REGEX REPLACE "<([A-Z_]+)>" "@\\1@" compile
    "${CMAKE_CXX_COMPILE_OBJECT}"
    )
  string(CONFIGURE "${compile}" compile @ONLY)
  separate_arguments(compile)

  add_test(NAME ${PROJECT_NAME}.${name}
    COMMAND ${compile}
    )
  set_tests_properties(${PROJECT_NAME}.${name} PROPERTIES
    WILL_FAIL "${fail}"
    )
endmacro()

macro(__boost_add_test_link link_rule fail)
  get_filename_component(name ${FILE} NAME_WE)

  get_filename_component(SOURCE ${FILE} ABSOLUTE)
  set(TARGET ${name}_ok)
  set(OBJECT ${name}.o)
  set(OBJECTS ${OBJECT})

  string(REGEX REPLACE "<([A-Z_]+)>" "@\\1@" compile
    "${CMAKE_CXX_COMPILE_OBJECT}"
    )
  string(REGEX REPLACE "<([A-Z_]+)>" "@\\1@" link
    "${link_rule}"
    )
  string(CONFIGURE "${compile}" compile @ONLY)
  string(CONFIGURE "${link}" link @ONLY)

  add_test(NAME ${PROJECT_NAME}.${name}
    COMMAND ${CMAKE_COMMAND}
      -D "COMMANDS=COMPILE LINK"
      -D "COMPILE=${compile}"
      -D "LINK=${link}"
      -D "LINK_FAIL=${fail}"
      -P "${__boost_test_run}"
    )
endmacro()

macro(__boost_add_test_run driver fail)
  get_filename_component(name ${FILE} NAME_WE)
  add_test(NAME ${PROJECT_NAME}.${name}
    COMMAND $<TARGET_FILE:${driver}> ${name}
    )
  set_tests_properties(${PROJECT_NAME}.${name} PROPERTIES
    WILL_FAIL "${fail}"
    )
endmacro()

macro(__boost_add_test_run_deprecated driver fail)
  get_filename_component(name ${FILE} NAME_WE)
  set(name ${target}-${name})
  set(testdriver ${driver}${SUFFIX})
  math(EXPR SUFFIX "${SUFFIX} + 1")
  add_executable(${testdriver}
    ${FILE}
    ${TEST_ADDITIONAL_SOURCES}
    )
  target_link_libraries(${testdriver}
    ${TEST_LINK_LIBRARIES}
    )
  add_test(NAME ${PROJECT_NAME}.${name}
    COMMAND $<TARGET_FILE:${testdriver}>
    )
  set_tests_properties(${PROJECT_NAME}.${name} PROPERTIES
    WILL_FAIL "${fail}"
    )
endmacro()

macro(__boost_add_test_python fail)
  get_filename_component(name ${FILE} NAME_WE)
  set(module "${PROJECT_NAME}-test-${name}-ext")
  add_library(${module} MODULE
    ${FILE}
    )
  target_link_libraries(${module} PRIVATE
    ${TEST_LINK_LIBRARIES}
    )
  set_target_properties(${module} PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    OUTPUT_NAME "${name}_ext"
    PREFIX ""
    )
  add_test(NAME ${PROJECT_NAME}.${name}
    COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/${name}.py
    )
  set_tests_properties(${PROJECT_NAME}.${name} PROPERTIES
    ENVIRONMENT "PYTHONPATH=${CMAKE_CURRENT_BINARY_DIR}"
    WILL_FAIL "${fail}"
    )
endmacro()
