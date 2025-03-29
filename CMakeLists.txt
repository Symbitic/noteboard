# Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.16)

project(noteboard
    VERSION "0.0.0"
    DESCRIPTION "Noteboard"
    LANGUAGES CXX C
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(ENABLE_GUI "Build the GUI" ON)
option(ENABLE_SERVER "Build the server" ON)

find_package(Qt6 CONFIG REQUIRED COMPONENTS Core Gui Network)
find_package(Qt6 CONFIG OPTIONAL_COMPONENTS HttpServer LinguistTools Quick QuickControls2)
qt_standard_project_setup(REQUIRES 6.8 I18N_TRANSLATED_LANGUAGES en en_AU fr)

if(NOT ENABLE_GUI AND NOT ENABLE_SERVER)
    message(NOTICE "No build targets have been enabled.")
    return()
elseif(ENABLE_GUI AND NOT (TARGET Qt6::Quick AND TARGET Qt6::QuickControls2))
    message(NOTICE "Missing Qt6 QuickControls2 for GUI target")
    return()
elseif(ENABLE_SERVER AND NOT TARGET Qt6::HttpServer)
    message(NOTICE "Missing Qt6 HttpServer for server target")
    return()
endif()

add_subdirectory(src)
