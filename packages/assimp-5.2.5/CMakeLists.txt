cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/assimp-v5.2.5)

if(EXISTS ${SOURCE_DIR})
	#do nothing
elseif(EXISTS ${CACHE_DIR}/assimp-v5.2.5.tar.gz)
	list(APPEND EP_ARGS URL ${CACHE_DIR}/assimp-v5.2.5.tar.gz)
else()
	list(APPEND EP_ARGS URL https://github.com/assimp/assimp/archive/refs/tags/v5.2.5.tar.gz)
	list(APPEND EP_ARGS DOWNLOAD_NAME assimp-v5.2.5.tar.gz)
endif()

list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(assimp
	${EP_ARGS}
)


set(ASSIMP_INSTALL_PDB OFF CACHE BOOL "" FORCE)
set(ASSIMP_BUILD_TESTS OFF CACHE BOOL "" FORCE)

FetchContent_MakeAvailable(assimp)
