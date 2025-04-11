# Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

qt_add_qml_module(common
    URI noteboard.common
    VERSION 1.0
    SOURCES
        board.cpp board.h
        item.cpp item.h
        ssdp.cpp ssdp.h
        wakeonlan.cpp wakeonlan.h
)
target_link_libraries(common PRIVATE Qt::Core Qt::Network Qt::Quick)
target_include_directories(common INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
