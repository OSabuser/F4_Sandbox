cmake_minimum_required(VERSION 3.22)

#
# This file is generated only once,
# and is not re-generated if converter is called multiple times.
#
# User is free to modify the file as much as necessary
#

# Setup compiler settings
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)

# Фикс путей в compile_commands.json, по умолчанию OFF
# Используется только при сборке в контейнере
option(FIX_COMPILE_COMMANDS_PATHS 
       "Fix container paths in compile_commands.json for host IDE" 
       OFF)


# Define the build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug")
endif()

# Set the project name
set(CMAKE_PROJECT_NAME General)

# Enable compile command to ease indexing with e.g. clangd
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

# Core project settings
project(${CMAKE_PROJECT_NAME})
message("Build type: " ${CMAKE_BUILD_TYPE})

# Enable CMake support for ASM and C languages
enable_language(C ASM)

# Create an executable object type
add_executable(${CMAKE_PROJECT_NAME})

# Add STM32CubeMX generated sources
add_subdirectory(cmake/stm32cubemx)

# Link directories setup
target_link_directories(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user defined library search paths
)

# Add sources to executable
target_sources(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user sources here
)

# Add include paths
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user defined include paths
)

# Add project symbols (macros)
target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE
    # Add user defined symbols
)

# Remove wrong libob.a library dependency when using cpp files
list(REMOVE_ITEM CMAKE_C_IMPLICIT_LINK_LIBRARIES ob)

# Add linked libraries
target_link_libraries(${CMAKE_PROJECT_NAME}
    stm32cubemx

    # Add user defined libraries
)

# Add custom commands to generate .bin and .hex files
add_custom_command(
  TARGET ${CMAKE_PROJECT_NAME}
  POST_BUILD
  COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${CMAKE_PROJECT_NAME}>
          ${PROJECT_SOURCE_DIR}/build/${CMAKE_PROJECT_NAME}.bin
  COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${CMAKE_PROJECT_NAME}>
          ${PROJECT_SOURCE_DIR}/build/${CMAKE_PROJECT_NAME}.hex
  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/compile_commands.json
          ${PROJECT_SOURCE_DIR}/build
  COMMENT "Building ${CMAKE_PROJECT_NAME}.bin and ${CMAKE_PROJECT_NAME}.hex")


if(FIX_COMPILE_COMMANDS_PATHS)
    # Определяем пути
    set(CONTAINER_PATH "/usr/workspace" CACHE STRING "Path inside container")
    set(HOST_PATH "" CACHE STRING "Path on host")

    message(STATUS "Path fixing enabled: ${CONTAINER_PATH} -> ${HOST_PATH}")

    if(HOST_PATH STREQUAL "")
        message(WARNING "FIX_COMPILE_COMMANDS_PATHS is ON but HOST_PATH is not set. Skipping path fix.")
    else()
        # Копируем и исправляем compile_commands.json
        add_custom_target(fix_compile_commands ALL
            COMMAND ${CMAKE_COMMAND} -E copy 
                ${CMAKE_BINARY_DIR}/compile_commands.json 
                ${CMAKE_BINARY_DIR}/compile_commands.json.bak
            COMMAND sed 
                "s|${CONTAINER_PATH}|${HOST_PATH}|g" 
                ${CMAKE_BINARY_DIR}/compile_commands.json.bak > ${CMAKE_BINARY_DIR}/compile_commands.json
            COMMAND ${CMAKE_COMMAND} -E remove 
                ${CMAKE_BINARY_DIR}/compile_commands.json.bak
            DEPENDS ${CMAKE_BINARY_DIR}/compile_commands.json
            COMMENT "Fixing paths in compile_commands.json: ${CONTAINER_PATH} -> ${HOST_PATH}"
            VERBATIM
        )
    endif()

endif()
