cmake_minimum_required(VERSION 3.2)

add_library(sol2 INTERFACE IMPORTED)

set(sol2_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include)

set_target_properties(sol2 PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES ${sol2_INCLUDE_DIR}
)

find_package_handle_standard_args(sol2 DEFAULT_MSG chipmunk_INCLUDE_DIR)
