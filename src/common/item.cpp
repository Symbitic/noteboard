// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#include "item.h"

#include <QRandomGenerator>
#include <QtCore/qloggingcategory.h>

Q_LOGGING_CATEGORY(itemLog, "noteboard.common.item")

// QUuid doesn't support v4?
QString Crypto::randomUUID()
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

BoardNotesModel::BoardNotesModel(QObject *parent) : QAbstractListModel(parent) { }

int BoardNotesModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_notes.size();
}

QVariant BoardNotesModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_notes.count()) {
        return QVariant();
    }

    switch (static_cast<Role>(role)) {
    case Role::Title:
        return m_notes.at(index.row()).title();
    case Role::Text:
        return m_notes.at(index.row()).text();
    case Role::Uuid:
        return m_notes.at(index.row()).uuid();
    default:
        break;
    }
    return QVariant();
}

void BoardNotesModel::addNotes(const QList<Note> &notes)
{
    beginInsertRows(QModelIndex{}, rowCount(), rowCount() + notes.size() - 1);
    m_notes.append(notes);
    endInsertRows();
}

QHash<int, QByteArray> BoardNotesModel::roleNames() const
{
    static const QHash<int, QByteArray> names{ { static_cast<int>(Role::Uuid), "uuid" },
                                               { static_cast<int>(Role::Title), "title" },
                                               { static_cast<int>(Role::Text), "text" } };
    return names;
}

bool BoardNotesModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid() || index.row() >= m_notes.size()) {
        return false;
    }

    Note note = m_notes.at(index.row());
    QList<int> roles;
    switch (static_cast<Role>(role)) {
    case Role::Title:
        if (note.title() != value.toString()) {
            note.setTitle(value.toString());
            roles.append(role);
        }
        break;
    case Role::Text:
        if (note.text() != value.toString()) {
            note.setText(value.toString());
            roles.append(role);
        }
        break;
    }

    if (roles.size() > 0) {
        m_notes.replace(index.row(), note);
        emit dataChanged(index, index, roles);
        return true;
    }

    return false;
}
