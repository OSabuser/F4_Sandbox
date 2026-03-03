enable_testing()

# Тест №1
add_executable(test_host_simple test_host_simple.c # ваши тесты на Unity
                                ${PROJECT_SOURCE_DIR}/App/Src/app.c)

target_include_directories(
  test_host_simple PRIVATE ${PROJECT_SOURCE_DIR}/ThirdParty/Unity/src
                           ${PROJECT_SOURCE_DIR}/App/Inc)

target_link_libraries(
  test_host_simple PRIVATE ThirdParty # даёт unity::framework
)

add_test(
  NAME test_host_simple
  COMMAND test_host_simple
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR})

# Тест №2
add_executable(test_host_second test_host_second.c
                                ${PROJECT_SOURCE_DIR}/App/Src/app.c)

target_include_directories(
  test_host_second PRIVATE ${PROJECT_SOURCE_DIR}/ThirdParty/Unity/src
                           ${PROJECT_SOURCE_DIR}/App/Inc)

target_link_libraries(test_host_second PRIVATE ThirdParty)
add_test(
  NAME test_host_second
  COMMAND test_host_second
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
