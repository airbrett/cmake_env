cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/sndfile-1.2.0)

if(EXISTS ${CACHE_DIR}/sndfile-1.2.0.tar.gz)
	list(APPEND EP_ARGS URL ${CACHE_DIR}/sndfile-1.2.0.tar.gz)
else()
	list(APPEND EP_ARGS URL https://github.com/libsndfile/libsndfile/archive/refs/tags/1.2.0.tar.gz)
	list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
endif()

list(APPEND EP_ARGS DOWNLOAD_NAME sndfile-1.2.0.tar.gz)
list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(content
	${EP_ARGS}
)


FetchContent_MakeAvailable(content)
