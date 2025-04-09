// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#include "multicast.h"

#include <QNetworkDatagram>

MulticastReceiver::MulticastReceiver()
{
    connect(&m_socket, &QUdpSocket::readyRead, this, &MulticastReceiver::processDatagrams);
}

QString MulticastReceiver::group() const
{
    return m_group.toString();
}

void MulticastReceiver::setGroup(const QString &group)
{
    if (m_group.toString() != group) {
        m_group.setAddress(group);
        emit groupUpdated();
    }
}

bool MulticastReceiver::ipv6() const
{
    return m_ipv6;
}

void MulticastReceiver::setIpv6(bool ipv6)
{
    if (m_ipv6 != ipv6) {
        m_ipv6 = ipv6;
        emit ipv6Updated();
    }
}

int MulticastReceiver::port() const
{
    return m_port;
}

void MulticastReceiver::setPort(int port)
{
    if (m_port != port) {
        m_port = port;
        emit portUpdated();
    }
}

bool MulticastReceiver::running() const
{
    return m_running;
}

bool MulticastReceiver::start()
{
    if (m_running) {
        // qWarning() << "MulticastReceiver already running";
        return false;
    }

    const auto address = ipv6() ? QHostAddress::AnyIPv6 : QHostAddress::AnyIPv4;

    if (!m_socket.bind(address, port(), QUdpSocket::ShareAddress)) {
        return false;
    }
    if (!m_socket.joinMulticastGroup(m_group)) {
        return false;
    }

    m_running = true;
    emit runningUpdated();
    return true;
}

void MulticastReceiver::stop()
{
    if (!m_running) {
        // qWarning() << "MulticastReceiver not running";
        return;
    }
    m_socket.close();

    m_running = false;
    emit runningUpdated();
}

void MulticastReceiver::processDatagrams()
{
    while (m_socket.hasPendingDatagrams()) {
        QNetworkDatagram datagram = m_socket.receiveDatagram();
        if (datagram.isValid()) {
            emit data(datagram.data());
        }
    }
}
