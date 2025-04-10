// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import noteboard.common

Page {
    id: root

    ListModel {
        id: devicesModel
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
        id: startupTimer
        interval: 1000
        running: true
        repeat: false
        onTriggered: ssdp.start()
    }

    Timer {
        id: stopTimer
        interval: 10000
        running: true
        repeat: false
        onTriggered: ssdp.stop()
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 10
        columns: 2

        Label {
            text: qsTr("IP:")
        }

        TextField {
            id: ipField
            placeholderText: qsTr("<IP Address>")
            inputMethodHints: Qt.ImhUrlCharactersOnly
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("Found devices:")
            Layout.columnSpan: 2
            Layout.fillWidth: true
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
}
