cmake_minimum_required(VERSION 3.28)

project(cpackexample VERSION 0.1.0 LANGUAGES CXX)

find_package(deal.II 9.5 REQUIRED
  HINTS ${DEAL_II_DIR} ../ ../../ $ENV{DEAL_II_DIR}
)
DEAL_II_INITIALIZE_CACHED_VARIABLES()

find_package(Boost 1.83 COMPONENTS filesystem REQUIRED)
find_package(yaml-cpp 0.6 REQUIRED)

add_library(cpackexamplelib
  filesystem/filesystem.cpp
  fem/fem.cpp
  flatset/flatset.cpp
  yamlParser/yamlParser.cpp
)

add_executable(cpackexample main.cpp)

target_link_libraries(cpackexample cpackexamplelib)
target_link_libraries(cpackexamplelib Boost::filesystem yaml-cpp)

DEAL_II_SETUP_TARGET(cpackexample)
DEAL_II_SETUP_TARGET(cpackexamplelib)

install(TARGETS cpackexample RUNTIME DESTINATION bin)
install(TARGETS cpackexamplelib
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)
install(FILES
  fem/fem.hpp
  filesystem/filesystem.hpp
  flatset/flatset.hpp
  yamlParser/yamlParser.hpp
  DESTINATION include/cpackexamplelib
)

include(cmake/CPackConfig.cmake)
