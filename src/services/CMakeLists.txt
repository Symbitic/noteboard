# Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

qt_add_qml_module(services
    URI Noteboard.Services
    QML_FILES
        SamsungFrame/SamsungFrame.qml
        SamsungFrame/Service.qml
        ServiceBase.qml
        ServicesList.qml
    RESOURCES
        SamsungFrame/icon.svg
    IMPORTS noteboard.common
)
target_link_libraries(services PRIVATE common)
target_include_directories(services INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
