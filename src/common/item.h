// Copyright (C) 2025 Alex Shaw <alex.shaw.as@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-only

#ifndef COMMON_BOARDITEM_H
#define COMMON_BOARDITEM_H

#include <QAbstractListModel>
#include <QAbstractItemModel>
#include <QString>
#include <QObject>
#include <QtQml/qqml.h>

class Crypto : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
public:
    Q_INVOKABLE static QString randomUUID();
};

class Note
{
    Q_GADGET
    QML_VALUE_TYPE(note)
    QML_STRUCTURED_VALUE
    Q_PROPERTY(QString text READ text WRITE setText)
    Q_PROPERTY(QString title READ title WRITE setTitle)
    Q_PROPERTY(QString uuid READ uuid WRITE setUuid)
public:
    Note() : m_title(), m_text(), m_uuid(Crypto::randomUUID()) { }

    Q_INVOKABLE Note(const QString &text)
        : m_title(), m_text(text), m_uuid(Crypto::randomUUID()) { }

    Note(const QString &title, const QString &text)
        : m_title(title), m_text(text), m_uuid(Crypto::randomUUID())
    {
    }

    Note(const QString &title, const QString &text, const QString &uuid)
        : m_title(title), m_text(text), m_uuid(uuid)
    {
    }

    QString text() const { return m_text; }
    void setText(const QString &text)
    {
        if (m_text != text) {
            m_text = text;
        }
    }
    QString title() const { return m_title; }
    void setTitle(const QString &title)
    {
        if (m_title != title) {
            m_title = title;
        }
    }
    QString uuid() const { return m_uuid; }
    void setUuid(const QString &uuid)
    {
        if (m_uuid != uuid) {
            m_uuid = uuid;
        }
    }

private:
    QString m_text = "";
    QString m_title = "";
    QString m_uuid = "";
};

class BoardNotesModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    enum Role {
        Uuid = Qt::UserRole + 1,
        Title,
        Text,
    };
    Q_ENUM(Role)

    BoardNotesModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Role::Title) override;

    Q_INVOKABLE void addNotes(const QList<Note> &notes);

private:
    QList<Note> m_notes;
};

#endif
