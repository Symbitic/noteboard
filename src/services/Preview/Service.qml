// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

import QtCore
import QtQml
import QtQuick
import noteboard.common
import ".."

ServiceBase {
    id: service
    name: qsTr("Preview")
    iconUrl: Qt.resolvedUrl("icon.svg")
    pageUrl: Qt.resolvedUrl("Preview.qml")
}
