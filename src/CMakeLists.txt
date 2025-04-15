# Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

add_subdirectory(common)
add_subdirectory(services)

if(ENABLE_GUI)
    add_subdirectory(app)
endif()

if(ENABLE_SERVER)
    add_subdirectory(server)
endif()
