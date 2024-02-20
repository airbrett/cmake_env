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

set(TEMP_DIR ${DEV_ROOT}/artifacts)

function (Main)
	#file(REMOVE_RECURSE ${TEMP_DIR})
	#file(MAKE_DIRECTORY ${TEMP_DIR})
	
	file(STRINGS "${CMAKE_ARGV3}" Lines)
	
	foreach (Line ${Lines})
		unset(PackageArgs)
		
		#handle comments
		string(FIND "${Line}" "#" Pos)
		
		if (NOT Pos EQUAL -1)
			string(SUBSTRING "${Line}" 0 ${Pos} Line)
		endif()
		
		string(LENGTH "${Line}" Len)
		string(STRIP "${Line}" Line)
		
		if (Len GREATER 0)
			#look for package build flags
			string(FIND "${Line}" "," Pos)
			
			if (NOT Pos EQUAL -1)
				string(SUBSTRING "${Line}" 0 ${Pos} PackageName)
				string(STRIP "${PackageName}" PackageName)
				
				math(EXPR Pos "${Pos} + 1")
				
				string(SUBSTRING "${Line}" ${Pos} -1 PackageFlags)
				string(STRIP "${PackageFlags}" PackageFlags)
			else()
				set(PackageName ${Line})
			endif()
			
			#build if not already built
			if (EXISTS "${DEV_ROOT}/${PackageName}")
				message("${PackageName} already built")
			else()
				message("Building ${PackageName}")
				BuildAndInstallPackage(${PackageName})
			endif()
			
			file(TOUCH "${DEV_ROOT}/${PackageName}")
		endif()
	endforeach()
	
	if (EXISTS CMakeLists.txt)
		set(BUILD_DIR ${DEV_ROOT}/Release)
		ConfigureProject(Release ${BUILD_DIR} ${DEV_ROOT}/Release/artifacts)
		
		GetGenerator(${BUILD_DIR} Generator)
		GeneratorIsMulti(${Generator} IsMulti)
		
		if (IsMulti)
			set(BUILD_DIR ${DEV_ROOT}/Debug)
			ConfigureProject(Debug ${BUILD_DIR} ${DEV_ROOT}/Debug/artifacts)
		endif()
	endif()
	
	#file(REMOVE_RECURSE ${TEMP_DIR})
endfunction()

function (BuildAndInstallPackage Package)
	set(BUILD_DIR ${DEV_ROOT}/Release/artifacts_cmake/${Package})
	ConfigurePackage(Release ${BUILD_DIR} ${DEV_ROOT}/Release/artifacts)
	BuildPackage(Release ${BUILD_DIR})
	InstallPackage(Release ${BUILD_DIR})
	
	GetGenerator(${BUILD_DIR} Generator)
	GeneratorIsMulti(${Generator} IsMulti)
	
	if (IsMulti)
		set(BUILD_DIR ${DEV_ROOT}/Debug/artifacts_cmake/${Package})
		ConfigurePackage(Debug ${BUILD_DIR} ${DEV_ROOT}/Debug/artifacts)
		BuildPackage(Debug ${BUILD_DIR})
		InstallPackage(Debug ${BUILD_DIR})
	endif()
endfunction()

function (ConfigureProject BuildType BuildDir InstallDir)
	file(MAKE_DIRECTORY ${BuildDir})
	
	execute_process(
		COMMAND ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=${BuildType} -DCMAKE_INSTALL_PREFIX=${InstallDir} ../..
		WORKING_DIRECTORY ${BuildDir}
		COMMAND_ERROR_IS_FATAL ANY
		COMMAND_ECHO STDOUT 
	)
endfunction()

function (ConfigurePackage BuildType BuildDir InstallDir)
	file(MAKE_DIRECTORY ${BuildDir})
	
	execute_process(
		COMMAND ${CMAKE_COMMAND} ${PackageFlags} -DCMAKE_BUILD_TYPE=${BuildType} -DCMAKE_INSTALL_PREFIX=${InstallDir} -DCACHE_DIR=${CACHE_DIR} -DPACKAGE_DIR=${PACKAGES_DIR} ${PACKAGES_DIR}/${Package}
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
	
	if (NOT ${CMAKE_ARGV4} STREQUAL "single")
		foreach (MultiGenerator ${MultiGenerators})
			string(FIND ${Generator} ${MultiGenerator} Match)
			if (NOT ${Match} EQUAL -1)
				set(${Var} ON)
				break()
			endif()
		endforeach()
	endif()
endmacro()

main()