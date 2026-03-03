cmake_minimum_required(VERSION 3.22)

enable_language(C ASM)

option(SEGGER_RTT_ENABLED "Enable SEGGER RTT library" OFF)
option(UNITY_TESTING_ENABLED "Enable Unity testing framework" OFF)

# Создаём INTERFACE библиотеку для ThirdParty (агрегатор библиотек-субмодулей)
add_library(ThirdParty INTERFACE)

message(STATUS "==== Included modules ====")

# === SEGGER RTT ===
if(SEGGER_RTT_ENABLED)
  add_subdirectory(SEGGER/wrapper)
  target_link_libraries(ThirdParty INTERFACE SeggerRTT)
  message(STATUS "SEGGER RTT ✅")
else()
  message(STATUS "SEGGER RTT ❎")
endif()

# === UNITY Testing Framework ===
if(UNITY_TESTING_ENABLED)
  add_subdirectory(Unity)
  target_link_libraries(ThirdParty INTERFACE unity)
  message(STATUS "Unity ✅")
else()
  message(STATUS "Unity ❎")
endif()

# === FFF Mocking Framework ===
if(UNITY_TESTING_ENABLED)
  add_library(fff INTERFACE)
  target_include_directories(fff INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/fff)
  target_link_libraries(ThirdParty INTERFACE fff)
  message(STATUS "FFF ✅")
else()
  message(STATUS "FFF ❎")
endif()

message(STATUS "==== ---------------- ====")
