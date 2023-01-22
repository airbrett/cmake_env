cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/fltk-1.3.8)

if(EXISTS ${CACHE_DIR}/fltk-1.3.8-source.tar.bz2)
	list(APPEND EP_ARGS URL ${CACHE_DIR}/fltk-1.3.8-source.tar.bz2)
else()
	list(APPEND EP_ARGS URL https://www.fltk.org/pub/fltk/1.3.8/fltk-1.3.8-source.tar.bz2)
	list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
endif()

list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(content
	${EP_ARGS}
)

set(FLTK_BUILD_TEST OFF CACHE INTERNAL "")
set(FLTK_BUILD_EXAMPLES OFF CACHE INTERNAL "")
#set(OPTION_BUILD_SHARED_LIBS ON CACHE INTERNAL "")

FetchContent_MakeAvailable(content)
