cmake_minimum_required(VERSION 3.17)

include(ExternalProject)

project(Project)

set(SOURCE_DIR ${CACHE_DIR}/boost_1_80_0)

if(EXISTS ${SOURCE_DIR})
	#do nothing
elseif(EXISTS ${CACHE_DIR}/boost_1_80_0.tar.bz2)
	list(APPEND EP_ARGS URL ${CACHE_DIR}/boost_1_80_0.tar.bz2)
else()
	list(APPEND EP_ARGS URL https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.bz2)
	list(APPEND EP_ARGS DOWNLOAD_NAME boost_1_80_0.tar.bz2)
endif()

list(APPEND EP_ARGS DOWNLOAD_DIR ${CACHE_DIR})
list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})


if ("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
	list(APPEND EP_ARGS CONFIGURE_COMMAND bootstrap.bat)
else()
	list(APPEND EP_ARGS CONFIGURE_COMMAND bootstrap.sh)
endif()

if (${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
	list(APPEND BOOST_ARGS target-os=windows)
else()
	list(APPEND BOOST_ARGS target-os=linux)
	list(APPEND BOOST_ARGS threadapi=pthread)
endif()

if(CMAKE_SIZEOF_VOID_P EQUAL 4)
	list(APPEND BOOST_ARGS address-model=32)
else()
	list(APPEND BOOST_ARGS address-model=64)
endif()

if (MSVC)
	if(${MSVC_VERSION} EQUAL 1600)
		list(APPEND BOOST_ARGS toolset=msvc-10.0)
	elseif( ${MSVC_VERSION} EQUAL 1700)
		list(APPEND BOOST_ARGS toolset=msvc-11.0)
	elseif( ${MSVC_VERSION} EQUAL 1800)
		list(APPEND BOOST_ARGS toolset=msvc-12.0)
	elseif( ${MSVC_VERSION} EQUAL 1900)
		list(APPEND BOOST_ARGS toolset=msvc-14.0)
	elseif( ${MSVC_VERSION} GREATER 1909 AND ${MSVC_VERSION} LESS 1920)
		list(APPEND BOOST_ARGS toolset=msvc-15.0)
	elseif( ${MSVC_VERSION} GREATER 1919 AND ${MSVC_VERSION} LESS 1930)
		list(APPEND BOOST_ARGS toolset=msvc-16.0)
	elseif( ${MSVC_VERSION} GREATER 1929 AND ${MSVC_VERSION} LESS 1940)
		list(APPEND BOOST_ARGS toolset=msvc-17.0)
	else()
		message(FATAL_ERROR "unsupported version")
	endif()
	
	#if(${CMAKE_SYSTEM_VERSION} EQUAL 6.1)#Windows 7
	#	list(APPEND BOOST_ARGS define=BOOST_USE_WINAPI_VERSION=0x0601)
	#elseif(${CMAKE_SYSTEM_VERSION} EQUAL 6.2)#Windows 8
	#	list(APPEND BOOST_ARGS define=BOOST_USE_WINAPI_VERSION=0x0602)
	#elseif(${CMAKE_SYSTEM_VERSION} EQUAL 6.3)#Windows 8.1
	#	list(APPEND BOOST_ARGS define=BOOST_USE_WINAPI_VERSION=0x0603)
	#elseif(${CMAKE_SYSTEM_VERSION} EQUAL 10.0)#Windows 10
	#	list(APPEND BOOST_ARGS define=BOOST_USE_WINAPI_VERSION=0x0A00)
	#endif()
	
	if (${CMAKE_BUILD_TYPE} STREQUAL "Debug")
		list(APPEND BOOST_ARGS variant=debug)
	else()
		list(APPEND BOOST_ARGS variant=release)
	endif()
	
	list(APPEND EP_ARGS PATCH_COMMAND ${CMAKE_COMMAND} -E rm -f ${SOURCE_DIR}/tools/build/src/user-config.jam)
else()
	file(WRITE ${CMAKE_CURRENT_LIST_DIR}/user-config.jam "using gcc : : ${CMAKE_CXX_COMPILER} : ")
	
	file(APPEND ${CMAKE_CURRENT_LIST_DIR}/user-config.jam " ;\n")
	
	list(APPEND EP_ARGS PATCH_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_LIST_DIR}/user-config.jam ${SOURCE_DIR}/tools/build/src/user-config.jam)
	
	list(APPEND BOOST_ARGS toolset=gcc)
	list(APPEND BOOST_ARGS variant=release)
endif()

if(${BUILD_SHARED_LIBS})
	list(APPEND BOOST_ARGS link=shared)
else()
	list(APPEND BOOST_ARGS link=static)
endif()

ExternalProject_Add(boost
	${EP_ARGS}
	BUILD_COMMAND b2 -d0 --prefix=${CMAKE_INSTALL_PREFIX} --with-system --layout=system ${BOOST_ARGS} install
	BUILD_IN_SOURCE 1
	INSTALL_COMMAND ""
)

if (MSVC)
	add_custom_command(TARGET boost
		POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_INSTALL_PREFIX}/lib/boost_system.dll ${CMAKE_INSTALL_PREFIX}/bin/boost_system.dll
		COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_INSTALL_PREFIX}/lib/boost_system.dll
	)
endif()