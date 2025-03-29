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

    property alias model: repeater.model
    property alias note: repeater.delegate

    topPadding: 4
    leftPadding: 27
    rightPadding: 27
    bottomPadding: 13

    Label {
        id: title

        width: root.width
        visible: internal.showTitle
        text: qsTr("Notes")
        font: Constants.largeFont
        elide: Text.ElideRight
    }

    GridLayout {
        id: grid

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: title.bottom
        anchors.topMargin: 10
        rowSpacing: 20
        columnSpacing: 20
        columns: internal.columns

        Repeater {
            id: repeater
        }
    }

    QtObject {
        id: internal

        property int columns: 1
        property bool showTitle: false
    }

    states: [
        State {
            name: "desktopLayout"
            when: Constants.layout === Constants.Layout.Desktop

            PropertyChanges {
                target: internal
                columns: 3
                showTitle: true
            }
            AnchorChanges {
                target: grid
                anchors.top: title.bottom
            }
        },
        State {
            name: "mobileLayout"
            when: Constants.layout !== Constants.Layout.Desktop

            PropertyChanges {
                target: internal
                columns: 1
                showTitle: false
            }
            AnchorChanges {
                target: grid
                anchors.top: parent.top
            }
        }
    ]
}
