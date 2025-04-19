// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

import QtQuick

/**
 * Component responsible for maintaining all service instances.
 */
Item {
    id: root

    required property Board board

    /**
     * List of every service name.
     * 
     * A service must be added here to be visible to the user.
     */
    readonly property list<string> serviceNames: [
        "SamsungFrame",
        "Preview"
    ]
    /** Array of loaded service controllers. */
    readonly property list<ServiceBase> services: []
    /** Alias to `services` (for consistency with QML naming). */
    property alias model: root.services

    /**
     * Initialize `services` by creating each component listed in `serviceNames`.
     */
    Component.onCompleted: serviceNames.forEach((serviceName) => {
        const component = Qt.createComponent("%1/Service.qml".arg(serviceName));
        if (component.status === Component.Ready) {
            const service = component.createObject(parent, { board });
            services.push(service);
        } else {
            console.log("Failed to create %1: %2".arg(serviceName).arg(component.errorString()));
        }
    });
}
