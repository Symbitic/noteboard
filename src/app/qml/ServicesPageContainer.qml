// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

import QtQml.Models
import QtQuick
import QtQuick.Controls
import Noteboard.Services

ServicesPage {
    required property ServicesList servicesList

    services: servicesList.model
}
