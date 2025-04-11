// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import noteboard.common

Pane {
    id: root

    readonly property string restUrl: "http://%1:8001/api/v2/"

    function connectToDevice(ip: string) {
        const url = restUrl.arg(ip);
        const request = new XMLHttpRequest();
        request.onreadystatechange = () => {
            if (request.readyState !== XMLHttpRequest.DONE || request.status !== 200) {
                return;
            }
            let responseObj = {};
            try {
                responseObj = JSON.parse(request.responseText);
            } catch (_) {
                responseObj = {};
            }
            if (!responseObj || !responseObj.device || responseObj.device["FrameTVSupport"] !== "true") {
                return;
            }

            settings.ip = ip;
            connectedLabel.connected = true;
            connectButton.enabled = false;
            if (responseObj.device["wifiMac"].length > 0) {
                macField.text = responseObj.device["wifiMac"];
                settings.mac = responseObj.device["wifiMac"];
            }
        }
        request.open("GET", url);
        request.send();
    }

    Settings {
        id: settings
        category: "SamsungFrame"
        property string ip: ""
        property string mac: ""
        property alias autoscan: scanSwitch.checked
    }

    ListModel {
        id: devicesModel
    }

    Connections {
        target: scanSwitch

        function onCheckedChanged() {
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

    SSDP {
        id: ssdp

        property list<string> locations: []

        onDiscoverResponse: (data) => {
            // Samsung Frame TVs end in `/dmr`
            const location = /location: (\S+\/dmr)/i;
            if (location.test(data)) {
                const [_, url] = String(data).match(location);
                if (!locations.includes(url)) {
                    locations.push(url);

                    const request = new XMLHttpRequest();
                    request.onreadystatechange = () => {
                        if (request.readyState !== XMLHttpRequest.DONE || request.status !== 200) {
                            return;
                        }
                        const nameRegex = /<friendlyName>([^<]+)<\/friendlyName>/;
                        const manufacturerRegex = /<manufacturer>(.+)<\/manufacturer>/;
                        const modelRegex = /<modelName>(\S+)<\/modelName>/;
                        const serialRegex = /<serialNumber>([0-9a-zA-Z]+)<\/serialNumber>/;
                        const name = nameRegex.test(request.responseText) ? request.responseText.match(nameRegex)[1] : "";
                        const manufacturer = manufacturerRegex.test(request.responseText) ? request.responseText.match(manufacturerRegex)[1] : "";
                        const model = modelRegex.test(request.responseText) ? request.responseText.match(modelRegex)[1] : "";
                        const serial = serialRegex.test(request.responseText) ? request.responseText.match(serialRegex)[1] : "";
                        const host = new URL(request.responseURL).hostname;
                        devicesModel.append({ host, name, manufacturer, model, serial })
                    }
                    request.open("GET", url);
                    request.send();
                }
            }
        }
    }

    Timer {
        id: noDevicesTimer
        interval: 3000
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
            font.pixelSize: Constants.largeFont.pixelSize
            Layout.margins: 0
            Layout.columnSpan: 2
            Layout.fillWidth: true
        }

        Label {
            id: connectedLabel
            text: connected ? qsTr("Status: <font color=\"#00FF00\">Connected</font>") : qsTr("Status: <font color=\"#FF0000\">Not connected</font>")
            textFormat: Label.StyledText
            Layout.columnSpan: 2
            Layout.fillWidth: true

            property bool connected: false
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
            enabled: ipField.length >= 7
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
            checked: true
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
        if (settings.mac) {
            WakeOnLAN.sendPacket(settings.mac);
        }

        if (settings.ip) {
            root.connectToDevice(settings.ip);
        }

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
