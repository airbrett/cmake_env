cmake_minimum_required(VERSION 3.2)

include(FindPackageHandleStandardArgs)

add_library(toluapp INTERFACE IMPORTED)

set(toluapp_INCLUDE_DIR @CMAKE_INSTALL_PREFIX@/include)
unset(toluapp_LIBS)

if (WIN32)
	list(APPEND toluapp_LIBS @CMAKE_INSTALL_PREFIX@/lib/tolua++.lib)
endif()

set(TOLUAPP_EXECUTABLE @CMAKE_INSTALL_PREFIX@/bin/tolua++.exe)

set_target_properties(toluapp PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES ${toluapp_INCLUDE_DIR}
	INTERFACE_LINK_LIBRARIES ${toluapp_LIBS}
)

find_package_handle_standard_args(toluapp DEFAULT_MSG toluapp_INCLUDE_DIR toluapp_LIBS)
