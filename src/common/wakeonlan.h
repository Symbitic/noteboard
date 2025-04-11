// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#ifndef COMMON_WAKEONLAN_H
#define COMMON_WAKEONLAN_H

#include <QtCore/qobject.h>
#include <QtCore/qstring.h>
#include <QtQml/qqml.h>
#include <QtQml/qqmllist.h>

class WakeOnLAN : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
public:
    Q_INVOKABLE void sendPacket(const QString &macAddress);
};

#endif
