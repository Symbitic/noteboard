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
}
