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

    padding: 7

    required property QtObject note
    readonly property string uuid: note.uuid

    header: TextField {
            id: titleInput
            text: note.title
            font.styleName: "Bold"
            padding: 0
            background: null
            wrapMode: TextField.Wrap
            onEditingFinished: note.title = text
        }

    states: [
        State {
            name: "desktopLayout"
            when: Constants.layout === Constants.Layout.Desktop

            PropertyChanges {
                target: internal
                showFooter: false
                showHeader: true
            }
        },
        State {
            name: "mobileLayout"

            PropertyChanges {
                target: internal
                showFooter: true
                showHeader: false
            }
        }
    ]

    QtObject {
        id: internal

        property bool showHeader: false
        property bool showFooter: true
    }

    TextArea {
            id: textArea
            anchors.fill: parent
            leftPadding: 15
            rightPadding: doneButton.width
            bottomPadding: 10
            topPadding: 10
            placeholderText: qsTr("Write a note...")
            text: root.note.text
            wrapMode: TextArea.Wrap
            clip: true
            onEditingFinished: note.text = text

            Button {
                id: doneButton
                text: qsTr("Done")
                flat: true
                visible: textArea.focus
                onClicked: textArea.editingFinished()
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }
    }
}
