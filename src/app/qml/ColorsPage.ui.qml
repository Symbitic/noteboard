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

    property int columnCount: Math.floor(width / (190 + 2))

    ScrollView {
        width: root.width
        anchors.fill: parent

        Grid {
            anchors.fill: parent
            anchors.margins: 4
            spacing: 5
            width: root.width
            columns: root.columnCount

            Repeater {
                model: [
                    { title: "palette.active.window", color: palette.active.window },
                    { title: "palette.active.windowText", color: palette.active.windowText },
                    { title: "palette.active.base", color: palette.active.base },
                    { title: "palette.active.alternateBase", color: palette.active.alternateBase },
                    { title: "palette.active.toolTipBase", color: palette.active.toolTipBase },
                    { title: "palette.active.toolTipText", color: palette.active.toolTipText },
                    { title: "palette.active.placeholderText", color: palette.active.placeholderText },
                    { title: "palette.active.text", color: palette.active.text },
                    { title: "palette.active.button", color: palette.active.button },
                    { title: "palette.active.buttonText", color: palette.active.buttonText },
                    { title: "palette.active.brightText", color: palette.active.brightText },
                    { title: "palette.active.light", color: palette.active.light },
                    { title: "palette.active.dark", color: palette.active.dark },
                    { title: "palette.active.midlight", color: palette.active.midlight },
                    { title: "palette.active.mid", color: palette.active.mid },
                    { title: "palette.active.highlight", color: palette.active.highlight },
                    { title: "palette.active.accent", color: palette.active.accent },
                    { title: "palette.active.link", color: palette.active.link },

                    { title: "palette.inactive.window", color: palette.inactive.window },
                    { title: "palette.inactive.windowText", color: palette.inactive.windowText },
                    { title: "palette.inactive.base", color: palette.inactive.base },
                    { title: "palette.inactive.alternateBase", color: palette.inactive.alternateBase },
                    { title: "palette.inactive.toolTipBase", color: palette.inactive.toolTipBase },
                    { title: "palette.inactive.toolTipText", color: palette.inactive.toolTipText },
                    { title: "palette.inactive.placeholderText", color: palette.inactive.placeholderText },
                    { title: "palette.inactive.text", color: palette.inactive.text },
                    { title: "palette.inactive.button", color: palette.inactive.button },
                    { title: "palette.inactive.buttonText", color: palette.inactive.buttonText },
                    { title: "palette.inactive.brightText", color: palette.inactive.brightText },
                    { title: "palette.inactive.light", color: palette.inactive.light },
                    { title: "palette.inactive.dark", color: palette.inactive.dark },
                    { title: "palette.inactive.midlight", color: palette.inactive.midlight },
                    { title: "palette.inactive.mid", color: palette.inactive.mid },
                    { title: "palette.inactive.highlight", color: palette.inactive.highlight },
                    { title: "palette.inactive.accent", color: palette.inactive.accent },
                    { title: "palette.inactive.link", color: palette.inactive.link },
                ]

                Rectangle {
                    required property string title
                    required color

                    readonly property color textColor: Constants.isDarkMode ? Qt.darker(color, 4) : Qt.lighter(color, 4)

                    width: 190
                    height: 24
                    border.color: "black"
                    border.width: 1

                    Label {
                        id: label
                        text: parent.title
                        color: "lightblue"
                        font.weight: 500
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
}
