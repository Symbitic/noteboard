// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#ifndef COMMON_SSDP_H
#define COMMON_SSDP_H

#include <QtCore/qobject.h>
#include <QtCore/qstring.h>
#include <QtQml/qqml.h>
#include <QtQml/qqmllist.h>

#include <QHostAddress>
#include <QUdpSocket>
#include <QTimer>

class SSDP : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    QML_ELEMENT

public:
    explicit SSDP(QObject *parent = nullptr);

    bool running() const;

    Q_INVOKABLE bool start();

public slots:
    void stop();

private slots:
    void processDatagrams();
    void sendDatagram();

Q_SIGNALS:
    void discoverResponse(const QByteArray &msg);
    void runningChanged();

private:
    bool m_running;
    QUdpSocket m_socket4;
    QUdpSocket m_socket6;
    QTimer m_timer;
};

#endif
