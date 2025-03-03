# Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

qt_add_executable(remote-whiteboard
    main.cpp
)

set_target_properties(remote-whiteboard PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

set_source_files_properties(qml/AppSettings.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE true
)

set_source_files_properties(qml/Constants.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE true
)

qt_add_qml_module(remote-whiteboard
    URI RemoteWhiteboard
    QML_FILES
        qml/AppSettings.qml
        qml/Constants.qml
        qml/HomePage.ui.qml
        qml/HomePageContainer.qml
        qml/Main.qml
)

target_link_libraries(remote-whiteboard PRIVATE
    common
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
)
