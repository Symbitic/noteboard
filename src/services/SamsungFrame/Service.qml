// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

import QtCore
import QtQml
import QtQuick
import noteboard.common
import ".."

ServiceBase {
    id: service
    name: qsTr("Samsung Frame")
    iconUrl: Qt.resolvedUrl("icon.svg")
    pageUrl: Qt.resolvedUrl("SamsungFrame.qml")

    property bool connected: false

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
            connected = true;
            if (responseObj.device["wifiMac"].length > 0) {
                settings.mac = responseObj.device["wifiMac"];
            }
        }
        request.open("GET", url);
        request.send();
    }

    property Settings settings: Settings {
        category: "SamsungFrame"
        property string ip: ""
        property string mac: ""
        property bool autoscan: true
    }

    property ListModel devicesModel: ListModel {}

    property SSDP ssdp: SSDP {
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

    Component.onCompleted: {
        if (settings.mac) {
            WakeOnLAN.sendPacket(settings.mac);
        }

        if (settings.ip) {
            connectToDevice(settings.ip);
        }
    }
}
