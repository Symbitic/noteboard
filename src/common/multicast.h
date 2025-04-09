// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#ifndef COMMON_MULTICAST_H
#define COMMON_MULTICAST_H

#include <QtCore/qobject.h>
#include <QtCore/qstring.h>
#include <QtQml/qqml.h>
#include <QtQml/qqmllist.h>

#include <QHostAddress>
#include <QUdpSocket>

class MulticastReceiver : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString group READ group WRITE setGroup NOTIFY groupUpdated)
    Q_PROPERTY(bool ipv6 READ ipv6 WRITE setIpv6 NOTIFY ipv6Updated)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portUpdated)
    Q_PROPERTY(bool running READ running NOTIFY runningUpdated)
    QML_ELEMENT

public:
    MulticastReceiver();

    QString group() const;
    void setGroup(const QString &group);

    bool ipv6() const;
    void setIpv6(bool ipv6);

    int port() const;
    void setPort(int port);

    bool running() const;

    Q_INVOKABLE bool start();

public slots:
    void stop();

private slots:
    void processDatagrams();

Q_SIGNALS:
    void data(const QByteArray &datagram);
    void groupUpdated();
    void ipv6Updated();
    void portUpdated();
    void runningUpdated();

private:
    QUdpSocket m_socket;
    QHostAddress m_group;
    bool m_ipv6;
    int m_port;
    bool m_running;
};

#endif
