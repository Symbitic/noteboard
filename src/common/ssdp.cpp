// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#include "ssdp.h"

#include <QNetworkDatagram>
#include <QtCore/qloggingcategory.h>

Q_LOGGING_CATEGORY(ssdpLog, "noteboard.common.ssdp")

SSDP::SSDP(QObject *parent) : QObject(parent), m_socket4(), m_socket6(), m_running(false)
{
    connect(&m_timer, &QTimer::timeout, this, &SSDP::sendDatagram);
}

bool SSDP::running() const
{
    return m_running;
}

bool SSDP::start()
{
    if (m_running) {
        qCWarning(ssdpLog) << "SSDP already running";
        return false;
    }

    if (!m_socket4.bind(QHostAddress::AnyIPv4, 0)) {
        qCWarning(ssdpLog) << "Binding failed:" << m_socket4.errorString();
        return false;
    }

    connect(&m_socket4, &QUdpSocket::readyRead, this, &SSDP::processDatagrams);

    if (m_socket6.bind(QHostAddress::AnyIPv6, m_socket4.localPort())) {
        connect(&m_socket6, &QUdpSocket::readyRead, this, &SSDP::processDatagrams);
    } else {
        qCWarning(ssdpLog) << "Failed to listen on IPv6:" << m_socket6.errorString();
    }

    m_timer.start(1000);

    m_running = true;
    emit runningChanged();
    return true;
}

void SSDP::stop()
{
    if (!m_running) {
        qCWarning(ssdpLog) << "SSDP not running";
        return;
    }
    disconnect(&m_socket4, &QUdpSocket::readyRead, this, &SSDP::processDatagrams);
    disconnect(&m_socket6, &QUdpSocket::readyRead, this, &SSDP::processDatagrams);
    m_timer.stop();
    m_socket4.close();
    m_socket6.close();

    m_running = false;
    emit runningChanged();
}

void SSDP::sendDatagram()
{
    QString ssdpDiscover = "M-SEARCH * HTTP/1.1\r\n"
                           "HOST: 239.255.255.250:1900\r\n"
                           "MAN: \"ssdp:discover\"\r\n"
                           "MX: 1\r\n"
                           "ST: ssdp:all\r\n"
                           "\r\n";

    m_socket4.writeDatagram(ssdpDiscover.toUtf8(), QHostAddress("239.255.255.250"), 1900);

    if (m_socket6.state() == QAbstractSocket::BoundState) {
        m_socket6.writeDatagram(ssdpDiscover.toUtf8(), QHostAddress("ff05::c"), 1900);
    }
}

void SSDP::processDatagrams()
{
    while (m_socket4.hasPendingDatagrams()) {
        QNetworkDatagram datagram = m_socket4.receiveDatagram();
        if (datagram.isValid()) {
            emit discoverResponse(datagram.data());
        }
    }

    while (m_socket6.hasPendingDatagrams()) {
        QNetworkDatagram datagram = m_socket6.receiveDatagram();
        if (datagram.isValid()) {
            emit discoverResponse(datagram.data());
        }
    }
}
