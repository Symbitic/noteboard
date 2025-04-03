// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

pragma Singleton
import QtQuick

QtObject {
    enum Theme {
        System,
        Light,
        Dark
    }
    enum View {
        Home,
        Services,
        Settings,
        About,
        Back = -1
    }
    enum Layout {
        Desktop,
        Mobile
    }
    enum Breakpoint {
        Desktop = 1000
    }

    property int layout: Constants.Layout.Mobile
    property int currentView: Constants.View.Home

    readonly property bool isDarkMode: AppSettings.theme === Constants.Theme.Dark || (AppSettings.theme === Constants.Theme.System && Qt.styleHints.colorScheme === Qt.Dark)
    readonly property bool isMobile: Qt.platform.os === "android" || Qt.platform.os === "ios"

    readonly property font largeFont: Qt.font({
        family: Qt.application.font.family,
        pixelSize: Qt.application.font.pixelSize * 2
    })

    function init(item: QtObject) {
        // Make layout responsive.
        Constants.layout = Qt.binding(() => {
            if (item.width >= Constants.Breakpoint.Desktop) {
                return Constants.Layout.Desktop;
            } else {
                return Constants.Layout.Mobile;
            }
        });
    }
}
