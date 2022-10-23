cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/IrrAssimp-daba836)

#if(EXISTS ${CACHE_DIR}/v0.1.tar.gz)
#	list(APPEND EP_ARGS URL ${CACHE_DIR}/v0.1.tar.gz)
#else()
	list(APPEND EP_ARGS GIT_REPOSITORY https://github.com/JLouis-B/IrrAssimp.git)
	list(APPEND EP_ARGS GIT_TAG daba836)
#	list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
#endif()

list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(content
	PATCH_COMMAND ${CMAKE_COMMAND} -E rm -f "${SOURCE_DIR}/CMakeLists.txt"
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/IrrAssimp.h" "${SOURCE_DIR}/IrrAssimp/IrrAssimp.h"
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/IrrAssimpExport.h" "${SOURCE_DIR}/IrrAssimp/IrrAssimpExport.h"
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/IrrAssimpImport.h" "${SOURCE_DIR}/IrrAssimp/IrrAssimpImport.h"
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/IrrAssimpUtils.h" "${SOURCE_DIR}/IrrAssimp/IrrAssimpUtils.h"
	${EP_ARGS}
)

FetchContent_MakeAvailable(content)

find_package(Irrlicht REQUIRED)
find_package(assimp REQUIRED)

add_library(IrrAssimp
	${SOURCE_DIR}/IrrAssimp/IrrAssimp.cpp
	${SOURCE_DIR}/IrrAssimp/IrrAssimp.h
	${SOURCE_DIR}/IrrAssimp/IrrAssimpExport.cpp
	${SOURCE_DIR}/IrrAssimp/IrrAssimpExport.h
	${SOURCE_DIR}/IrrAssimp/IrrAssimpImport.cpp
	${SOURCE_DIR}/IrrAssimp/IrrAssimpImport.h
	${SOURCE_DIR}/IrrAssimp/IrrAssimpUtils.cpp
	${SOURCE_DIR}/IrrAssimp/IrrAssimpUtils.h
)

list(APPEND DEFS PRIVATE IRRASSIMP_BUILD)

if(NOT ${BUILD_SHARED_LIBS})
	list(APPEND DEFS PUBLIC IRRASSIMP_STATIC)
endif()

target_compile_definitions(IrrAssimp
	${DEFS}
)

target_link_libraries(IrrAssimp
	Irrlicht
	assimp::assimp
)

install(TARGETS IrrAssimp LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
#install(TARGETS lua54 PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
install(TARGETS IrrAssimp RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
#install(TARGETS luac RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})



