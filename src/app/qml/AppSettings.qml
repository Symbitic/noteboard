// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

pragma Singleton
import QtQuick
import QtCore

Settings {
    property string style
    property int theme: Constants.Theme.System
    property url filepath: `${StandardPaths.writableLocation(StandardPaths.DocumentsLocation)}/NOTES.md`
}
