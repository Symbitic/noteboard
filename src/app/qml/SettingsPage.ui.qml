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

    property alias stylesComboBox: stylesComboBox
    property alias themesComboBox: themesComboBox
    property alias styles: stylesComboBox.model
    property alias themes: themesComboBox.model
    property alias currentStyleIndex: stylesComboBox.currentIndex
    property alias currentThemeIndex: themesComboBox.currentIndex
    property alias showStyleTip: styleTip.visible

    padding: 10

    ToolTip {
        id: styleTip

        text: qsTr("Please restart the application to apply the new style")
        timeout: 5000
        anchors.centerIn: parent
    }

    GridLayout {
        id: grid
        width: parent.width
        anchors.margins: 10
        columns: 2

        Label {
            text: qsTr("Style:")
        }
        ComboBox {
            id: stylesComboBox
            Layout.alignment: Qt.AlignRight
        }

        Label {
            text: qsTr("Theme:")
            enabled: themesComboBox.count > 0
        }
        ComboBox {
            id: themesComboBox
            enabled: count > 0
            Layout.alignment: Qt.AlignRight
        }
    }

    // Visualize colors for debugging
    ScrollView {
        width: root.width
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: grid.bottom
        anchors.bottom: parent.bottom

        Grid {
            anchors.fill: parent
            anchors.margins: 4
            spacing: 5
            width: root.width
            columns: Math.floor(root.width / (190 + 2))

            Repeater {
                model: [
                    { title: "palette.window", color: palette.window },
                    { title: "palette.windowText", color: palette.windowText },
                    { title: "palette.base", color: palette.base },
                    { title: "palette.alternateBase", color: palette.alternateBase },
                    { title: "palette.toolTipBase", color: palette.toolTipBase },
                    { title: "palette.toolTipText", color: palette.toolTipText },
                    { title: "palette.placeholderText", color: palette.placeholderText },
                    { title: "palette.text", color: palette.text },
                    { title: "palette.button", color: palette.button },
                    { title: "palette.buttonText", color: palette.buttonText },
                    { title: "palette.brightText", color: palette.brightText },
                    { title: "palette.light", color: palette.light },
                    { title: "palette.dark", color: palette.dark },
                    { title: "palette.midlight", color: palette.midlight },
                    { title: "palette.mid", color: palette.mid },
                    { title: "palette.highlight", color: palette.highlight },
                    { title: "palette.accent", color: palette.accent },
                    { title: "palette.link", color: palette.link },
                ]

                Rectangle {
                    required property string title
                    required color

                    readonly property color textColor: Constants.isDarkMode ? Qt.darker(color, 4) : Qt.lighter(color, 4)

                    width: 180
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
