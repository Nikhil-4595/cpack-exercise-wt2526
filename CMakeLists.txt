cmake_minimum_required(VERSION "3.28")

project("cpackexample" VERSION 0.1.0)

FIND_PACKAGE(deal.II 9.5 REQUIRED
  HINTS ${DEAL_II_DIR} ../ ../../ $ENV{DEAL_II_DIR}
)
DEAL_II_INITIALIZE_CACHED_VARIABLES()

# Uses the FindBoost module of CMake
find_package(Boost 1.83 COMPONENTS filesystem REQUIRED)

find_package(yaml-cpp 0.6 REQUIRED)

# Option for bonus task: allow building the library as shared
option(CPACKEXAMPLE_BUILD_SHARED "Build cpackexamplelib as a shared library" OFF)

if (CPACKEXAMPLE_BUILD_SHARED)
    add_library(cpackexamplelib SHARED
        filesystem/filesystem.cpp
        fem/fem.cpp
        flatset/flatset.cpp
        yamlParser/yamlParser.cpp
    )
else()
    add_library(cpackexamplelib STATIC
        filesystem/filesystem.cpp
        fem/fem.cpp
        flatset/flatset.cpp
        yamlParser/yamlParser.cpp
    )
endif()

add_executable("${PROJECT_NAME}" main.cpp)

target_link_libraries("${PROJECT_NAME}" cpackexamplelib)
target_link_libraries(cpackexamplelib Boost::filesystem ${YAML_CPP_LIBRARIES})

DEAL_II_SETUP_TARGET("${PROJECT_NAME}")
DEAL_II_SETUP_TARGET(cpackexamplelib)

# Install the executable into <prefix>/bin
install(
    TARGETS cpackexample
    RUNTIME DESTINATION bin
)

# Install the library into <prefix>/lib
install(
    TARGETS cpackexamplelib
    ARCHIVE DESTINATION lib      # static libraries (.a)
    LIBRARY DESTINATION lib      # shared libraries (.so)
    INCLUDES DESTINATION include/cpackexamplelib
)

# Install public headers into <prefix>/include/cpackexamplelib
install(
    FILES
        fem/fem.hpp
        filesystem/filesystem.hpp
        flatset/flatset.hpp
        yamlParser/yamlParser.hpp
    DESTINATION include/cpackexamplelib
)

include(cmake/CPackConfig.cmake)
