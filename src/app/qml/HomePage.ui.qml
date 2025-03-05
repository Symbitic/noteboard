// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import RemoteWhiteboard

Page {
    id: root

    property list<string> builtInStyles

    padding: 0

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            spacing: 20

            Item {
                id: spacer
                visible: true
            }

            Label {
                Layout.fillWidth: true

                text: qsTr("Remote W")
                color: Constants.secondaryColor
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.pixelSize: AppSettings.fontSize + 4
                font.bold: true
            }

            ToolButton {
                id: settingsButton

                icon.source: Constants.iconSource("settings")
                palette.button: Constants.isDarkMode ? "#30D158" : "#34C759"
                palette.highlight: Constants.isDarkMode ? "#30DB5B" : "#248A3D"
            }
        }
    }
}
