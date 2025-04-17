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

    Keys.onEscapePressed: service.home()
}
