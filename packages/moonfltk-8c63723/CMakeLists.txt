cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/moonfltk-8c63723)

list(APPEND EP_ARGS GIT_REPOSITORY https://github.com/stetre/moonfltk.git)
list(APPEND EP_ARGS GIT_TAG 8c63723)
list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(content
	PATCH_COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/text_display.cc" ${SOURCE_DIR}/src/text_display.cc
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/utils.cc" ${SOURCE_DIR}/src/utils.cc
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/tree.h" ${SOURCE_DIR}/src/tree.h
	COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/open.c" ${SOURCE_DIR}/src/open.c
	${EP_ARGS}
)

FetchContent_MakeAvailable(content)

find_package(Lua REQUIRED)
find_package(FLTK CONFIG REQUIRED)

add_library(moonfltk SHARED
	${SOURCE_DIR}/src/additional.cc
	${SOURCE_DIR}/src/bitfields.cc
	${SOURCE_DIR}/src/browser.cc
	${SOURCE_DIR}/src/button.cc
	${SOURCE_DIR}/src/chart.cc
	${SOURCE_DIR}/src/clock.cc
	${SOURCE_DIR}/src/color_chooser.cc
	${SOURCE_DIR}/src/compat-5.3.c
	${SOURCE_DIR}/src/compat-5.3.h
	${SOURCE_DIR}/src/enums.cc
	${SOURCE_DIR}/src/fl.cc
	${SOURCE_DIR}/src/flclipboard.cc
	${SOURCE_DIR}/src/flcolor.cc
	${SOURCE_DIR}/src/flcommon.cc
	${SOURCE_DIR}/src/fldraw.cc
	${SOURCE_DIR}/src/fldraw_boxtype.h
	${SOURCE_DIR}/src/flevent.cc
	${SOURCE_DIR}/src/flfile.cc
	${SOURCE_DIR}/src/flfont.cc
	${SOURCE_DIR}/src/flscreen.cc
	${SOURCE_DIR}/src/fltooltip.cc
	${SOURCE_DIR}/src/flunicode.cc
	${SOURCE_DIR}/src/flwindow.cc
	${SOURCE_DIR}/src/func.h
	${SOURCE_DIR}/src/group.cc
	${SOURCE_DIR}/src/handlers.cc
	${SOURCE_DIR}/src/help_dialog.cc
	${SOURCE_DIR}/src/help_view.cc
	${SOURCE_DIR}/src/image.cc
	${SOURCE_DIR}/src/input.cc
	${SOURCE_DIR}/src/input_choice.cc
	${SOURCE_DIR}/src/internal.h
	${SOURCE_DIR}/src/keys.cc
	${SOURCE_DIR}/src/keys.h
	${SOURCE_DIR}/src/main.cc
	${SOURCE_DIR}/src/Makefile
	${SOURCE_DIR}/src/menu.cc
	${SOURCE_DIR}/src/menu_item.cc
	${SOURCE_DIR}/src/moonfltk.h
	${SOURCE_DIR}/src/mt.h
	${SOURCE_DIR}/src/native_file_chooser.cc
	${SOURCE_DIR}/src/open.c
	${SOURCE_DIR}/src/rtti.cc
	${SOURCE_DIR}/src/slider.cc
	${SOURCE_DIR}/src/subclass.cc
	${SOURCE_DIR}/src/table.cc
	${SOURCE_DIR}/src/tabs.cc
	${SOURCE_DIR}/src/text_buffer.cc
	${SOURCE_DIR}/src/text_display.cc
	${SOURCE_DIR}/src/text_editor.cc
	${SOURCE_DIR}/src/tree.cc
	${SOURCE_DIR}/src/tree.h
	${SOURCE_DIR}/src/udata.c
	${SOURCE_DIR}/src/udata.h
	${SOURCE_DIR}/src/utils.cc
	${SOURCE_DIR}/src/valuator.cc
	${SOURCE_DIR}/src/widget.cc
	${SOURCE_DIR}/src/window.cc
)

target_include_directories(moonfltk PUBLIC
	${LUA_INCLUDE_DIR}
)

target_link_libraries(moonfltk
	${LUA_LIBRARIES}
	fltk
	fltk_images
)

install(TARGETS moonfltk LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(TARGETS moonfltk RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})



