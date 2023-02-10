cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/toluapp-3a2c889)

list(APPEND EP_ARGS GIT_REPOSITORY https://github.com/waltervn/toluapp)
list(APPEND EP_ARGS GIT_TAG 3a2c889)
list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(content
	PATCH_COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/src_CMakeLists.txt" ${SOURCE_DIR}/src/CMakeLists.txt
	${EP_ARGS}
)

FetchContent_MakeAvailable(content)

configure_file(
	${CMAKE_CURRENT_LIST_DIR}/toluappConfig.cmake
	${CMAKE_INSTALL_PREFIX}/cmake/toluappConfig.cmake
	@ONLY
)
