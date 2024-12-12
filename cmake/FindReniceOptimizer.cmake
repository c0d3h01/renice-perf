# Find Renice Performance Optimizer
#
# This module defines:
#   RENICE_OPTIMIZER_FOUND
#   RENICE_OPTIMIZER_EXECUTABLE
#   RENICE_OPTIMIZER_VERSION

include(FindPackageHandleStandardArgs)

# Search for the executable
find_program(RENICE_OPTIMIZER_EXECUTABLE 
    NAMES renice-optimizer
    PATHS 
        /usr/local/bin
        /usr/bin
)

# If executable is found, try to determine version
if(RENICE_OPTIMIZER_EXECUTABLE)
    execute_process(
        COMMAND ${RENICE_OPTIMIZER_EXECUTABLE} --version
        OUTPUT_VARIABLE RENICE_OPTIMIZER_VERSION
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif()

# Standard package handling
find_package_handle_standard_args(ReniceOptimizer 
    FOUND_VAR RENICE_OPTIMIZER_FOUND
    REQUIRED_VARS RENICE_OPTIMIZER_EXECUTABLE
)

mark_as_advanced(RENICE_OPTIMIZER_EXECUTABLE)