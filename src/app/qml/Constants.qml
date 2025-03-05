// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

pragma Singleton
import QtQuick

QtObject {
    enum Theme {
        Light,
        Dark
    }

    readonly property bool isDarkMode: AppSettings.theme === Constants.Theme.Dark
    readonly property bool isMobile: Qt.platform.os === "android" || Qt.platform.os === "ios"
    readonly property color mainColor: isDarkMode ? "#09102B" : "#FFFFFF"
    readonly property color secondaryColor: isDarkMode ? "#FFFFFF" : "#09102B"
    readonly property color highlightColor: "#41CD52"

    function iconSource(filename) {
        return `qrc:/qt/qml/RemoteWhiteboard/icons/${filename}${isDarkMode ? "-dark.svg" : ".svg"}`
    }
}
