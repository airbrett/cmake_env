cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/rapidjson-v1.1.0)

if(EXISTS ${CACHE_DIR}/rapidjson-v1.1.0.tar.gz)
	list(APPEND EP_ARGS URL ${CACHE_DIR}/rapidjson-v1.1.0.tar.gz)
else()
	list(APPEND EP_ARGS URL https://github.com/Tencent/rapidjson/archive/refs/tags/v1.1.0.tar.gz)
	list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
	list(APPEND EP_ARGS DOWNLOAD_NAME rapidjson-v1.1.0.tar.gz)
endif()

list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(rapidjson
	${EP_ARGS}
)

FetchContent_MakeAvailable(rapidjson)
