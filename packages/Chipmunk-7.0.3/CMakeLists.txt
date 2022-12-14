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
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/chipmunk.h" "${SOURCE_DIR}/include/chipmunk/chipmunk.h"
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/patch_CMakeLists.txt" "${SOURCE_DIR}/CMakeLists.txt"
)

set(BUILD_DEMOS OFF CACHE BOOL "" FORCE)
set(BUILD_STATIC OFF CACHE BOOL "" FORCE)
set(INSTALL_STATIC OFF CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(Chipmunk)

configure_file(
	${CMAKE_CURRENT_LIST_DIR}/chipmunkConfig.cmake
	${CMAKE_INSTALL_PREFIX}/cmake/chipmunkConfig.cmake
)