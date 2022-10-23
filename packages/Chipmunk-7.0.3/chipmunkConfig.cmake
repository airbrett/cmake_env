cmake_minimum_required(VERSION 3.2)

set(chipmunk_VERSION 3.1)

add_library(chipmunk INTERFACE IMPORTED)

set(chipmunk_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include/chipmunk)
unset(chipmunk_LIBS)

if (WIN32)
	list(APPEND chipmunk_LIBS ${CMAKE_INSTALL_PREFIX}/lib/chipmunk.lib)
endif()

set_target_properties(chipmunk PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES ${chipmunk_INCLUDE_DIR}
	INTERFACE_LINK_LIBRARIES ${chipmunk_LIBS}
)

find_package_handle_standard_args(chipmunk DEFAULT_MSG chipmunk_INCLUDE_DIR chipmunk_LIBS)
