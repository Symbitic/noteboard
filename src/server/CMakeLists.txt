# Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

qt_add_executable(remote-whiteboard-server
    main.cpp
)

target_link_libraries(remote-whiteboard-server PRIVATE
    common
    Qt::Core
    Qt::Network
)
