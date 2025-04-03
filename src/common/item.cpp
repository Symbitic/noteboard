// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#include "item.h"

#include <QRandomGenerator>

// QUuid doesn't support v4?
static inline QString randomUUID()
{
    QByteArray bytes(16, Qt::Uninitialized);
    QRandomGenerator::global()->generate(bytes.begin(), bytes.end());

    bytes[6] = (bytes[6] & 0x0F) | 0x40;
    bytes[8] = (bytes[8] & 0x3F) | 0x80;

    QString uuid = QString::fromLatin1(bytes.toHex());
    uuid.replace(8, 0, QStringLiteral("-"));
    uuid.replace(13, 0, QStringLiteral("-"));
    uuid.replace(18, 0, QStringLiteral("-"));
    uuid.replace(23, 0, QStringLiteral("-"));

    return uuid;
}

BoardItem::BoardItem(QObject *parent)
    : QObject(parent),
      m_uuid(randomUUID()),
      m_text(""),
      m_createdDate(QDateTime::currentDateTime()),
      m_modifiedDate(QDateTime::currentDateTime())
{
}

BoardItem::BoardItem(const BoardItem &other)
    : QObject(nullptr),
      m_uuid(other.m_uuid),
      m_text(other.m_text),
      m_createdDate(other.m_createdDate),
      m_modifiedDate(other.m_modifiedDate)
{
}

QString BoardItem::id() const
{
    return m_uuid;
}

QString BoardItem::text() const
{
    return m_text;
}

QDateTime BoardItem::createdDate() const
{
    return m_createdDate;
}

QDateTime BoardItem::modifiedDate() const
{
    return m_modifiedDate;
}

void BoardItem::setText(const QString &text)
{
    if (m_text == text) {
        return;
    }
    m_text = text;
    m_modifiedDate = QDateTime::currentDateTime();
    emit dataChanged();
}
