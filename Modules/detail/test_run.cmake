#=============================================================================
# Copyright (C) 2012-2013 Daniel Pfeifer <daniel@pfeifer-mail.de>
#
# Distributed under the Boost Software License, Version 1.0.
# See accompanying file LICENSE_1_0.txt or copy at
#   http://www.boost.org/LICENSE_1_0.txt
#=============================================================================

separate_arguments(COMMANDS)
foreach(cmd ${COMMANDS})
  set(command "${${cmd}}")
  set(fail "${${cmd}_FAIL}")
  separate_arguments(command)
  execute_process(COMMAND ${command}
    RESULT_VARIABLE result
    OUTPUT_QUIET ERROR_QUIET # TODO: write to file
    )
  if((fail AND result EQUAL 0) OR (NOT fail AND NOT result EQUAL 0))
    message(FATAL_ERROR "FAIL")
  endif()
endforeach()
