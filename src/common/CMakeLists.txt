# Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

qt_add_library(common OBJECT
    todo.cpp todo.h
)
target_link_libraries(common PRIVATE Qt::Core Qt::Network)
target_include_directories(common INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
