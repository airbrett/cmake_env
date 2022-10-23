cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/lua-5.4.4)

if(EXISTS ${CACHE_DIR}/lua-5.4.4.tar.gz)
	list(APPEND EP_ARGS URL ${CACHE_DIR}/lua-5.4.4.tar.gz)
else()
	list(APPEND EP_ARGS URL https://www.lua.org/ftp/lua-5.4.4.tar.gz)
	list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
endif()

list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(lua_content
	${EP_ARGS}
)

FetchContent_MakeAvailable(lua_content)

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

list(APPEND PUBLIC_HEADERS ${SOURCE_DIR}/src/lua.h)
list(APPEND PUBLIC_HEADERS ${SOURCE_DIR}/src/luaconf.h)
list(APPEND PUBLIC_HEADERS ${SOURCE_DIR}/src/lualib.h)
list(APPEND PUBLIC_HEADERS ${SOURCE_DIR}/src/lauxlib.h)
list(APPEND PUBLIC_HEADERS ${SOURCE_DIR}/src/lua.hpp)

add_library(lua54
	${SOURCE_DIR}/src/lapi.c
	${SOURCE_DIR}/src/lapi.h
	${SOURCE_DIR}/src/lauxlib.c
	${SOURCE_DIR}/src/lbaselib.c
	${SOURCE_DIR}/src/lcode.c
	${SOURCE_DIR}/src/lcode.h
	${SOURCE_DIR}/src/lcorolib.c
	${SOURCE_DIR}/src/lctype.c
	${SOURCE_DIR}/src/lctype.h
	${SOURCE_DIR}/src/ldblib.c
	${SOURCE_DIR}/src/ldebug.c
	${SOURCE_DIR}/src/ldebug.h
	${SOURCE_DIR}/src/ldo.c
	${SOURCE_DIR}/src/ldo.h
	${SOURCE_DIR}/src/ldump.c
	${SOURCE_DIR}/src/lfunc.c
	${SOURCE_DIR}/src/lfunc.h
	${SOURCE_DIR}/src/lgc.c
	${SOURCE_DIR}/src/lgc.h
	${SOURCE_DIR}/src/linit.c
	${SOURCE_DIR}/src/liolib.c
	${SOURCE_DIR}/src/ljumptab.h
	${SOURCE_DIR}/src/llex.c
	${SOURCE_DIR}/src/llex.h
	${SOURCE_DIR}/src/llimits.h
	${SOURCE_DIR}/src/lmathlib.c
	${SOURCE_DIR}/src/lmem.c
	${SOURCE_DIR}/src/lmem.h
	${SOURCE_DIR}/src/loadlib.c
	${SOURCE_DIR}/src/lobject.c
	${SOURCE_DIR}/src/lobject.h
	${SOURCE_DIR}/src/lopcodes.c
	${SOURCE_DIR}/src/lopcodes.h
	${SOURCE_DIR}/src/lopnames.h
	${SOURCE_DIR}/src/loslib.c
	${SOURCE_DIR}/src/lparser.c
	${SOURCE_DIR}/src/lparser.h
	${SOURCE_DIR}/src/lprefix.h
	${SOURCE_DIR}/src/lstate.c
	${SOURCE_DIR}/src/lstate.h
	${SOURCE_DIR}/src/lstring.c
	${SOURCE_DIR}/src/lstring.h
	${SOURCE_DIR}/src/lstrlib.c
	${SOURCE_DIR}/src/ltable.c
	${SOURCE_DIR}/src/ltable.h
	${SOURCE_DIR}/src/ltablib.c
	${SOURCE_DIR}/src/ltm.c
	${SOURCE_DIR}/src/ltm.h
	${SOURCE_DIR}/src/lundump.c
	${SOURCE_DIR}/src/lundump.h
	${SOURCE_DIR}/src/lutf8lib.c
	${SOURCE_DIR}/src/lvm.c
	${SOURCE_DIR}/src/lvm.h
	${SOURCE_DIR}/src/lzio.c
	${SOURCE_DIR}/src/lzio.h
	${PUBLIC_HEADERS}
)

if(${BUILD_SHARED_LIBS})
	list(APPEND DEFS PUBLIC LUA_BUILD_AS_DLL)
endif()

set_target_properties(lua54 PROPERTIES PUBLIC_HEADER "${PUBLIC_HEADERS}")

if(DEFS)
	target_compile_definitions(lua54
		${DEFS}
	)
endif()

install(TARGETS lua54 LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(TARGETS lua54 RUNTIME DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(TARGETS lua54 PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

add_executable(lua
	${SOURCE_DIR}/src/lua.c
	${SOURCE_DIR}/src/lmem.c
	${SOURCE_DIR}/src/lmem.h
)

target_link_libraries(lua
	PRIVATE lua54
)

add_executable(luac
	${SOURCE_DIR}/src/luac.c
)

target_link_libraries(luac
	PRIVATE lua54
)

install(TARGETS lua RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install(TARGETS luac RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})



