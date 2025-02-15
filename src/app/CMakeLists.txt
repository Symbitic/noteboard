# Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

qt_add_executable(remote-whiteboard
    main.cpp
)

target_link_libraries(remote-whiteboard PRIVATE
    common
    Qt::Gui
    Qt::Quick
    Qt::QuickControls2
)
