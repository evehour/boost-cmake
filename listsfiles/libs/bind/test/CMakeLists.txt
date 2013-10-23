# Distributed under the Boost Software License, Version 1.0.
# See http://www.boost.org/LICENSE_1_0.txt

set(test_list
  bind_test
  bind_dm_test
  bind_eq_test
  bind_const_test
  bind_cv_test
  bind_stateful_test
  bind_dm2_test
  bind_not_test
  bind_rel_test
  bind_function_test
  bind_lookup_problem_test
  bind_rv_sp_test
  bind_dm3_test
  bind_visit_test
  bind_placeholder_test
  bind_rvalue_test
  bind_and_or_test
  mem_fn_test
  mem_fn_void_test
  mem_fn_derived_test
  mem_fn_eq_test
  mem_fn_dm_test
  mem_fn_rv_test
  ref_fn_test
  bind_fnobj2_test
  bind_fn2_test
  bind_mf2_test
  bind_eq2_test
  mem_fn_ref_test
  bind_ref_test
  bind_eq3_test
  protect_test
  mem_fn_unary_addr_test
  )

set(test_targets)
foreach(test IN LISTS test_list)
  set(target "${PROJECT_NAME}-test-${test}")
  add_executable(${target} ${test})
  target_link_libraries(${target} PRIVATE
    boost::bind
    )
  list(APPEND test_targets ${target})
  add_test(NAME ${PROJECT_NAME}.${test}
    COMMAND $<TARGET_FILE:${target}>
    )
endforeach()

ryppl_test_suite(
  COMPILE
    bind_unary_addr.cpp
  )

add_custom_target(${PROJECT_NAME}-test
  COMMAND ${CMAKE_CTEST_COMMAND} -R "^${PROJECT_NAME}" ${CMAKE_BINARY_DIR}
  DEPENDS ${test_targets}
  )
