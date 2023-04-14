cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/Chipmunk-7.0.3)

if(EXISTS ${CACHE_DIR}/Chipmunk-7.0.3.tar.gz)
	list(APPEND EP_ARGS URL ${CACHE_DIR}/Chipmunk-7.0.3.tar.gz)
else()
	list(APPEND EP_ARGS URL https://github.com/slembcke/Chipmunk2D/archive/refs/tags/Chipmunk-7.0.3.tar.gz)
	list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
endif()

list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(Chipmunk
	${EP_ARGS}
	PATCH_COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/cpRobust.h" "${SOURCE_DIR}/include/chipmunk/cpRobust.h"
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/cpRobust.c" "${SOURCE_DIR}/src/cpRobust.c"
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/patch_CMakeLists.txt" "${SOURCE_DIR}/CMakeLists.txt"
)

FetchContent_MakeAvailable(Chipmunk)

if (INSTALL_STATIC)
	set(CHIPMUNK_SHARED 0)
else()
	set(CHIPMUNK_SHARED 1)
endif()

configure_file(
	${CMAKE_CURRENT_LIST_DIR}/chipmunk.h
	${SOURCE_DIR}/include/chipmunk/chipmunk.h
	@ONLY
)

configure_file(
	${CMAKE_CURRENT_LIST_DIR}/chipmunkConfig.cmake
	${CMAKE_INSTALL_PREFIX}/cmake/chipmunkConfig.cmake
	@ONLY
)