// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import noteboard.common
import Noteboard.Services

Pane {
    id: root

    required property QtObject service

    property SSDP ssdp: service.ssdp
    property ListModel devicesModel: service.devicesModel
    property bool connected: service.connected
    property Settings settings: service.settings

    onConnectedChanged: if (connected && macField.text !== settings.mac) macField.text = settings.mac

    Keys.onEscapePressed: service.home()

    Connections {
        target: scanSwitch

        function onCheckedChanged() {
            settings.autoscan = scanSwitch.checked;
            if (scanSwitch.checked) {
                ssdp.start();
                noDevicesTimer.start();
            } else {
                ssdp.stop();
                noDevicesTimer.stop();
                noDevicesMessage.visible = false;
                devicesModel.clear();
            }
        }
    }

    Timer {
        id: noDevicesTimer
        interval: 2500
        repeat: false
        onTriggered: {
            noDevicesMessage.visible = Qt.binding(() => devicesModel.count === 0)
        }
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 10
        columns: 2

        Label {
            text: qsTr("Samsung Frame")
            horizontalAlignment: Label.AlignHCenter
            padding: 0
            font.pixelSize: Qt.application.font.pixelSize * 2
            Layout.margins: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
        }

        Label {
            text: root.connected ? qsTr("Status: <font color=\"#00FF00\">Connected</font>") : qsTr("Status: <font color=\"#FF0000\">Not connected</font>")
            textFormat: Label.StyledText
            Layout.columnSpan: 2
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("IP:")
        }

        TextField {
            id: ipField
            text: settings.ip
            placeholderText: qsTr("<IP Address>")
            inputMethodHints: Qt.ImhUrlCharactersOnly
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("MAC Address:")
        }

        TextField {
            id: macField
            text: settings.mac
            placeholderText: qsTr("<Optional MAC Address>")
            inputMethodHints: Qt.ImhUrlCharactersOnly
            Layout.fillWidth: true
        }

        RoundButton {
            id: connectButton
            enabled: !root.connected && ipField.length >= 7
            text: qsTr("Connect")
            radius: 5
            onClicked: connectToDevice(ipField.text)
            Layout.bottomMargin: 10
            Layout.columnSpan: 2
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("Scan for TVs:")
            Layout.fillWidth: true
        }

        Switch {
            id: scanSwitch
            checked: settings.autoscan
            Layout.alignment: Qt.AlignRight
        }

        Rectangle {
            id: noDevicesMessage
            visible: false
            color: palette.button
            opacity: 1
            radius: 5
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.preferredHeight: noDevicesLabel.implicitHeight + 20

            Label {
                id: noDevicesLabel
                text: qsTr("No devices found")
                font.bold: true
                anchors.centerIn: parent
            }
        }

        ListView {
            id: devicesView
            model: devicesModel
            clip: true
            spacing: 5
            Layout.columnSpan: 2
            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: ItemDelegate {
                id: device

                required property string host
                required property string name
                required property string manufacturer
                required property string serial

                width: devicesView.width
                height: attributes.implicitHeight

                background: Rectangle {
                    color: device.down ? Qt.darker(palette.button) : device.hovered ? Qt.lighter(palette.button) : palette.button
                    opacity: enabled ? 1 : 0.3
                    radius: 5
                }

                onClicked: ipField.text = host

                Column {
                    id: attributes
                    padding: 10
                    Label {
                        text: device.name
                        font.bold: true
                        textFormat: Text.StyledText
                    }
                    Label {
                        text: device.host
                    }
                    Label {
                        text: device.serial
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (scanSwitch.checked) {
            ssdp.start();
            noDevicesTimer.start();
        }
    }

    Component.onDestruction: {
        if (ssdp.running) {
            ssdp.stop();
        }
    }
}
