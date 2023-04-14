cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/sol2-v3.3.0)

if(EXISTS ${CACHE_DIR}/sol2-v3.3.0.tar.gz)
	list(APPEND EP_ARGS URL ${CACHE_DIR}/sol2-v3.3.0.tar.gz)
else()
	list(APPEND EP_ARGS URL https://github.com/ThePhD/sol2/archive/refs/tags/v3.3.0.tar.gz)
	list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
endif()

list(APPEND EP_ARGS DOWNLOAD_NAME sol2-v3.3.0.tar.gz)
list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(sol2
	${EP_ARGS}
)

FetchContent_MakeAvailable(sol2)
