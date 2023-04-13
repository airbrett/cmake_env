#Multi configuration generators
unset(MultiGenerators)
list(APPEND MultiGenerators "Visual Studio")
list(APPEND MultiGenerators "XCode")
list(APPEND MultiGenerators "Ninja Multi-Config")
list(APPEND MultiGenerators "Green Hills MULTI")

#Some directories
set(PACKAGES_DIR ${CMAKE_CURRENT_LIST_DIR}/packages)
set(CACHE_DIR ${CMAKE_CURRENT_LIST_DIR}/cache)
set(DEV_ROOT ${CMAKE_ARGV3})

get_filename_component(DEV_ROOT ${DEV_ROOT} NAME_WE)

#Ensure we have an environment directory in absolute path
if (NOT EXISTS ${DEV_ROOT})
	file(MAKE_DIRECTORY ${DEV_ROOT})
endif()

get_filename_component(DEV_ROOT ${DEV_ROOT} ABSOLUTE)

set(TEMP_DIR ${DEV_ROOT}/dev_root)

#All arguments following the requirements.cmake file are assumed to be arguments to be passed to cmake when
#configuring & building
unset(EXTERNAL_ARGS)
math(EXPR ARGS_MAX "${CMAKE_ARGC} - 1")

if (${CMAKE_ARGC} GREATER 4)
	foreach (i RANGE 4 ${ARGS_MAX})
		list(APPEND EXTERNAL_ARGS ${CMAKE_ARGV${i}})
	endforeach()
endif()



function (Main)
	#file(REMOVE_RECURSE ${TEMP_DIR})
	#file(MAKE_DIRECTORY ${TEMP_DIR})
	
	file(STRINGS "${CMAKE_ARGV3}" Lines)
	
	foreach (Line ${Lines})
		#handle comments
		string(FIND "${Line}" "#" Pos)
		
		if (NOT Pos EQUAL -1)
			string(SUBSTRING "${Line}" 0 ${Pos} Line)
		endif()
		
		string(LENGTH "${Line}" Len)
		string(STRIP "${Line}" Line)
		
		if (Len GREATER 0)
			if (EXISTS "${DEV_ROOT}/${Line}")
				message("${Line} already built")
			else()
				message("Building ${Line}")
				BuildAndInstallPackage(${Line})
			endif()
			
			file(TOUCH "${DEV_ROOT}/${Line}")
		endif()
	endforeach()
	
	if (EXISTS CMakeLists.txt)
		set(BUILD_DIR ${DEV_ROOT}/Release)
		ConfigureProject(Release ${BUILD_DIR} ${DEV_ROOT}/Release/dev_root)
		
		GetGenerator(${BUILD_DIR} Generator)
		GeneratorIsMulti(${Generator} IsMulti)
		
		if (IsMulti)
			set(BUILD_DIR ${DEV_ROOT}/Debug)
			ConfigureProject(Debug ${BUILD_DIR} ${DEV_ROOT}/Debug/dev_root)
		endif()
	endif()
	
	#file(REMOVE_RECURSE ${TEMP_DIR})
endfunction()

function (BuildAndInstallPackage Package)
	set(BUILD_DIR ${DEV_ROOT}/Release/dev_root_build/${Package})
	ConfigurePackage(Release ${BUILD_DIR} ${DEV_ROOT}/Release/dev_root)
	BuildPackage(Release ${BUILD_DIR})
	InstallPackage(Release ${BUILD_DIR})
	
	GetGenerator(${BUILD_DIR} Generator)
	GeneratorIsMulti(${Generator} IsMulti)
	
	if (IsMulti)
		set(BUILD_DIR ${DEV_ROOT}/Debug/dev_root_build/${Package})
		ConfigurePackage(Debug ${BUILD_DIR} ${DEV_ROOT}/Debug/dev_root)
		BuildPackage(Debug ${BUILD_DIR})
		InstallPackage(Debug ${BUILD_DIR})
	endif()
endfunction()

function (ConfigureProject BuildType BuildDir InstallDir)
	file(MAKE_DIRECTORY ${BuildDir})
	
	execute_process(
		COMMAND ${CMAKE_COMMAND} ${EXTERNAL_ARGS} -DCMAKE_BUILD_TYPE=${BuildType} -DCMAKE_INSTALL_PREFIX=${InstallDir} ../..
		WORKING_DIRECTORY ${BuildDir}
		COMMAND_ERROR_IS_FATAL ANY
		#COMMAND_ECHO STDOUT 
	)
endfunction()

function (ConfigurePackage BuildType BuildDir InstallDir)
	file(MAKE_DIRECTORY ${BuildDir})
	
	execute_process(
		COMMAND ${CMAKE_COMMAND} ${EXTERNAL_ARGS} -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=${BuildType} -DCMAKE_INSTALL_PREFIX=${InstallDir} -DCACHE_DIR=${CACHE_DIR} -DPACKAGE_DIR=${PACKAGES_DIR} ${PACKAGES_DIR}/${Package}
		WORKING_DIRECTORY ${BuildDir}
		COMMAND_ERROR_IS_FATAL ANY
		#COMMAND_ECHO STDOUT 
	)
endfunction()
	
function (BuildPackage BuildType BuildDir)
	execute_process(
		COMMAND ${CMAKE_COMMAND} --build . --config ${BuildType}
		WORKING_DIRECTORY ${BuildDir}
		COMMAND_ERROR_IS_FATAL ANY
		#COMMAND_ECHO STDOUT 
	)
endfunction()

function (InstallPackage BuildType BuildDir)
	execute_process(
		COMMAND ${CMAKE_COMMAND} --install . --config ${BuildType}
		WORKING_DIRECTORY ${BuildDir}
		COMMAND_ERROR_IS_FATAL ANY
		#COMMAND_ECHO STDOUT 
	)
endfunction()

macro (GetGenerator BuildDir Var)
	set(Key "CMAKE_GENERATOR:INTERNAL=")
	file(STRINGS ${BuildDir}/CMakeCache.txt ${Var} REGEX ${Key})
	string(LENGTH ${Key} Len)
	string(SUBSTRING ${${Var}} ${Len} -1 ${Var})
endmacro()

macro (GeneratorIsMulti Generator Var)
	set(${Var} OFF)
	
	foreach (MultiGenerator ${MultiGenerators})
		string(FIND ${Generator} ${MultiGenerator} Match)
		if (NOT ${Match} EQUAL -1)
			set(${Var} ON)
			break()
		endif()
	endforeach()
endmacro()

main()