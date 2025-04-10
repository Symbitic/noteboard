// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

import QtQml.Models
import QtQuick
import QtQuick.Controls

ServicesPage {
    services: ListModel {
        ListElement {
            title: qsTr("Samsung Frame")
            description: qsTr("Use a Samsung Frame TV as your noteboard")
            service: "SamsungFrame"
        }
    }
}
