# Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

qt_add_executable(remote-whiteboard-httpd
    main.cpp
)

target_link_libraries(remote-whiteboard-httpd PRIVATE common Qt6::Core)
