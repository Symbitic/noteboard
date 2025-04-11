// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#include "wakeonlan.h"

#include <QRegularExpression>
#include <QUdpSocket>
#include <QtCore/qloggingcategory.h>

Q_LOGGING_CATEGORY(wakeonlanLog, "noteboard.common.wakeonlan")

void WakeOnLAN::sendPacket(const QString &macAddress)
{
    if (macAddress.isEmpty()) {
        qCDebug(wakeonlanLog) << "Empty MAC Address - WOL Packet not sent";
        return;
    }
    QString mac = macAddress;
    mac.remove(QRegularExpression("[^A-Fa-f0-9]"));
    if (mac.length() != 12) {
        return;
    }
    QUdpSocket socket;
    QByteArray bytes = QByteArray::fromHex(mac.toUtf8());
    QByteArray packet(6, 0xFF);
    for (int i = 0; i < 16; i++) {
        packet.append(bytes);
    }
    socket.writeDatagram(packet, QHostAddress::Broadcast, 9);
}
