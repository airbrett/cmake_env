cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)
include(GNUInstallDirs)

set(SOURCE_DIR ${CACHE_DIR}/IrrAssimp-daba836)

list(APPEND EP_ARGS GIT_REPOSITORY https://github.com/JLouis-B/IrrAssimp.git)
list(APPEND EP_ARGS GIT_TAG daba836)

list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(content
	PATCH_COMMAND ${CMAKE_COMMAND} -E rm -f "${SOURCE_DIR}/CMakeLists.txt"
	${EP_ARGS}
)

FetchContent_MakeAvailable(content)

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

find_package(Irrlicht REQUIRED)
find_package(assimp REQUIRED)

list(APPEND PUBLIC_HEADERS ${SOURCE_DIR}/IrrAssimp/IrrAssimp.h)
list(APPEND PUBLIC_HEADERS ${SOURCE_DIR}/IrrAssimp/IrrAssimpExport.h)
list(APPEND PUBLIC_HEADERS ${SOURCE_DIR}/IrrAssimp/IrrAssimpImport.h)
list(APPEND PUBLIC_HEADERS ${SOURCE_DIR}/IrrAssimp/IrrAssimpUtils.h)

add_library(IrrAssimp
	${SOURCE_DIR}/IrrAssimp/IrrAssimp.cpp
	${SOURCE_DIR}/IrrAssimp/IrrAssimpExport.cpp
	${SOURCE_DIR}/IrrAssimp/IrrAssimpImport.cpp
	${SOURCE_DIR}/IrrAssimp/IrrAssimpUtils.cpp
	${PUBLIC_HEADERS}
)

list(APPEND DEFS PRIVATE IRRASSIMP_BUILD)

if(NOT ${BUILD_SHARED_LIBS})
	list(APPEND DEFS PUBLIC IRRASSIMP_STATIC)
endif()

set_target_properties(IrrAssimp PROPERTIES PUBLIC_HEADER "${PUBLIC_HEADERS}")

target_compile_definitions(IrrAssimp
	${DEFS}
)

target_link_libraries(IrrAssimp
	Irrlicht
	assimp::assimp
)

install(TARGETS IrrAssimp LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(TARGETS IrrAssimp RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install(TARGETS IrrAssimp PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/IrrAssimp)
install(FILES ${CMAKE_CURRENT_LIST_DIR}/IrrAssimpConfig.cmake DESTINATION cmake)
