cmake_minimum_required(VERSION 3.17)

project(Project)

include(ExternalProject)

set(SOURCE_DIR ${CACHE_DIR}/jME3.6.1-stable)

if(EXISTS ${CACHE_DIR}/jME3.6.1-stable.zip)
	list(APPEND EP_ARGS URL ${CACHE_DIR}/jME3.6.1-stable.zip)
else()
	list(APPEND EP_ARGS URL https://github.com/jMonkeyEngine/jmonkeyengine/releases/download/v3.6.1-stable/jME3.6.1-stable.zip)
	list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
endif()

list(APPEND EP_ARGS DOWNLOAD_NAME jME3.6.1-stable.zip)
list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

ExternalProject_Add(jme
	${EP_ARGS}
	CONFIGURE_COMMAND ""
	BUILD_COMMAND ""
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory ${SOURCE_DIR} ${CMAKE_INSTALL_PREFIX}
)
