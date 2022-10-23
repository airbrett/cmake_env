cmake_minimum_required(VERSION 3.17)

include(FindPackageHandleStandardArgs)

add_library(IrrAssimp INTERFACE IMPORTED)

set(IrrAssimp_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include/IrrAssimp)
unset(IrrAssimp_LIBS)

if (WIN32)
	list(APPEND IrrAssimp_LIBS ${CMAKE_INSTALL_PREFIX}/lib/IrrAssimp.lib)
endif()

set_target_properties(IrrAssimp PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES ${IrrAssimp_INCLUDE_DIR}
	INTERFACE_LINK_LIBRARIES ${IrrAssimp_LIBS}
)

find_package_handle_standard_args(IrrAssimp DEFAULT_MSG IrrAssimp_INCLUDE_DIR IrrAssimp_LIBS)
