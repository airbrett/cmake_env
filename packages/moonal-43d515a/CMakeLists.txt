cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/moonal-43d515a)

#if(EXISTS ${CACHE_DIR}/v0.1.tar.gz)
#	list(APPEND EP_ARGS URL ${CACHE_DIR}/v0.1.tar.gz)
#else()
	list(APPEND EP_ARGS GIT_REPOSITORY https://github.com/stetre/moonal.git)
	list(APPEND EP_ARGS GIT_TAG 43d515a)
#	list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
#endif()

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
find_package(OpenAL REQUIRED)

add_library(moonal SHARED
	${SOURCE_DIR}/src/compat-5.3.h
	${SOURCE_DIR}/src/enums.h
	${SOURCE_DIR}/src/getproc.h
	${SOURCE_DIR}/src/internal.h
	${SOURCE_DIR}/src/moonal.h
	${SOURCE_DIR}/src/objects.h
	${SOURCE_DIR}/src/tree.h
	${SOURCE_DIR}/src/udata.h
	${SOURCE_DIR}/src/auxslot.c
	${SOURCE_DIR}/src/buffer.c
	${SOURCE_DIR}/src/compat-5.3.c
	${SOURCE_DIR}/src/context.c
	${SOURCE_DIR}/src/datahandling.c
	${SOURCE_DIR}/src/device.c
	${SOURCE_DIR}/src/effect.c
	${SOURCE_DIR}/src/enums.c
	${SOURCE_DIR}/src/filter.c
	${SOURCE_DIR}/src/getproc.c
	${SOURCE_DIR}/src/listener.c
	${SOURCE_DIR}/src/main.c
	${SOURCE_DIR}/src/objects.c
	${SOURCE_DIR}/src/ranges.c
	${SOURCE_DIR}/src/source.c
	${SOURCE_DIR}/src/structs.c
	${SOURCE_DIR}/src/tracing.c
	${SOURCE_DIR}/src/udata.c
	${SOURCE_DIR}/src/utils.c
	${SOURCE_DIR}/src/version.c
	${SOURCE_DIR}/src/include/al.h
	${SOURCE_DIR}/src/include/alc.h
	${SOURCE_DIR}/src/include/alext.h
	${SOURCE_DIR}/src/include/efx-creative.h
	${SOURCE_DIR}/src/include/efx-presets.h
	${SOURCE_DIR}/src/include/efx.h
)

#set_target_properties(lua54 PROPERTIES PUBLIC_HEADER "${PUBLIC_HEADERS}")

#add_executable(lua
#	${SOURCE_DIR}/src/lua.c
#)

#target_link_libraries(lua
#	PRIVATE lua54
#)

#add_executable(luac
#	${SOURCE_DIR}/src/luac.c
#)

target_include_directories(moonal PUBLIC
	${LUA_INCLUDE_DIR}
	${OPENAL_INCLUDE_DIR}
)

target_link_libraries(moonal
	${LUA_LIBRARIES}
	${OPENAL_LIBRARY}
)

install(TARGETS moonal LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
#install(TARGETS lua54 PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
install(TARGETS moonal RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
#install(TARGETS luac RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})



