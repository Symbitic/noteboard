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

Rectangle {
    id: notecard

    required property string title
    property alias content: content

    color: palette.midlight
    radius: 12

    Column {
        id: content
        padding: 10
        spacing: 10

        RowLayout {
            spacing: 16

            Label {
                text: notecard.title
                color: palette.text
                font.weight: 600
                Layout.fillWidth: true
            }

            // TODO: trash icon
        }

        Column {
            id: info
            spacing: 5

            Repeater {
                model: [
                    qsTr("Created: %1".arg("TODO")),
                    qsTr("Updated: %1".arg("TODO"))
                ]

                Label {
                    text: modelData
                    font.pixelSize: 12
                    font.weight: 400
                    color: "#898989"
                }
            }
        }
    }
}
