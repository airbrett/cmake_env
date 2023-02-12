cmake_minimum_required(VERSION 3.17)

project(Project)

include(ExternalProject)

set(SOURCE_DIR ${CACHE_DIR}/Irrlicht-r6438)

list(APPEND EP_ARGS SVN_REPOSITORY https://svn.code.sf.net/p/irrlicht/code/trunk)
list(APPEND EP_ARGS SVN_TRUST_CERT 1)
list(APPEND EP_ARGS SVN_REVISION -r6438)
list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

if (MSVC)
	if(${MSVC_VERSION} EQUAL 1600)
		set(ProjFile Irrlicht10.0.vcxproj)
	elseif( ${MSVC_VERSION} EQUAL 1700)
		set(ProjFile Irrlicht11.0.vcxproj)
	elseif( ${MSVC_VERSION} EQUAL 1800)
		set(ProjFile Irrlicht12.0.vcxproj)
	elseif( ${MSVC_VERSION} EQUAL 1900)
		set(ProjFile Irrlicht14.0.vcxproj)
	elseif( ${MSVC_VERSION} GREATER 1909 AND ${MSVC_VERSION} LESS 1920)
		set(ProjFile Irrlicht15.0.vcxproj)
	elseif( ${MSVC_VERSION} GREATER 1919 AND ${MSVC_VERSION} LESS 1930)
		set(ProjFile Irrlicht16.0.vcxproj)
	elseif( ${MSVC_VERSION} GREATER 1929 AND ${MSVC_VERSION} LESS 1940)
		set(ProjFile Irrlicht17.0.vcxproj)
	else()
		message(FATAL_ERROR "unsupported version")
	endif()
	
	if (${CMAKE_SIZEOF_VOID_P} EQUAL 4)
		set(IRR_BIN_DIR <SOURCE_DIR>/bin/Win32-VisualStudio)
		set(IRR_LIB_DIR <SOURCE_DIR>/lib/Win32-VisualStudio)
		set(PLATFORM Win32)
	else()
		set(IRR_BIN_DIR <SOURCE_DIR>/bin/Win64-VisualStudio)
		set(IRR_LIB_DIR <SOURCE_DIR>/lib/Win64-VisualStudio)
		set(PLATFORM x64)
	endif()
	
	if (BUILD_SHARED_LIBS)
		list(APPEND BIN_FILES ${IRR_BIN_DIR}/Irrlicht.dll)
		
		if (CMAKE_BUILD_TYPE STREQUAL "Debug")
			set(CONFIGURATION "Debug")
		else()
			set(CONFIGURATION "Release")
		endif()
	else()
		if (CMAKE_BUILD_TYPE STREQUAL "Debug")
			set(CONFIGURATION "Static lib - Debug")
		else()
			set(CONFIGURATION "Static lib - Release")
		endif()
	endif()
	
	list(APPEND LIB_FILES ${IRR_LIB_DIR}/Irrlicht.lib)
	
	if (BIN_FILES)
		set(COPY_BIN_FILES_CMD COMMAND ${CMAKE_COMMAND} -E copy ${BIN_FILES} ${CMAKE_INSTALL_PREFIX}/bin)
	endif()
	
	ExternalProject_Add(
		Irrlicht
		${EP_ARGS}
		PATCH_COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/Irrlicht17.0.vcxproj" <SOURCE_DIR>/source/Irrlicht/Irrlicht17.0.vcxproj
		COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_LIST_DIR}/IrrCompileConfig.h" <SOURCE_DIR>/include/IrrCompileConfig.h
		CONFIGURE_COMMAND ""
		BUILD_COMMAND msbuild.exe <SOURCE_DIR>/source/Irrlicht/${ProjFile} /p:Configuration=${CONFIGURATION} /p:Platform=${PLATFORM}
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/bin
		${COPY_BIN_FILES_CMD}
		#COMMAND ${CMAKE_COMMAND} -E copy ${BIN_FILES} ${CMAKE_INSTALL_PREFIX}/bin
		COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/lib
		COMMAND ${CMAKE_COMMAND} -E copy ${LIB_FILES} ${CMAKE_INSTALL_PREFIX}/lib
		COMMAND ${CMAKE_COMMAND} -E copy_directory <SOURCE_DIR>/include ${CMAKE_INSTALL_PREFIX}/include/Irrlicht
		COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/cmake
		#COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_LIST_DIR}/IrrlichtConfig.cmake ${CMAKE_INSTALL_PREFIX}/cmake
	)
	
	configure_file(
		${CMAKE_CURRENT_LIST_DIR}/IrrlichtConfig.cmake
		${CMAKE_INSTALL_PREFIX}/cmake/IrrlichtConfig.cmake
		@ONLY
	)
	
else()
	message(FATAL_ERROR "not implimented")
endif()



