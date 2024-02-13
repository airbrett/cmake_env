cmake_minimum_required(VERSION 3.17)

project(Project)

include(ExternalProject)

set(SOURCE_DIR ${CACHE_DIR}/openjdk-21.0.2)

if(EXISTS ${CACHE_DIR}/openjdk-21.0.2_windows-x64_bin.zip)
	list(APPEND EP_ARGS URL ${CACHE_DIR}/openjdk-21.0.2_windows-x64_bin.zip)
else()
	list(APPEND EP_ARGS URL https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_windows-x64_bin.zip)
	list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
endif()

list(APPEND EP_ARGS DOWNLOAD_NAME openjdk-21.0.2_windows-x64_bin.zip)
list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

ExternalProject_Add(openjdk
	${EP_ARGS}
	CONFIGURE_COMMAND ""
	BUILD_COMMAND ""
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory ${SOURCE_DIR} ${CMAKE_INSTALL_PREFIX}
)
