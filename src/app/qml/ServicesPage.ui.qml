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
import Noteboard.Services

Page {
    id: root

    property int cellSize: 200
    property int gridSpacing: 8
    property alias services: repeater.model

    signal serviceClicked(service: QtObject)

    states: [
        State {
            name: "desktop"
            when: Constants.layout === Constants.Layout.Desktop

            PropertyChanges {
                target: title
                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
            }
        },
        State {
            name: "mobile"

            PropertyChanges {
                target: title
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            }
        }
    ]

    GridLayout {
        id: grid
        anchors.fill: parent
        anchors.margins: 10
        columns: Math.max(1, Math.floor((width + gridSpacing) / (cellSize + gridSpacing)))
        rowSpacing: gridSpacing
        columnSpacing: gridSpacing

        Label {
            id: title

            text: qsTr("Services")
            font: Constants.largeFont
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.columnSpan: grid.columns
        }

        Repeater {
            id: repeater

            Rectangle {
                required property QtObject model
                readonly property string name: model.name
                readonly property url iconUrl: model.iconUrl

                color: Qt.lighter(palette.highlight)
                radius: width / 10
                Layout.preferredWidth: cellSize
                Layout.preferredHeight: cellSize
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

                ToolButton {
                    id: icon

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    icon.source: parent.iconUrl
                    icon.width: parent.width - 40
                    icon.height: parent.height - 40
                    icon.color: "white"
                    padding: 0
                    flat: true
                    down: true

                    background: Rectangle {
                        color: "transparent"
                    }
                }

                Label {
                    text: parent.name
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: icon.bottom
                    font.pointSize: 14
                    font.weight: 600
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.serviceClicked(parent.model)
                }
            }
        }
    }
}
