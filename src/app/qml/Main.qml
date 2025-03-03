// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
/*
import QtQuick.Controls.Universal
import QtQuick.Controls.Material
*/
import RemoteWhiteboard

Window {
    id: root
    title: qsTr("Remote Whiteboard")
    width: 360
    height: 800
    minimumHeight: 600
    minimumWidth: 270
    visible: true

    /*
    Universal.theme: Constants.isDarkModeActive ? Universal.Dark : Universal.Light
    Material.theme: Constants.isDarkModeActive ? Material.Dark : Material.Light
    */

    property list<string> builtInStyles

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: HomePageContainer {
            builtInStyles: root.builtInStyles
        }
    }
}
