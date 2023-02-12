cmake_minimum_required(VERSION 3.2)

include(FindPackageHandleStandardArgs)

set(Irrlicht_VERSION 3.1)

add_library(Irrlicht INTERFACE IMPORTED)

set(Irrlicht_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include/Irrlicht)
unset(Irrlicht_LIBS)

if (WIN32)
	list(APPEND Irrlicht_LIBS ${CMAKE_INSTALL_PREFIX}/lib/Irrlicht.lib)
endif()

if("@BUILD_SHARED_LIBS@" STREQUAL "")
	set(COMPILE_DEFS INTERFACE_COMPILE_DEFINITIONS _IRR_STATIC_LIB_)
endif()

set_target_properties(Irrlicht PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES ${Irrlicht_INCLUDE_DIR}
	INTERFACE_LINK_LIBRARIES ${Irrlicht_LIBS}
	${COMPILE_DEFS}
)

find_package_handle_standard_args(Irrlicht DEFAULT_MSG Irrlicht_INCLUDE_DIR Irrlicht_LIBS)
