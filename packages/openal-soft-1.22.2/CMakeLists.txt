cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/openal-soft-1.22.2)

if(EXISTS ${CACHE_DIR}/openal-soft-1.22.2.tar.gz)
	list(APPEND EP_ARGS URL ${CACHE_DIR}/openal-soft-1.22.2.tar.gz)
else()
	list(APPEND EP_ARGS URL https://github.com/kcat/openal-soft/archive/refs/tags/1.22.2.tar.gz)
	list(APPEND EP_ARGS DOWNLOAD_NAME openal-soft-1.22.2.tar.gz)
	list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
endif()

list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(content
	${EP_ARGS}
	PATCH_COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/CMakeLists_patch.txt" "${SOURCE_DIR}/CMakeLists.txt"
)

FetchContent_MakeAvailable(content)