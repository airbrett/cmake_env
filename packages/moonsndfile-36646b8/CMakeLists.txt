cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/moonsndfile-36646b8)

list(APPEND EP_ARGS GIT_REPOSITORY https://github.com/stetre/moonsndfile.git)
list(APPEND EP_ARGS GIT_TAG 36646b8)
list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(content
	PATCH_COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/tree.h" ${SOURCE_DIR}/src/tree.h
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/internal.h" ${SOURCE_DIR}/src/internal.h
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/utils.c" ${SOURCE_DIR}/src/utils.c
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/getproc.c" ${SOURCE_DIR}/src/getproc.c
	${EP_ARGS}
)

FetchContent_MakeAvailable(content)

find_package(Lua REQUIRED)
find_package(SndFile REQUIRED)

add_library(moonsndfile SHARED
	${SOURCE_DIR}/src/compat-5.3.h
	${SOURCE_DIR}/src/enums.h
	${SOURCE_DIR}/src/getproc.h
	${SOURCE_DIR}/src/internal.h
	${SOURCE_DIR}/src/moonsndfile.h
	${SOURCE_DIR}/src/objects.h
	${SOURCE_DIR}/src/pfn.h
	${SOURCE_DIR}/src/tree.h
	${SOURCE_DIR}/src/udata.h
	${SOURCE_DIR}/src/chunk.c
	${SOURCE_DIR}/src/command.c
	${SOURCE_DIR}/src/compat-5.3.c
	${SOURCE_DIR}/src/datahandling.c
	${SOURCE_DIR}/src/enums.c
	${SOURCE_DIR}/src/format.c
	${SOURCE_DIR}/src/getproc.c
	${SOURCE_DIR}/src/main.c
	${SOURCE_DIR}/src/objects.c
	${SOURCE_DIR}/src/rawreadwrite.c
	${SOURCE_DIR}/src/readwrite.c
	${SOURCE_DIR}/src/sndfile.c
	${SOURCE_DIR}/src/structs.c
	${SOURCE_DIR}/src/tracing.c
	${SOURCE_DIR}/src/udata.c
	${SOURCE_DIR}/src/utils.c
	${SOURCE_DIR}/src/version.c
	${SOURCE_DIR}/src/include/sndfile-1.0.25.h
	${SOURCE_DIR}/src/include/sndfile-1.0.26.h
	${SOURCE_DIR}/src/include/sndfile-1.0.28.h
	${SOURCE_DIR}/src/include/sndfile-1.0.31.h
	${SOURCE_DIR}/src/include/sndfile.h
)

target_include_directories(moonsndfile PUBLIC
	${LUA_INCLUDE_DIR}
)

target_link_libraries(moonsndfile
	${LUA_LIBRARIES}
	SndFile::sndfile
)

install(TARGETS moonsndfile LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(TARGETS moonsndfile RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})



