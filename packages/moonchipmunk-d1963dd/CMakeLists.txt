cmake_minimum_required(VERSION 3.17)

project(Project)

include(FetchContent)

set(SOURCE_DIR ${CACHE_DIR}/moonchipmunk-d1963dd)

list(APPEND EP_ARGS GIT_REPOSITORY https://github.com/stetre/moonchipmunk.git)
list(APPEND EP_ARGS GIT_TAG d1963dd)
list(APPEND EP_ARGS SOURCE_DIR ${SOURCE_DIR})

FetchContent_Declare(content
	${EP_ARGS}
)

FetchContent_MakeAvailable(content)

