cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/ogre-v2.3.1)

if(EXISTS ${CACHE_DIR}/ogre-v2.3.1.tar.gz)
	list(APPEND EP_ARGS URL ${CACHE_DIR}/ogre-v2.3.1.tar.gz)
else()
	list(APPEND EP_ARGS URL https://github.com/OGRECave/ogre-next/archive/refs/tags/v2.3.1.tar.gz)
	list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
	list(APPEND EP_ARGS DOWNLOAD_NAME ogre-v2.3.1.tar.gz)
endif()

list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(ogre
	${EP_ARGS}
	PATCH_COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/SceneFormatCMakeLists.txt" "${SOURCE_DIR}/Components/SceneFormat/CMakeLists.txt"
)

FetchContent_MakeAvailable(ogre)
