// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

pragma Singleton
import QtQuick

QtObject {
    readonly property bool isMobileTarget : Qt.platform.os === "android" || Qt.platform.os === "ios"
    readonly property color mainColor : AppSettings.theme === AppSettings.Theme.Dark ? "#09102B" : "#FFFFFF"
    readonly property color secondaryColor : AppSettings.theme === AppSettings.Theme.Dark ? "#FFFFFF" : "#09102B"
    readonly property color highlightColor : "#41CD52"

    function iconName(fileName, addSuffix = true) {
        return `${fileName}${AppSettings.theme === AppSettings.Theme.Dark && addSuffix ? "_Dark.svg" : ".svg"}`
    }
}
