// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

pragma Singleton
import QtQuick
import QtCore

Settings {
    property int theme: Qt.styleHints.colorScheme === Qt.Dark ? Constants.Theme.Dark : Constants.Theme.Light
}
