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
import noteboard.common

Page {
    id: root

    // Minimum width of note
    property int noteWidth: 280
    property int noteHeight: 150

    property alias model: repeater.model
    property alias note: repeater.delegate
    property alias footerAddButton: footerAddButton
    property alias headerAddButton: headerAddButton

    signal noteClicked(QtObject note)

    padding: 7

    states: [
        State {
            name: "desktopLayout"
            when: Constants.layout === Constants.Layout.Desktop

            PropertyChanges {
                target: internal
                showFooter: false
                showHeader: true
                columnCount: Math.floor(root.availableWidth / noteWidth)
            }
        },
        State {
            name: "mobileLayout"

            PropertyChanges {
                target: internal
                showFooter: true
                showHeader: false
                columnCount: 1
            }
        }
    ]

    header: RowLayout {
        visible: internal.showHeader

        Label {
            elide: Text.ElideRight
            font: Constants.largeFont
            text: qsTr("Notes")
            verticalAlignment: Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.leftMargin: 7
        }

        ToolButton {
            id: headerAddButton
            display: ToolButton.IconOnly
            icon.source: "../icons/add.svg"
            text: qsTr("Add note")
            Layout.rightMargin: 7
        }
    }

    footer: ToolBar {
        visible: internal.showFooter
        ToolButton {
            id: footerAddButton
            anchors.right: parent.right
            display: ToolButton.IconOnly
            icon.source: "../icons/add.svg"
            text: qsTr("Add note")
        }
    }

    QtObject {
        id: internal

        property bool showHeader: false
        property bool showFooter: true
        property int columnCount: 1
        property int cellSize: root.availableWidth / columnCount
    }

    GridView {
        id: repeater
        width: parent.width
        height: parent.height
        cellWidth: internal.cellSize
        cellHeight: noteHeight
    }
}
