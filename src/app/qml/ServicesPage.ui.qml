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

Page {
    id: root

    signal serviceClicked(service: string, title: string)

    property alias services: repeater.model

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
        columns: Math.max(1, Math.floor((width + gridSpacing) / (rectSize + gridSpacing)))
        rowSpacing: gridSpacing
        columnSpacing: gridSpacing

        property int gridSpacing: 8
        property int rectSize: 200

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
                required property string title
                required property string description
                required property string service

                color: Qt.lighter(palette.highlight)
                radius: width / 10
                Layout.preferredWidth: grid.rectSize
                Layout.preferredHeight: grid.rectSize
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

                ToolButton {
                    id: icon

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    icon.source: Qt.resolvedUrl(`../icons/services/${parent.service}.svg`)
                    icon.width: grid.rectSize - 40
                    icon.height: grid.rectSize - 40
                    icon.color: "white"
                    padding: 0
                    flat: true
                    down: true

                    background: Rectangle {
                        color: "transparent"
                    }
                }

                Label {
                    text: parent.title
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: icon.bottom
                    font.pointSize: 14
                    font.weight: 600
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.serviceClicked(parent.service, parent.title)
                }
            }
        }
    }
}
