cmake_minimum_required(VERSION 2.8.12)
project(shaders)

find_package(SDL2 REQUIRED)
find_package(OpenGL REQUIRED)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMake/Modules ${CMAKE_MODULE_PATH})
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall")

add_executable(shaders main.cpp)
target_link_libraries(shaders ${OPENGL_LIBRARIES} ${SDL2_LIBRARIES})
