# Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

qt_add_executable(noteboard
    main.cpp
)

set_target_properties(noteboard PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_GUI_IDENTIFIER "io.symbitic.noteboard"
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
)

set_source_files_properties(qml/AppSettings.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE true
)

set_source_files_properties(qml/Constants.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE true
)

qt_add_qml_module(noteboard
    URI Noteboard
    QML_FILES
        qml/AboutPage.ui.qml
        qml/AboutPageContainer.qml
        qml/AppSettings.qml
        qml/Constants.qml
        qml/HomePage.ui.qml
        qml/HomePageContainer.qml
        qml/Main.qml
        qml/ServicesPage.ui.qml
        qml/ServicesPageContainer.qml
        qml/SettingsPage.ui.qml
        qml/SettingsPageContainer.qml
        qml/SideBar.ui.qml
    RESOURCES
        icons/drawer.svg
        icons/info.svg
        icons/services.svg
        icons/settings.svg
        icons/sticky.svg
)

target_link_libraries(noteboard PRIVATE
    common
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
)

install(TARGETS noteboard
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

qt_generate_deploy_qml_app_script(
    TARGET noteboard
    OUTPUT_SCRIPT deploy_script
    MACOS_BUNDLE_POST_BUILD
    NO_UNSUPPORTED_PLATFORM_ERROR
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install(SCRIPT ${deploy_script})
