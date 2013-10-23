# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

include(RypplTestSuite)

ryppl_test_suite(
  RUN
    ../any_test.cpp
  COMPILE_FAIL
    any_cast_cv_failed.cpp
  )

target_link_libraries(boostany-testdriver PRIVATE
  boost::any
  )

add_custom_target(${PROJECT_NAME}-test
  COMMAND ${CMAKE_CTEST_COMMAND} -R "^${PROJECT_NAME}" ${CMAKE_BINARY_DIR}
  DEPENDS boostany-testdriver
  )
